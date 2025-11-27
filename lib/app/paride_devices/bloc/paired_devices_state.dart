import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/paired_devices_model.dart';

class PairedDevicesState extends PState {
  final List<PairedDevicesModel> pairedDeviceList;

  const PairedDevicesState({
    super.type = PageState.initial,
    super.error,
    this.pairedDeviceList = const [],
  });

  @override
  PairedDevicesState copyWith({
    PageState? type,
    PBlocError? error,
    List<PairedDevicesModel>? pairedDeviceList,
  }) {
    return PairedDevicesState(
      type: type ?? this.type,
      error: error ?? this.error,
      pairedDeviceList: pairedDeviceList ?? this.pairedDeviceList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        pairedDeviceList,
      ];
}
