import 'package:piapiri_v2/app/ipo/model/ipo_active_info_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_blockage_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_customer_info_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_detail_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_trade_limit_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class IpoState extends PState {
  final List<IpoModel> ipoList;
  final List<IpoModel> currentIpoList;
  final List<IpoModel> futureIpoList;
  final List<IpoModel> pastIpoList;
  final List<IpoDemandModel>? ipoDemandList;
  final IpoTradeLimitModel? ipoTradeLimitModel;
  final IpoActiveInfoModel? ipoActiveInfoModel;
  final IpoCustomerInfoModel? ipoCustomerInfoModel;
  final IpoBlockageModel? ipoBlockageModel;
  final IpoDetailModel? ipoDetailModel;
  final int pageNumber;
  final List<IpoModel> ipoDetailsBySymbolListForSearch;
  final Map<String, List<IpoModel>> ipoDateGroup;
  final bool hasMorePastIpo;
  final int pastIpoPageNumber;
  final double? cashBalance;
  final String? symbolName;

  const IpoState({
    super.type = PageState.initial,
    super.error,
    this.ipoList = const [],
    this.ipoDemandList = const [],
    this.ipoTradeLimitModel,
    this.ipoActiveInfoModel,
    this.ipoCustomerInfoModel,
    this.ipoBlockageModel,
    this.currentIpoList = const [],
    this.futureIpoList = const [],
    this.pastIpoList = const [],
    this.ipoDetailModel,
    this.pageNumber = 0,
    this.ipoDetailsBySymbolListForSearch = const [],
    this.ipoDateGroup = const {},
    this.hasMorePastIpo = true,
    this.pastIpoPageNumber = 0,
    this.cashBalance,
    this.symbolName,
  });

  @override
  IpoState copyWith({
    PageState? type,
    PBlocError? error,
    List<IpoModel>? ipoList,
    List<IpoModel>? currentIpoList,
    List<IpoModel>? futureIpoList,
    List<IpoModel>? pastIpoList,
    List<IpoDemandModel>? ipoDemandList,
    IpoTradeLimitModel? ipoTradeLimitModel,
    IpoActiveInfoModel? ipoActiveInfoModel,
    IpoCustomerInfoModel? ipoCustomerInfoModel,
    IpoBlockageModel? ipoBlockageModel,
    IpoDetailModel? ipoDetailModel,
    int? pageNumber,
    List<IpoModel>? ipoDetailsBySymbolListForSearch,
    Map<String, List<IpoModel>>? ipoDateGroup,
    bool? hasMorePastIpo,
    int? pastIpoPageNumber,
    double? cashBalance,
    String? symbolName,
  }) {
    return IpoState(
      type: type ?? this.type,
      error: error ?? this.error,
      ipoList: ipoList ?? this.ipoList,
      ipoDemandList: ipoDemandList ?? this.ipoDemandList,
      ipoTradeLimitModel: ipoTradeLimitModel ?? this.ipoTradeLimitModel,
      ipoActiveInfoModel: ipoActiveInfoModel ?? this.ipoActiveInfoModel,
      ipoCustomerInfoModel: ipoCustomerInfoModel ?? this.ipoCustomerInfoModel,
      ipoBlockageModel: ipoBlockageModel ?? this.ipoBlockageModel,
      currentIpoList: currentIpoList ?? this.currentIpoList,
      futureIpoList: futureIpoList ?? this.futureIpoList,
      pastIpoList: pastIpoList ?? this.pastIpoList,
      ipoDetailModel: ipoDetailModel ?? this.ipoDetailModel,
      pageNumber: pageNumber ?? this.pageNumber,
      ipoDetailsBySymbolListForSearch: ipoDetailsBySymbolListForSearch ?? this.ipoDetailsBySymbolListForSearch,
      ipoDateGroup: ipoDateGroup ?? this.ipoDateGroup,
      hasMorePastIpo: hasMorePastIpo ?? this.hasMorePastIpo,
      pastIpoPageNumber: pastIpoPageNumber ?? this.pastIpoPageNumber,
      cashBalance: cashBalance ?? this.cashBalance,
      symbolName: symbolName,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        ipoList,
        ipoDemandList,
        ipoTradeLimitModel,
        ipoActiveInfoModel,
        ipoCustomerInfoModel,
        ipoBlockageModel,
        currentIpoList,
        futureIpoList,
        pastIpoList,
        ipoDetailModel,
        pageNumber,
        ipoDetailsBySymbolListForSearch,
        ipoDateGroup,
        hasMorePastIpo,
        pastIpoPageNumber,
        cashBalance,
        symbolName,
      ];
}
