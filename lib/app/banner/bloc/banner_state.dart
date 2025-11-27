import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/banner_model.dart';

class BannerState extends PState {
  final List<BannerModel> banners;
  final bool isExpanded;

  const BannerState({
    super.type = PageState.initial,
    super.error,
    this.banners = const [],
    this.isExpanded = true,
  });

  @override
  BannerState copyWith({
    PageState? type,
    PBlocError? error,
    List<BannerModel>? banners,
    bool? isExpanded,
  }) {
    return BannerState(
      type: type ?? this.type,
      error: error ?? this.error,
      banners: banners ?? this.banners,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        banners,
        isExpanded,
      ];
}
