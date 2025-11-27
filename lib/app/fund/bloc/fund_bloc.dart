import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_state.dart';
import 'package:piapiri_v2/app/fund/model/fund_comparion_enum.dart';
import 'package:piapiri_v2/app/fund/model/fund_comparion_model.dart';
import 'package:piapiri_v2/app/fund/model/fund_financial_founder_list_model.dart';
import 'package:piapiri_v2/app/fund/model/fund_performance_model.dart';
import 'package:piapiri_v2/app/fund/model/fund_price_graph_model.dart';
import 'package:piapiri_v2/app/fund/model/fund_subtype_list_model.dart';
import 'package:piapiri_v2/app/fund/model/fund_themes_model.dart';
import 'package:piapiri_v2/app/fund/model/fund_volume_history_model.dart';
import 'package:piapiri_v2/app/fund/repository/fund_repository.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundBloc extends PBloc<FundState> {
  final FundRepository _fundRepository;
  FundBloc({required FundRepository fundRepository})
      : _fundRepository = fundRepository,
        super(initialState: const FundState()) {
    on<GetFundsEvent>(_onGetFunds);
    on<GetInstitutionsEvent>(_onGetInstitutions);
    on<ChangeSubTypeEvent>(_onChangeSubType);
    on<SetFilterEvent>(_onSetFilterEvent);
    on<GetDetailEvent>(_onGetDetailEvent);
    on<GetDetailsEvent>(_onGetDetailsEvent);
    on<GetFundInfoEvent>(_onGetFundInfo);
    on<NewOrderEvent>(_onNewOrder);
    on<GetByProfitEvent>(_onGetFundsByProfit);
    on<GetByManagementFeeEvent>(_onGetFundsByManagementFee);
    on<GetByPortfolioSizeEvent>(_onGetFundsByPortfolioSize);
    on<NewBulkOrderEvent>(_onNewBulkOrder);
    on<GetFinancialFounderListEvent>(_onGetFinancialFounderList);
    on<GetFilterAndSortEvent>(_onGetFilterAndSort);
    on<GetFundPerformanceRankingEvent>(_onGetFundPerformanceRanking);
    on<GetFundPriceGraphEvent>(_onGetFundPriceGraph);
    on<GetFundVolumeHistoryEvent>(_onGetFundVolumeHistory);
    on<GetFundApplicationCategoriesListEvent>(_onGetFundApplicationCategoriesList);
    on<FundDetailClearEvent>(_onClearFundDetailEvent);
    on<SetFunCurrencyType>(_onSetFundCurrencyType);
    on<GetFundPriceEvent>(_onGetFundPrice);
    on<GetAllFundThemesEvent>(_onGetAllFundThemes);
  }

  FutureOr<void> _onGetInstitutions(
    GetInstitutionsEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    List<dynamic> institutions = await _fundRepository.getInstitutions();
    List<dynamic> subTypes = await _fundRepository.getSubTypes(
      founder: state.fundFilter.institution,
      mainType: 'ALL',
      tefasStatus: 'ALL',
    );
    List<(String, String)> institutionList = institutions
        .map(
          (e) => (
            e['InstitutionDisplayName'].toString(),
            e['InstitutionCode'].toString(),
          ),
        )
        .toList();

    institutionList.sort((a, b) {
      return Intl.withLocale(
        Intl.defaultLocale,
        () => a.$1.toLowerCase().compareTo(
              b.$1.toLowerCase(),
            ),
      );
    });

    final index = institutionList.indexWhere((e) => e.$2 == 'UNP');
    if (index > 0) {
      final unpItem = institutionList[index];
      institutionList.removeAt(index);
      institutionList.insert(0, unpItem);
    }
    institutionList.insert(
      0,
      (
        L10n.tr('all'),
        '',
      ),
    );
    List<Map<String, String>> subTypeFilter = subTypes
        .map(
          (e) => {
            'Name': e['SubType'].toString(),
            'Code': e['SubTypeCode'].toString(),
          },
        )
        .toList();
    subTypeFilter.insert(0, {
      'Name': L10n.tr('all'),
      'Code': 'ALL',
    });
    List<dynamic> fundTitles = await _fundRepository.getFundTitleTypes(
      founder: state.fundFilter.institution,
      mainType: 'ALL',
      tefasStatus: 'ALL',
      subType: 'ALL',
    );
    List<Map<String, String>> fundTitleList = fundTitles
        .map(
          (e) => {
            'Name': e['FundTitleType'].toString(),
            'Code': e['FundTitleTypeCode'].toString(),
          },
        )
        .toList();
    fundTitleList.insert(0, {
      'Name': L10n.tr('all'),
      'Code': 'ALL',
    });

    emit(
      state.copyWith(
        type: PageState.success,
        institutionList: institutionList,
        subTypeFilter: subTypeFilter,
        fundTitleList: fundTitleList,
      ),
    );
    add(
      SetFilterEvent(
        fundFilter: state.fundFilter,
        callback: (symbolNames) {
          event.callback(symbolNames);
        },
      ),
    );
  }

  FutureOr<void> _onChangeSubType(
    ChangeSubTypeEvent event,
    Emitter<FundState> emit,
  ) async {
    List<dynamic> fundTitles = await _fundRepository.getFundTitleTypes(
      founder: event.institution,
      mainType: 'ALL',
      tefasStatus: 'ALL',
      subType: event.subType,
    );
    List<Map<String, String>> fundTitleList = fundTitles
        .map(
          (e) => {
            'Name': e['FundTitleType'].toString(),
            'Code': e['FundTitleTypeCode'].toString(),
          },
        )
        .toList();
    fundTitleList.insert(0, {
      'Name': L10n.tr('all'),
      'Code': 'ALL',
    });
    emit(
      state.copyWith(
        fundTitleList: fundTitleList,
      ),
    );
  }

  FutureOr<void> _onSetFilterEvent(
    SetFilterEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(
      state.copyWith(
        fundFilter: event.fundFilter,
        type: PageState.initial,
        selectedFundComparionType: FundComparionEnum.initial,
      ),
    );

    add(
      GetFundsEvent(
        completedCallback: event.getFundsCompletedCallback,
      ),
    );
  }

  FutureOr<void> _onGetFunds(
    GetFundsEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _fundRepository.getFinancialInstutionList(
      founderCode: state.fundFilter.institution,
      subTypeCode: state.fundFilter.subType == 'ALL' ? null : state.fundFilter.subType,
      fundTitleTypeCode: state.fundFilter.fundTitle == 'ALL' ? null : int.parse(state.fundFilter.fundTitle),
      tefasStatus: state.fundFilter.tefasType == 'ALL' ? null : int.parse(state.fundFilter.tefasType),
      mainTypeCode: state.fundFilter.fundType == 'ALL' ? null : state.fundFilter.fundType,
      applicationCategoryId:
          state.fundFilter.applicationCategory == 'ALL' ? null : int.parse(state.fundFilter.applicationCategory),
      themeId: state.fundFilter.themeId,
    );
    if (response.success) {
      List<FundModel> funds = response.data['funds'].map<FundModel>((e) => FundModel.fromJson(e)).toList();
      emit(
        state.copyWith(
          type: PageState.success,
          fundList: funds,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02FUND01',
          ),
        ),
      );
    }
    event.completedCallback?.call();
  }

  FutureOr<void> _onGetDetailEvent(
    GetDetailEvent event,
    Emitter<FundState> emit,
  ) async {
    bool isOnlyInfo = event.callBack != null;
    if (!isOnlyInfo) {
      emit(
        state.copyWith(
          fundDetailPageState: PageState.loading,
        ),
      );
    }

    ApiResponse response = await _fundRepository.getFundDetails(
      fundCode: event.fundCode,
    );

    if (response.success) {
      if (isOnlyInfo) {
        event.callBack!(FundDetailModel.fromJson(response.data['fundDetails']));
      } else {
        emit(
          state.copyWith(
            fundDetailPageState: PageState.success,
            fundDetail: FundDetailModel.fromJson(response.data['fundDetails']),
          ),
        );
      }
    } else if (!isOnlyInfo) {
      emit(
        state.copyWith(
          fundDetailPageState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02FUND02',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetDetailsEvent(GetDetailsEvent event, Emitter<FundState> emit) async {
    List<ApiResponse> responses = await Future.wait(
      event.fundCodeList.map(
        (e) => _fundRepository.getFundDetails(
          fundCode: e,
        ),
      ),
    );

    List<FundDetailModel> fundDetailModels = [];

    for (ApiResponse response in responses) {
      if (response.success) {
        fundDetailModels.add(FundDetailModel.fromJson(response.data['fundDetails']));
      }
    }
    event.callBack(fundDetailModels);
  }

  FutureOr<void> _onGetFundInfo(
    GetFundInfoEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _fundRepository.getFundInfo(
      fundCode: event.fundCode,
      accountId: event.accountId,
      buySell: event.type,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          tradeLimit: response.data['tradeLimit'],
          valorDate: response.data['valorDate'],
        ),
      );
      if (event.callback != null) {
        event.callback!(response.data['valorDate']);
      }
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02FUND03',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onNewOrder(
    NewOrderEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _fundRepository.newOrder(
      fundCode: event.fundCode,
      accountId: event.accountId,
      orderActionType: event.orderActionType,
      price: event.price,
      unit: event.unit,
      amount: event.amount,
      valorDate: event.valorDate,
      baseType: 'Unit',
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.successCallback();
    } else {
      if (response.error?.message == 'CustomerMustBeQualifiedInvestor') {
        getIt<ContractsBloc>().add(
          GetContractPdfEvent(
            contractCode: 'NYBF',
          ),
        );
        event.errorCallback();
      }
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: response.error?.message != 'CustomerMustBeQualifiedInvestor',
            message: response.error?.message ?? '',
            errorCode: '02FUND04',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetFundsByProfit(
    GetByProfitEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
        selectedFundComparionType: FundComparionEnum.profit,
      ),
    );

    ApiResponse response = await _fundRepository.getFundsByProfit(
      startDate: event.startDate,
      endDate: event.endDate,
    );

    if (response.success) {
      List<FundComparionModel> funds = response.data['fundProfits']
          .where((e) => event.institutionCode == null || e['institutionCode'] == event.institutionCode)
          .map<FundComparionModel>((e) => FundComparionModel.fromProfit(e))
          .toList();

      emit(
        state.copyWith(
          type: PageState.success,
          fundProfitsList: funds,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02FUND05',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetFundsByManagementFee(
    GetByManagementFeeEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
        selectedFundComparionType: FundComparionEnum.managementFee,
      ),
    );

    ApiResponse response = await _fundRepository.getFundsByManagementFee();

    if (response.success) {
      List<FundComparionModel> funds = response.data['fundManagementFees']
          .map<FundComparionModel>((e) => FundComparionModel.fromManagement(e))
          .toList();

      emit(
        state.copyWith(
          type: PageState.success,
          fundManagementFeesList: funds,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02FUND06',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetFundsByPortfolioSize(
    GetByPortfolioSizeEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
        selectedFundComparionType: FundComparionEnum.portfolioSize,
      ),
    );

    ApiResponse response = await _fundRepository.getFundsByPortfolioSize();

    if (response.success) {
      List<FundComparionModel> funds = response.data['fundPortfolioSizes']
          .map<FundComparionModel>((e) => FundComparionModel.fromPortfolio(e))
          .toList();

      emit(
        state.copyWith(
          type: PageState.success,
          fundPortfolioSizesList: funds,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02FUND07',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onNewBulkOrder(
    NewBulkOrderEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    List<Map<String, dynamic>> fundList = event.list
        .map(
          (e) => {
            'finInstName': e['symbolCode'],
            'price': e['symbolPrice'],
            'unit': e['count'],
            'amount': e['symbolAmount'],
            'baseType': 'Amount',
            'side': 'B',
            'transactionType': 'T',
            'valueDate': e['fundValorDate'],
          },
        )
        .toList();

    ApiResponse response = await _fundRepository.newBulkOrder(
      funds: fundList,
      account: event.account,
    );

    if (response.success) {
      int failedCount =
          (response.data['resultBulkOrderList'] as List).where((e) => e['errorMessage'].toString().isNotEmpty).length;

      event.callback(
        fundList.length - failedCount,
        failedCount,
      );

      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02FUND08',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetFinancialFounderList(
    GetFinancialFounderListEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _fundRepository.getFinancialFounderList(
      event.institutionCode,
    );

    if (response.success) {
      List<String> remoteFounderList =
          (jsonDecode(remoteConfig.getValue('fundFounderList').asString())['founders'] as List)
              .map((e) => e.toString())
              .toList();

      List<dynamic> institutions = await _fundRepository.getInstitutions();

      List<(String, String)> institutionList = institutions
          .map(
            (e) => (
              e['InstitutionDisplayName'].toString(),
              e['InstitutionCode'].toString(),
            ),
          )
          .toList();
      List<GetFinancialFounderListModel> financialFounderList =
          response.data.map<GetFinancialFounderListModel>((e) => GetFinancialFounderListModel.fromJson(e)).toList();
      financialFounderList.sort((a, b) {
        int indexA = remoteFounderList.indexOf(a.code ?? '');
        int indexB = remoteFounderList.indexOf(b.code ?? '');

        // Eğer founderCode remote listede yoksa -1 gelir → listenin en sonuna atılır
        if (indexA == -1 && indexB == -1) return 0;
        if (indexA == -1) return 1;
        if (indexB == -1) return -1;

        return indexA.compareTo(indexB);
      });
      financialFounderList = financialFounderList.map((founder) {
        for (final institution in institutionList) {
          if (founder.code == institution.$2) {
            return founder.copyWith(name: institution.$1);
          }
        }
        return founder;
      }).toList();

      emit(
        state.copyWith(
          type: PageState.success,
          founderInfoList: financialFounderList,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02FUND09',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetFilterAndSort(
    GetFilterAndSortEvent event,
    Emitter<FundState> emit,
  ) async {
    if (event.startIndex == 0) {
      emit(
        state.copyWith(
          type: PageState.loading,
        ),
      );
    }

    ApiResponse response = await _fundRepository.getFilterAndSortFunds(
      institutionCode: event.institutionCode,
      startIndex: event.startIndex ?? 0,
      count: event.count ?? 50,
    );

    if (response.success) {
      List<FundModel> newFunds =
          response.data['filterAndSortFund'].map<FundModel>((e) => FundModel.fromJson(e)).toList();

      List<FundModel> updatedList = event.startIndex == 0 ? newFunds : [...(state.filterSortList ?? []), ...newFunds];

      emit(
        state.copyWith(
          type: PageState.success,
          filterSortList: updatedList,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02FUND10',
          ),
        ),
      );
    }
    event.completedCallBack?.call();
  }

  FutureOr<void> _onGetFundPerformanceRanking(
    GetFundPerformanceRankingEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _fundRepository.getFundPerformanceRanking();

    if (response.success) {
      FundPerformanceModel performanceRanking = FundPerformanceModel.fromJson(response.data);
      emit(
        state.copyWith(
          type: PageState.success,
          performanceRanking: performanceRanking,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02FUND10',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetFundPriceGraph(
    GetFundPriceGraphEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ChartFilter chartFilter = event.chartFilter ?? state.chartFilter;

    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    String startDate = date.subtract(chartFilter.duration).toIso8601String();
    String endDate = date.toIso8601String();
    ApiResponse response = await _fundRepository.getFundPriceGraph(
      fundCode: event.fundCode,
      startDate: startDate,
      endDate: endDate,
      period: chartFilter.fundPeriod!,
    );

    if (response.success) {
      List<FundPriceGraphModel> fundGraphPriceList =
          response.data['fundPriceGraphList'].map<FundPriceGraphModel>((e) => FundPriceGraphModel.fromJson(e)).toList();

      if (state.currencyType == CurrencyEnum.dollar) {
        ApiResponse response = await _fundRepository.getCurrencyRatios(
          currency: state.currencyType.shortName.toUpperCase(),
        );

        if (!response.success) {
          add(SetFunCurrencyType());
          return;
        }

        double curencyRate = double.parse(response.data['result']?[0]?['debitPrice']?.toString() ?? '0');

        if (!(curencyRate > 0)) {
          add(SetFunCurrencyType());
          return;
        }

        for (FundPriceGraphModel element in fundGraphPriceList) {
          element.price = element.price / curencyRate;
        }
      }

      emit(
        state.copyWith(
          type: PageState.success,
          chartFilter: chartFilter,
          fundGraphPriceList: fundGraphPriceList,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          chartFilter: chartFilter,
          fundGraphPriceList: [],
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02FUND011',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetFundVolumeHistory(
    GetFundVolumeHistoryEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _fundRepository.getFundVolumeHistory(
      fundCode: event.fundCode,
    );

    if (response.success) {
      List<FundVolumeHistoryModel> fundVolumeHistoryDataList = response.data['fundVolumeHistoryList']
          .map<FundVolumeHistoryModel>((e) => FundVolumeHistoryModel.fromJson(e))
          .toList();

      emit(
        state.copyWith(
          type: PageState.success,
          fundVolumeHistoryDataList: fundVolumeHistoryDataList,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02FUND012',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetFundApplicationCategoriesList(
    GetFundApplicationCategoriesListEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _fundRepository.getFundApplicationCategories();
    if (response.success) {
      List<FundApplicationCategoryListModel> applicationCategories = response.data['applicationCategoriesList']
          .map<FundApplicationCategoryListModel>((e) => FundApplicationCategoryListModel.fromJson(e))
          .where((model) => model.count != 0)
          .toList();

      applicationCategories.sort(
        (a, b) => Utils().sortIncludeTurkishCharacter(
          a.name,
          b.name,
        ),
      );

      emit(
        state.copyWith(
          type: PageState.success,
          applicationCategories: applicationCategories,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02FUND013',
          ),
        ),
      );
    }
  }

  void _onClearFundDetailEvent(
    FundDetailClearEvent event,
    Emitter<FundState> emit,
  ) {
    emit(
      state.copyWith(
        fundDetailPageState: PageState.initial,
        fundDetail: null,
      ),
    );
  }

  FutureOr<void> _onSetFundCurrencyType(
    SetFunCurrencyType event,
    Emitter<FundState> emit,
  ) {
    emit(
      state.copyWith(
        currencyType: state.currencyType == CurrencyEnum.turkishLira ? CurrencyEnum.dollar : CurrencyEnum.turkishLira,
      ),
    );
  }

  FutureOr<void> _onGetFundPrice(
    GetFundPriceEvent event,
    Emitter<FundState> emit,
  ) async {
    ApiResponse response = await _fundRepository.getFundPrice(fundCode: event.fundCode);
    if (response.success) {
      event.callback?.call(response.data['fundPrices'][0]['value'].toDouble());
    }
  }

  FutureOr<void> _onGetAllFundThemes(
    GetAllFundThemesEvent event,
    Emitter<FundState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _fundRepository.getAllFundThemes();

    if (response.success) {
      List<FundThemesModel> fundThemeList =
          response.data['fundThemes'].map<FundThemesModel>((e) => FundThemesModel.fromJson(e)).toList();

      // orderNo'ya göre sıralama: null veya 0 olanlar sona atılır
      fundThemeList.sort((a, b) {
        int aOrder = (a.orderNo == null || a.orderNo == 0) ? 9999 : a.orderNo!;
        int bOrder = (b.orderNo == null || b.orderNo == 0) ? 9999 : b.orderNo!;
        return aOrder.compareTo(bOrder);
      });

      emit(
        state.copyWith(
          type: PageState.success,
          fundThemeList: fundThemeList,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02FUND014',
          ),
        ),
      );
    }
  }
}
