import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/license_model.dart';

class LicenseState extends PState {
  final List<LicenseModel> licenseList;
  final bool isDepthEnabled;
  final bool isDepthExtendedEnabled;
  final bool isBookletEnabled;
  final int totalStage;
  final bool isViopDepthEnabled;
  final bool isViopDepthExtendedEnabled;
  final int totalViopStage;
  final bool isBrokerageEnabled;
  final bool isViopBrokerageEnabled;
  const LicenseState({
    super.type = PageState.initial,
    super.error,
    this.licenseList = const [],
    this.isDepthEnabled = false,
    this.isDepthExtendedEnabled = false,
    this.isBookletEnabled = false,
    this.totalStage = 0,
    this.isViopDepthEnabled = false,
    this.isViopDepthExtendedEnabled = false,
    this.totalViopStage = 0,
    this.isBrokerageEnabled = false,
    this.isViopBrokerageEnabled = false,
  });

  @override
  LicenseState copyWith({
    PageState? type,
    PBlocError? error,
    List<LicenseModel>? licenseList,
    bool? isDepthEnabled,
    bool? isDepthExtendedEnabled,
    bool? isBookletEnabled,
    int? totalStage,
    bool? isViopDepthEnabled,
    bool? isViopDepthExtendedEnabled,
    int? totalViopStage,
    bool? isBrokerageEnabled,
    bool? isViopBrokerageEnabled,
  }) {
    return LicenseState(
      type: type ?? this.type,
      error: error ?? this.error,
      licenseList: licenseList ?? this.licenseList,
      isDepthEnabled: isDepthEnabled ?? this.isDepthEnabled,
      isDepthExtendedEnabled: isDepthExtendedEnabled ?? this.isDepthExtendedEnabled,
      isBookletEnabled: isBookletEnabled ?? this.isBookletEnabled,
      totalStage: totalStage ?? this.totalStage,
      isViopDepthEnabled: isViopDepthEnabled ?? this.isViopDepthEnabled,
      isViopDepthExtendedEnabled: isViopDepthExtendedEnabled ?? this.isViopDepthExtendedEnabled,
      totalViopStage: totalViopStage ?? this.totalViopStage,
      isBrokerageEnabled: isBrokerageEnabled ?? this.isBrokerageEnabled,
      isViopBrokerageEnabled: isViopBrokerageEnabled ?? this.isViopBrokerageEnabled,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        licenseList,
        isDepthEnabled,
        isDepthExtendedEnabled,
        isBookletEnabled,
        totalStage,
        isViopDepthEnabled,
        isViopDepthExtendedEnabled,
        totalViopStage,
        isBrokerageEnabled,
        isViopBrokerageEnabled,
      ];
}
