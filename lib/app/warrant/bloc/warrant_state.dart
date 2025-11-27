import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/risk_level_enum.dart';
import 'package:piapiri_v2/core/model/warrant_dropdown_model.dart';

class WarrantState extends PState {
  final String selectedMarketMaker;
  final String selectedUnderlyingAsset;
  final List<WarrantDropdownModel> marketMakerList;
  final List<WarrantDropdownModel> underlyingAssetList;
  final List<WarrantDropdownModel> uncertainUnderlyingAssetList;
  final List<MarketListModel> symbolList;
  final PageState filterType;
  final Set<String> maturityDateSet;
  final String? selectedMaturity;
  final String? selectedType;
  final RiskLevelEnum? selectedRisk;
  final Map<String, dynamic> warrantUsUnderlying;
  final bool hasWarrant;

  const WarrantState({
    super.type = PageState.initial,
    super.error,
    this.selectedMarketMaker = 'UNS',
    this.selectedUnderlyingAsset = 'XU030',
    this.marketMakerList = const [],
    this.underlyingAssetList = const [],
    this.uncertainUnderlyingAssetList = const [],
    this.symbolList = const [],
    this.filterType = PageState.initial,
    this.maturityDateSet = const {},
    this.selectedMaturity,
    this.selectedType,
    this.selectedRisk,
    this.warrantUsUnderlying = const {},
    this.hasWarrant = false,
  });

  @override
  WarrantState copyWith({
    PageState? type,
    PBlocError? error,
    String? selectedMarketMaker,
    String? selectedUnderlyingAsset,
    List<MarketListModel>? symbolList,
    List<WarrantDropdownModel>? marketMakerList,
    List<WarrantDropdownModel>? underlyingAssetList,
    List<WarrantDropdownModel>? uncertainUnderlyingAssetList,
    PageState? filterType,
    Set<String>? maturityDateSet,
    String? selectedMaturity,
    String? selectedType,
    RiskLevelEnum? selectedRisk,
    Map<String, dynamic>? warrantUsUnderlying,
    bool? hasWarrant,
  }) {
    return WarrantState(
      type: type ?? this.type,
      error: error ?? this.error,
      selectedMarketMaker: selectedMarketMaker ?? this.selectedMarketMaker,
      selectedUnderlyingAsset: selectedUnderlyingAsset ?? this.selectedUnderlyingAsset,
      symbolList: symbolList ?? this.symbolList,
      marketMakerList: marketMakerList ?? this.marketMakerList,
      underlyingAssetList: underlyingAssetList ?? this.underlyingAssetList,
      uncertainUnderlyingAssetList: uncertainUnderlyingAssetList ?? this.uncertainUnderlyingAssetList,
      filterType: filterType ?? this.filterType,
      maturityDateSet: maturityDateSet ?? this.maturityDateSet,
      selectedMaturity: selectedMaturity ?? this.selectedMaturity,
      selectedType: selectedType ?? this.selectedType,
      selectedRisk: selectedRisk ?? this.selectedRisk,
      warrantUsUnderlying: warrantUsUnderlying ?? this.warrantUsUnderlying,
      hasWarrant: hasWarrant ?? this.hasWarrant,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        selectedMarketMaker,
        selectedUnderlyingAsset,
        symbolList,
        marketMakerList,
        underlyingAssetList,
        uncertainUnderlyingAssetList,
        filterType,
        maturityDateSet,
        selectedMaturity,
        selectedType,
        selectedRisk,
        warrantUsUnderlying,
        hasWarrant,
      ];
}
