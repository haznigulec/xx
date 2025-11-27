import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/assets/model/us_capra_summary_model.dart';
import 'package:piapiri_v2/app/orders/repository/orders_repository.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_event.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_state.dart';
import 'package:piapiri_v2/app/search_symbol/repository/symbol_search_repository.dart';
import 'package:piapiri_v2/app/search_symbol/symbol_search_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/position_model.dart';
import 'package:piapiri_v2/core/model/stock_item_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolSearchBloc extends PBloc<SymbolSearchState> {
  final SymbolSearchRepository _symbolSearchRepository;

  SymbolSearchBloc({
    required SymbolSearchRepository symbolSearchRepository,
    required OrdersRepository ordersRepository,
  })  : _symbolSearchRepository = symbolSearchRepository,
        super(initialState: const SymbolSearchState()) {
    on<SearchSymbolEvent>(_onSearchSymbol);
    on<SearchFundEvent>(_onSearchFund);
    on<GetOldSearchesEvent>(_onGetOldSearches);
    on<SetOldSearchesEvent>(_onSetOldSearches);
    on<RemoveOldSearchesEvent>(_onRemoveOldSearches);
    on<RemoveExpiredOldSearchesEvent>(_onRemoveExpiredOldSearches);
    on<GetExchangeListEvent>(_onGetExchangeList);
    on<GetUnderlyingListEvent>(_onGetUnderlyingList);
    on<GetMaturityListEvent>(_onGetMaturityList);
    on<GetSymbolSortEvent>(_onGetSymbolSort);
    on<GetPostitionListEvent>(_onGetPostitionList);
  }

  FutureOr<void> _onSearchSymbol(
    SearchSymbolEvent event,
    Emitter<SymbolSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
        searchResults: [],
      ),
    );

    List<String> filterDbKeys = [...event.filterDbKeys];
    bool isPreciousMetals = false;
    bool isParity = false;

    if (filterDbKeys.contains(SymbolSearchFilterEnum.preciousMetals.dbKeys!.first)) {
      isPreciousMetals = true;
      filterDbKeys.remove(SymbolSearchFilterEnum.preciousMetals.dbKeys!.first);
    }
    if (filterDbKeys.contains(SymbolSearchFilterEnum.parity.dbKeys!.first)) {
      isParity = true;
    }
    if (isPreciousMetals && !isParity) {
      filterDbKeys.add(SymbolSearchFilterEnum.parity.dbKeys!.first);
    }

    if (event.underlying != null || event.maturity != null || event.transactionType?.value != null) {
      List<SymbolModel> searchResults = await _symbolSearchRepository.getViopByFilters(
        filter: filterDbKeys.first,
        underlyingName: event.underlying,
        maturityDate: event.maturity,
        transactionType: event.transactionType?.value,
      );
      if (event.symbolName.isNotEmpty) {
        searchResults =
            searchResults.where((element) => element.name.contains(event.symbolName.toUpperCase())).toList();

        // Tam eşleşen sembol en başa alınır
        final exactMatches = searchResults.where((e) => e.name.toUpperCase() == event.symbolName.toUpperCase());
        final others = searchResults.where((e) => e.name.toUpperCase() != event.symbolName.toUpperCase());
        searchResults = [...exactMatches, ...others];
      }

      event.callback(searchResults);
      emit(
        state.copyWith(
          type: PageState.success,
          searchResults: searchResults,
        ),
      );
    } else {
      bool canSearchForeign = filterDbKeys.contains(SymbolSearchFilterEnum.foreign.dbKeys!.first);
      bool canSearchBist = !(canSearchForeign && filterDbKeys.length == 1);

      List responses = await Future.wait([
        if (canSearchBist)
          _symbolSearchRepository.searchSymbol(
            symbolName: event.symbolName,
            exchangeCode: event.exchangeCode,
            isFund: filterDbKeys.length == 1 && filterDbKeys.contains(SymbolSearchFilterEnum.fund.dbKeys!.first),
            filterDbKeys: filterDbKeys,
          ),
        if (canSearchForeign)
          _symbolSearchRepository.searchUsSymbol(symbolName: event.symbolName, count: canSearchBist ? 20 : 50),
      ]);

      List<SymbolModel> searchResults = [];

      if (canSearchBist) {
        searchResults.addAll(responses[0]);

        // 🔥 Yalnızca biri seçiliyse (biri true, diğeri false)
        if ((isPreciousMetals && !isParity) || (isParity && !isPreciousMetals)) {
          // Tüm pariteleri çek
          List<SymbolModel> parities =
              searchResults.where((e) => e.typeCode == SymbolSearchFilterEnum.parity.dbKeys!.first).toList();

          // Paritelerin searchResults içindeki ilk index'ini bul
          int firstParityIndex =
              searchResults.indexWhere((e) => e.typeCode == SymbolSearchFilterEnum.parity.dbKeys!.first);

          // 🔹 Kıymetli maden pariteleri
          List<SymbolModel> preciousMetalsParities = parities.where((e) {
            return SymbolSearchUtils.isPreciousMetal(e);
          }).toList();

          // 🔹 Gösterilecek nihai parity listesi
          List<SymbolModel> finalParities = [];

          if (isPreciousMetals && !isParity) {
            // Sadece kıymetli maden paritelerini göster
            finalParities = preciousMetalsParities;
          } else if (isParity && !isPreciousMetals) {
            // Kıymetli madenleri HARİÇ tut
            finalParities = parities.where((e) => !preciousMetalsParities.any((pm) => pm.name == e.name)).toList();
          }

          // 🔥 Eski pariteleri kaldır
          searchResults.removeWhere((e) => e.typeCode == SymbolSearchFilterEnum.parity.dbKeys!.first);

          // 🔥 Yeni pariteleri aynı sırada geri ekle
          if (firstParityIndex != -1) {
            searchResults.insertAll(firstParityIndex, finalParities);
          } else {
            // Parity yoksa sona ekle
            searchResults.addAll(finalParities);
          }
        }
      }

      if (canSearchForeign) {
        int insertIndex = 0;
        for (int i = 0; i < searchResults.length; i++) {
          if (searchResults[i].typeCode == state.showForeignAfter) {
            insertIndex = i + 1;
          }
        }
        canSearchBist ? searchResults.insertAll(insertIndex, responses[1]) : searchResults.addAll(responses[0]);
      }

      // Tam eşleşen sembol en başa alınır
      if (event.symbolName.isNotEmpty) {
        final exactMatches = searchResults.where((e) => e.name.toUpperCase() == event.symbolName.toUpperCase());
        final others = searchResults.where((e) => e.name.toUpperCase() != event.symbolName.toUpperCase());
        searchResults = [...exactMatches, ...others];
      }

      event.callback(searchResults);
      emit(
        state.copyWith(
          type: PageState.success,
          searchResults: searchResults,
        ),
      );
    }
  }

  FutureOr<void> _onSearchFund(
    SearchFundEvent event,
    Emitter<SymbolSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    List<SymbolModel> searchResults = await _symbolSearchRepository.searchSymbol(
      symbolName: event.searchKey,
      exchangeCode: '',
      isFund: true,
      founderCode: event.foundercode,
      filterDbKeys: [],
    );
    event.callBack(searchResults);
    emit(
      state.copyWith(
        type: PageState.success,
        searchResults: searchResults,
      ),
    );
  }

  FutureOr<void> _onGetOldSearches(
    GetOldSearchesEvent event,
    Emitter<SymbolSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    List<String> filterDbKeys = [...event.filterDbKeys];
    bool isPreciousMetals = false;
    bool isParity = false;

    if (filterDbKeys.contains(SymbolSearchFilterEnum.preciousMetals.dbKeys!.first)) {
      isPreciousMetals = true;
      filterDbKeys.remove(SymbolSearchFilterEnum.preciousMetals.dbKeys!.first);
    }

    if (filterDbKeys.contains(SymbolSearchFilterEnum.parity.dbKeys!.first)) {
      isParity = true;
    }

    // Eğer sadece kıymetli maden tabı seçiliyse, parity ekle (DB query için)
    if (isPreciousMetals && !isParity) {
      filterDbKeys.add(SymbolSearchFilterEnum.parity.dbKeys!.first);
    }

    // 🔹 DB'den verileri al
    List<SymbolModel> searchResults = await _symbolSearchRepository.getOldSearches();

    // 🔹 İlk olarak, seçili filtrelere göre genel tür filtrelemesi
    searchResults = searchResults.where((element) => filterDbKeys.contains(element.typeCode)).toList();

    // 🔥 Şimdi parity / kıymetli maden özel filtrelemesi (sadece biri seçiliyse)
    if ((isPreciousMetals && !isParity) || (isParity && !isPreciousMetals)) {
      // Tüm parity kayıtlarını çek
      List<SymbolModel> parities =
          searchResults.where((e) => e.typeCode == SymbolSearchFilterEnum.parity.dbKeys!.first).toList();

      // Kıymetli maden pariteleri
      List<SymbolModel> preciousMetalsParities = parities.where((e) {
        return SymbolSearchUtils.isPreciousMetal(e);
      }).toList();

      if (isPreciousMetals && !isParity) {
        // 🔸 Sadece kıymetli maden paritelerini göster
        searchResults = preciousMetalsParities;
      } else if (isParity && !isPreciousMetals) {
        // 🔸 Kıymetli madenleri hariç tut
        searchResults = searchResults.where((e) {
          if (e.typeCode != SymbolSearchFilterEnum.parity.dbKeys!.first) {
            return true; // parity dışı kayıtlar hep kalsın
          }
          return !preciousMetalsParities.any((pm) => pm.name == e.name);
        }).toList();
      }
    }

    // 🔹 Callback ve state emit
    event.callback?.call(searchResults);
    emit(
      state.copyWith(
        type: PageState.success,
        oldSearches: searchResults,
      ),
    );
  }

  FutureOr<void> _onSetOldSearches(
    SetOldSearchesEvent event,
    Emitter<SymbolSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    List<SymbolModel> oldSearches = await _symbolSearchRepository.getOldSearches();
    bool isExists = state.oldSearches.any(
      (element) => event.symbolModel.name == element.name && event.symbolModel.typeCode == element.typeCode,
    );
    if (isExists) {
      oldSearches.removeWhere(
        (element) => event.symbolModel.name == element.name && event.symbolModel.typeCode == element.typeCode,
      );
    }
    oldSearches.insert(0, event.symbolModel);

    _symbolSearchRepository.setOldSearches(
      symbolModelList: oldSearches,
    );
    emit(
      state.copyWith(
        type: PageState.success,
        oldSearches: oldSearches,
      ),
    );
  }

  FutureOr<void> _onRemoveOldSearches(
    RemoveOldSearchesEvent event,
    Emitter<SymbolSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    List<SymbolModel> oldSearches = await _symbolSearchRepository.getOldSearches();

    oldSearches = oldSearches.where((symbol) {
      bool isDeleted = symbol.name == event.symbolModel.name && symbol.typeCode == event.symbolModel.typeCode;
      return !isDeleted;
    }).toList();

    _symbolSearchRepository.setOldSearches(
      symbolModelList: oldSearches,
    );

    emit(
      state.copyWith(
        type: PageState.success,
        oldSearches: oldSearches,
      ),
    );
  }

  FutureOr<void> _onRemoveExpiredOldSearches(
    RemoveExpiredOldSearchesEvent event,
    Emitter<SymbolSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    List<SymbolModel> oldSearches = await _symbolSearchRepository.getOldSearches();

    oldSearches = oldSearches.where((symbol) {
      bool isExpired = event.expiredSymbols.any(
        (expired) => symbol.name == expired.name && symbol.typeCode == expired.typeCode,
      );
      return !isExpired;
    }).toList();

    _symbolSearchRepository.setOldSearches(
      symbolModelList: oldSearches,
    );
    emit(
      state.copyWith(
        type: PageState.success,
        oldSearches: oldSearches,
      ),
    );
  }

  FutureOr<void> _onGetExchangeList(
    GetExchangeListEvent event,
    Emitter<SymbolSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    List<Map<String, dynamic>> exchangeList = await _symbolSearchRepository.getExchangeList();
    event.callback(exchangeList);

    emit(
      state.copyWith(
        type: PageState.success,
      ),
    );
  }

  FutureOr<void> _onGetUnderlyingList(
    GetUnderlyingListEvent event,
    Emitter<SymbolSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    List<String> underlyingList = [];

    List<String> rawUnderlyingList = await _symbolSearchRepository.getUnderlyingList(event.filter, event.maturity);
    underlyingList = [L10n.tr('all'), ...rawUnderlyingList];
    event.callback?.call(underlyingList);

    emit(
      state.copyWith(
        type: PageState.success,
        underlyingList: underlyingList,
      ),
    );
  }

  FutureOr<void> _onGetMaturityList(
    GetMaturityListEvent event,
    Emitter<SymbolSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    List<String> maturityList = [];

    List<String> rawMaturityList =
        await _symbolSearchRepository.getMaturityListByUnderlying(event.filter, event.underlying);
    maturityList = [
      L10n.tr('all_maturities'),
      ...rawMaturityList,
    ];
    event.callback?.call(maturityList);

    emit(
      state.copyWith(
        type: PageState.success,
        maturityList: maturityList,
      ),
    );
  }

  // Dinamik ORDER BY SQL oluştur
  FutureOr<void> _onGetSymbolSort(
    GetSymbolSortEvent event,
    Emitter<SymbolSearchState> emit,
  ) async {
    Map<String, dynamic> symbolSearchSort = jsonDecode(remoteConfig.getString('sybmolSearchSort'));
    Map<String, dynamic> symbolSortConfig = symbolSearchSort['SortBy'];
    String showForeignAfter = symbolSearchSort['ShowForeignAfter'];

    // TypeCode için sıralama
    List<String> typeOrderCases = [];
    int typeIndex = 1;
    symbolSortConfig.forEach((typeCode, _) {
      typeOrderCases.add("WHEN '$typeCode' THEN $typeIndex");
      typeIndex++;
    });

    String typeOrderSql = "CASE o.TypeCode ${typeOrderCases.join(" ")} ELSE 99 END";

    // ExchangeCode için sıralama (Sadece 2 veya daha fazla ExchangeCode olanlar için)
    List<String> exchangeOrderCases = [];
    symbolSortConfig.forEach((typeCode, exchangeCodes) {
      if (exchangeCodes.length > 1) {
        List<String> caseStatements = [];
        int exchangeIndex = 1;
        for (var exchangeCode in exchangeCodes) {
          caseStatements.add("WHEN '$exchangeCode' THEN $exchangeIndex");
          exchangeIndex++;
        }
        String caseBlock =
            "WHEN o.TypeCode = '$typeCode' THEN CASE o.ExchangeCode ${caseStatements.join(" ")} ELSE 99 END";
        exchangeOrderCases.add(caseBlock);
      }
    });

    String exchangeOrderSql = exchangeOrderCases.isNotEmpty ? ", CASE ${exchangeOrderCases.join(" ")} ELSE 99 END" : "";

    // **ORDER BY SQL'ini oluştur**
    String sqlQuery = """
    ORDER BY 
      $typeOrderSql
      $exchangeOrderSql
  """
        .trim();

    emit(
      state.copyWith(
        sortingQuery: sqlQuery,
        symbolSort: symbolSortConfig,
        showForeignAfter: showForeignAfter,
      ),
    );
  }

  FutureOr<void> _onGetPostitionList(
    GetPostitionListEvent event,
    Emitter<SymbolSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        type: state.positionList.isEmpty ? PageState.loading : PageState.success,
      ),
    );
    List<ApiResponse> responseList = await Future.wait(
      [
        //  hisse senedi pozisyon listesi cekilir
        _symbolSearchRepository.getPositionList(
          selectedAccount: event.accountId,
        ),
        // viop pozisyon listesi cekilir
        _symbolSearchRepository.getViopPositionList(),
        // us hisse senedi pozisyon listesi cekilir
        if (Utils().canTradeAmericanMarket() && UserModel.instance.alpacaAccountStatus) ...[
          _symbolSearchRepository.getUsPositionList(),
        ]
      ],
    );
    List<PositionModel> positionList = [];
    for (var i = 0; i < responseList.length; i++) {
      // herhangi bir response hata donerse islemi atlar
      if (!responseList[i].success) continue;
      // hisse senedi pozisyon listesi cekilir
      if (i == 0) {
        positionList.addAll(await _getEquityPositionList(responseList[i].data, event.accountId));
      }
      // viop pozisyon listesi cekilir
      if (i == 1) {
        positionList.addAll(await _getViopPositionList(responseList[i].data, event.accountId));
      }
      // us hisse senedi pozisyon listesi cekilir
      if (i == 2) {
        positionList.addAll(
          await _getUsPositionList(
            responseList[i].data,
            event.accountId,
          ),
        );
      }
    }
    event.callback?.call(positionList);
    emit(
      state.copyWith(
        type: PageState.success,
        positionList: positionList,
      ),
    );
  }

  Future<List<PositionModel>> _getEquityPositionList(Map<String, dynamic> response, String accountId) async {
    List<PositionModel> positionList = [];
    List<StockItemModel> stockItemList = response['customerStockList']
        .map<StockItemModel>(
          (e) => StockItemModel.fromJson(
            e,
          ),
        )
        .toList();

    if (stockItemList.isEmpty) return positionList;
    stockItemList.sort((a, b) => a.name.compareTo(b.name));

    Map<String, dynamic> symbolDetails = await _symbolSearchRepository.getSymbolsDetail(
        symbolNames: stockItemList.map((e) => {'Name': e.name, 'Suffix': e.groupCode}).toList());

    for (StockItemModel item in stockItemList) {
      Map<String, dynamic>? symbol = symbolDetails[item.name];
      positionList.add(
        PositionModel(
          symbolName: symbol?['Name'] ?? item.name,
          description: item.description,
          underlyingName: symbol?['UnderlyingName'] ?? '',
          symbolType: symbol?['TypeCode'] != null
              ? SymbolTypes.values.firstWhere((element) => element.dbKey == symbol!['TypeCode'])
              : (item.groupCode == 'V' ? SymbolTypes.warrant : SymbolTypes.equity),
          qty: item.balance,
          accountId: accountId,
        ),
      );
    }
    return positionList;
  }

  Future<List<PositionModel>> _getViopPositionList(Map<String, dynamic> response, String accountId) async {
    RegExp regExp = RegExp(r'\((.*?)\)'); // () içindeki metni yakalar
    List<PositionModel> positionList = [];
    List<Map<String, dynamic>> overallItemGroups = List.from(response['overallItemGroups']);
    for (Map element in overallItemGroups) {
      if (element['instrumentCategory'] == 'viop') {
        List<OverallSubItemModel> overallSubItemModelList = element['overallItems']
            .map<OverallSubItemModel>(
              (e) => OverallSubItemModel.fromJson(e),
            )
            .toList();
        Map<String, dynamic> symbolDetails = await _symbolSearchRepository.getSymbolsDetail(
            symbolNames:
                overallSubItemModelList.map((e) => {'Name': e.symbol.split(' ').first, 'Suffix': ''}).toList());

        for (OverallSubItemModel item in overallSubItemModelList) {
          String rawSymbolName = item.symbol.split(' ').first;
          //dev de Viop vadesi gecmis sembolleri db de bulamadigi icin verdigi hatayi atlar
          if (symbolDetails[rawSymbolName] == null) continue;
          Match? match = regExp.firstMatch(item.symbol);
          positionList.add(
            PositionModel(
                symbolName: symbolDetails[rawSymbolName]['Name'],
                description: symbolDetails[rawSymbolName]['Description'],
                underlyingName: symbolDetails[rawSymbolName]['UnderlyingName'],
                symbolType: SymbolTypes.values
                    .firstWhere((element) => element.dbKey == symbolDetails[rawSymbolName]['TypeCode']),
                qty: item.qty,
                accountId: accountId,
                viopSide: match?.group(1) ?? '' // İlk eşleşmeyi al
                ),
          );
        }
      }
    }
    return positionList;
  }

  Future<List<PositionModel>> _getUsPositionList(
    Map<String, dynamic> response,
    String accountId,
  ) async {
    List<PositionModel> positionList = [];
    Map<String, dynamic>? equityOverall = response['overallItemGroups'].firstWhere(
      (element) => element['instrumentCategory'] == 'equity',
      orElse: () => null,
    );

    if (equityOverall == null || equityOverall['overallItems'] == null) return [];
    List<UsOverallSubItem> usOverallList =
        equityOverall['overallItems'].map<UsOverallSubItem>((e) => UsOverallSubItem.fromJson(e)).toList();

    for (UsOverallSubItem element in usOverallList) {
      positionList.add(
        PositionModel(
          symbolName: element.symbol ?? '',
          description: element.exchange ?? '',
          underlyingName: '',
          symbolType: SymbolTypes.foreign,
          qty: (element.qty ?? 0),
          accountId: accountId,
        ),
      );
    }

    return positionList;
  }
}
