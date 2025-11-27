import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_event.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_state.dart';
import 'package:piapiri_v2/app/assets/model/capra_collateral_info_model.dart';
import 'package:piapiri_v2/app/assets/model/collateral_info_model.dart';
import 'package:piapiri_v2/app/assets/model/us_capra_summary_model.dart';
import 'package:piapiri_v2/app/assets/repository/assets_repository.dart';
import 'package:piapiri_v2/app/assets/widgets/calculate_value.dart';
import 'package:piapiri_v2/app/orders/repository/orders_repository.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class AssetsBloc extends PBloc<AssetsState> {
  final AssetsRepository _assetsRepository;
  final OrdersRepository _ordersRepository;

  AssetsBloc({
    required AssetsRepository assetsRepository,
    required OrdersRepository ordersRepository,
  })  : _assetsRepository = assetsRepository,
        _ordersRepository = ordersRepository,
        super(initialState: const AssetsState()) {
    on<GetOverallSummaryEvent>(_onGetOverallSummary);
    on<GetAllCashFlowEvent>(_onGetAllCashFlow);
    on<GetAssetsCollateralInfoEvent>(_onGetCollateralInfo);
    on<GetLimitInfosEvent>(_onGetLimitInfos);
    on<TotalCashFlowEvent>(_onGetTotalCashFlow);
    on<GetCapraPortfolioSummaryEvent>(_onGetCapraPortfolioSummary);
    on<GetCapraCollateralInfoEvent>(_onGetCapraCollateralInfo);
    on<HasRefreshEvent>(_onHasRefresh);
    on<ResetAssetsStateEvent>(_onResetAssetsState);
  }

  FutureOr<void> _onGetOverallSummary(
    GetOverallSummaryEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        consolidateAssetState: PageState.loading,
      ),
    );

    final ApiResponse response = await _assetsRepository.getAccountOverallWithsummary(
      accountId: event.accountId.isNotEmpty ? event.accountId : '',
      isConsolidated: event.isConsolidated,
      allAccount: event.allAccounts,
      getInstant: event.getInstant,
      overallDate: event.overallDate,
      includeCashFlow: event.includeCashFlow,
      includeCreditDetail: event.includeCreditDetail,
      calculateTradeLimit: event.calculateTradeLimit,
    );

    if (response.success) {
      double? saleableUnit;
      double? saleableAmount;
      OverallItemModel? portfolioViop = OverallItemModel(
        instrumentCategory: 'viop',
        totalAmount: 0,
        ratio: 0,
        overallSubItems: [],
        totalPotentialProfitLoss: 0,
      );

      List<Map<String, dynamic>> overallItemGroups = List.from(response.data['overallItemGroups']);
      for (Map<String, dynamic> itemGroup in overallItemGroups) {
        if (itemGroup['instrumentCategory'] == 'fund') {
          List<dynamic> overalItems = itemGroup['overallItems'];

          for (var element in overalItems) {
            element['underlying'] = await _assetsRepository.getFundFounderCode(
              code: element['financialInstrumentCode'],
            );
          }

          List<dynamic> isExist = overalItems
              .where(
                (element) => overalItems.any((e) => element['financialInstrumentCode'] == event.fundSymbol),
              )
              .toList();

          if (isExist.isNotEmpty) {
            saleableUnit = isExist[0]['qty'];
            saleableAmount = double.parse(isExist[0]['amount'].toString());
          } else {
            saleableUnit = null;
            saleableAmount = null;
          }
        } else if (itemGroup['instrumentCategory'] != 'equity' &&
            itemGroup['instrumentCategory'] != 'currency' &&
            itemGroup['instrumentCategory'] != 'cash' &&
            itemGroup['instrumentCategory'] != 'viop_collateral') {
          for (Map<String, dynamic> item in itemGroup['overallItems']) {
            String symbolName = item['symbol'].split(' ')[0] as String;
            String updatedSymbolName = symbolName;
            if (itemGroup['instrumentCategory'] == 'warrant') {
              final symbolGroupCode = item['groupCode'] as String? ?? '';
              final symbolSuffixList = getIt<AppInfoBloc>().state.symbolSuffixList;
              if (symbolName.isNotEmpty) {
                final inSuffixList =
                    symbolSuffixList.isNotEmpty && symbolSuffixList.any((e) => e.name == symbolName);
                if (inSuffixList) {
                  updatedSymbolName = getIt<AppInfoBloc>()
                      .state
                      .symbolSuffixList
                      .firstWhere((e) => e.name == symbolName)
                      .nameWithSuffix;
                  item['symbol'] = updatedSymbolName;
                } else {
                  SymbolTypes? symbolType = Utils.getSybolTypeFromGroupCode(symbolGroupCode);
                  String? suffix = symbolType == null
                      ? null
                      : await _ordersRepository.getSuffixByBistCodeForTypeCode(
                          name: symbolName,
                          typeCode: symbolType.dbKey,
                        );
                  updatedSymbolName = Utils.symbolNameAddSuffix(
                    symbolName,
                    symbolType,
                    suffix: suffix,
                  );
                  item['symbol'] = updatedSymbolName;
                }
              }
            }

            num multiplier = 1;
            await _assetsRepository.getSymbolDetail(symbolCode: updatedSymbolName).then((value) {
              if (value != null) {
                item['underlying'] = value['UnderlyingName'] ?? '';
                item['multiplier'] = value['Multiplier'] ?? 1;
                if (item['multiplier'] != null) {
                  multiplier = item['multiplier'];
                }
                item['maturity'] = value['MaturityDate'] ?? '';
              } else {
                item['maturity'] = DateTimeUtils.serverDate(
                  DateTime.now().subtract(
                    const Duration(
                      days: 1,
                    ),
                  ),
                );
              }
            });

            if (itemGroup['instrumentCategory'] == 'viop' &&
                itemGroup['overallItems'] != null &&
                itemGroup['overallItems'].isNotEmpty) {
              double total = 0;

              for (var element in itemGroup['overallItems']) {
                total = total + element['price'] * element['qty'] * (element['multiplier'] ?? multiplier);
              }
              itemGroup['totalAmount'] = total;
              portfolioViop = OverallItemModel.fromJson(itemGroup);
            }
          }
        }
      }
      response.data['overallItemGroups'] = overallItemGroups;

      final equityGroup = overallItemGroups.firstWhere(
        (e) => e['instrumentCategory'] == 'equity',
        orElse: () => {},
      );
      final equities = (equityGroup['overallItems'] as List?) ?? [];

      if (equities.isNotEmpty) {
        for (var equity in equities) {
          final symbolName = equity['symbol'] as String? ?? '';
          final symbolGroupCode = equity['groupCode'] as String? ?? '';
          final symbolSuffixList = getIt<AppInfoBloc>().state.symbolSuffixList;
          if (symbolName.isNotEmpty) {
            final inSuffixList = symbolSuffixList.isNotEmpty && symbolSuffixList.any((e) => e.name == symbolName);
            if (inSuffixList) {
              final updatedSymbolName =
                  getIt<AppInfoBloc>().state.symbolSuffixList.firstWhere((e) => e.name == symbolName).nameWithSuffix;
              equity['symbol'] = updatedSymbolName;
            } else {
              SymbolTypes? symbolType = Utils.getSybolTypeFromGroupCode(symbolGroupCode);
              String? suffix = symbolType == null
                  ? null
                  : await _ordersRepository.getSuffixByBistCodeForTypeCode(
                      name: symbolName,
                      typeCode: symbolType.dbKey,
                    );
              String updatedSymbolName = Utils.symbolNameAddSuffix(
                symbolName,
                symbolType,
                suffix: suffix,
              );
              equity['symbol'] = updatedSymbolName;
            }
          }
        }
      }

      AssetModel myAssets = AssetModel.fromJson(response.data);
      event.callback?.call(myAssets);
      DateTime today = DateTime.now();
      double? totalAsset = state.totalAsset;
      //toplam varlık değeri değişmemesi için ayrı bir statete tutyoruz
      if (event.isShowTotalAsset) {
        totalAsset = calculateTotalAmount(myAssets.overallItemGroups);
      }
      // Dateime çevirip sıralıyoruz
      List<Map<String, dynamic>> sortedList = response.data['cashFlowList']
          .map<Map<String, dynamic>>((item) => {
                'valueDate': DateTime.parse(item['valueDate']).toLocal(), // Saat dilimini düzenliyoruz
                'original': item
              })
          .toList()
        ..sort((a, b) => (a['valueDate'] as DateTime).compareTo(b['valueDate'] as DateTime));

      // Bugünü ve en yakın sonraki iki tarihi seçiyoruz
      List<dynamic> filteredList = sortedList
          .where((item) => (item['valueDate'] as DateTime).isAfter(today.subtract(const Duration(days: 1))))
          .take(3)
          .map((item) => item['original'])
          .toList();

      if (event.isFromAgreement) {
        emit(
          state.copyWith(
            consolidateAssetState: PageState.success,
            agreementConsolidatedAssets: myAssets,
            agreementViop: portfolioViop,
            ipoStatus: myAssets.ipoStatus,
          ),
        );
      } else {
        emit(
          state.copyWith(
            consolidateAssetState: PageState.success,
            allCashFlowList: filteredList,
            consolidatedAssets: myAssets,
            saleableUnit: saleableUnit ?? 0,
            saleableAmount: saleableAmount ?? 0,
            totalAsset: totalAsset,
            portfolioViop: portfolioViop,
            ipoStatus: myAssets.ipoStatus,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          consolidateAssetState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetAllCashFlow(
    GetAllCashFlowEvent event,
    Emitter emit,
  ) async {
    if (!event.isFromWidget || state.allCashFlowList == null || state.allCashFlowList!.isEmpty) {
      emit(
        state.copyWith(
          type: PageState.loading,
          allCashFlowList: [],
        ),
      );

      final ApiResponse response = await _assetsRepository.getCashFlow(
        accountId: event.accountExtId,
        allAccounts: event.allAccounts,
      );

      if (response.success) {
        emit(
          state.copyWith(
            type: PageState.success,
            allCashFlowList: response.data['cashFlowList'] ?? [],
          ),
        );
      } else {
        emit(
          state.copyWith(
            type: PageState.failed,
            error: PBlocError(
              showErrorWidget: true,
              message: response.error?.message ?? '',
              errorCode: '04PORT05',
            ),
          ),
        );
      }
    }
  }

  // Varlık -> Teminat Bilgileri
  FutureOr<void> _onGetCollateralInfo(
    GetAssetsCollateralInfoEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _assetsRepository.getCollateralInfo(
      accountId: event.accountId,
    );

    if (response.success) {
      CollateralInfo collateralInfoModel = CollateralInfo.fromJson(
        response.data['collateralInfo'],
      );

      emit(
        state.copyWith(
          type: PageState.success,
          collateralInfo: collateralInfoModel,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT08',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetLimitInfos(
    GetLimitInfosEvent event,
    Emitter<AssetsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _assetsRepository.getTradeLimit(
      accountId: event.accountExtId,
      typeName: event.typeName,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          limitInfos: response.data,
        ),
      );
      event.calback?.call(response.data);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT11',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetTotalCashFlow(
    TotalCashFlowEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _assetsRepository.getCashFlow(
      accountId: '',
      allAccounts: true,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          totalCashFlowList: response.data['cashFlowList'] ?? [],
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT16',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetCapraPortfolioSummary(
    GetCapraPortfolioSummaryEvent event,
    Emitter<AssetsState> emit,
  ) async {
    emit(
      state.copyWith(
        usPortfolioState: PageState.loading,
      ),
    );

    final ApiResponse response = await _assetsRepository.getCapraPortfolioSummary();

    if (response.success) {
      UsCapraSummaryModel portfolioSummaryModel = UsCapraSummaryModel.fromJson(response.data);

      emit(
        state.copyWith(
          usPortfolioState: PageState.success,
          portfolioSummaryModel: portfolioSummaryModel,
        ),
      );

      event.onFecthed?.call();
    } else {
      emit(
        state.copyWith(
          usPortfolioState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04AST01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetCapraCollateralInfo(
    GetCapraCollateralInfoEvent event,
    Emitter<AssetsState> emit,
  ) async {
    emit(
      state.copyWith(
        capraCollateralAsset: PageState.loading,
      ),
    );

    final ApiResponse response = await _assetsRepository.getCapraCollateralInfo();

    if (response.success) {
      CapraCollateralInfoModel capraCollateralInfo = CapraCollateralInfoModel.fromJson(response.data);

      emit(
        state.copyWith(
          capraCollateralAsset: PageState.success,
          capraCollateralInfo: capraCollateralInfo,
        ),
      );
      if (event.callback != null) {
        event.callback!(
          capraCollateralInfo.buyingPower ?? 0,
        );
      }
    } else {
      emit(
        state.copyWith(
          capraCollateralAsset: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04AST02',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onHasRefresh(
    HasRefreshEvent event,
    Emitter<AssetsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.success,
        hasRefresh: event.hasRefresh ?? false,
      ),
    );
  }

  FutureOr<void> _onResetAssetsState(
    ResetAssetsStateEvent event,
    Emitter<AssetsState> emit,
  ) async {
    emit(
      const AssetsState(),
    );
  }
}
