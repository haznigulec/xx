import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/paride_devices/bloc/paired_devices_event.dart';
import 'package:piapiri_v2/app/paride_devices/bloc/paired_devices_state.dart';
import 'package:piapiri_v2/app/paride_devices/repository/paired_devices_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/paired_devices_model.dart';

class PairedDevicesBloc extends PBloc<PairedDevicesState> {
  final PairedDevicesRepository _pairedDevicesRepository;

  PairedDevicesBloc({required PairedDevicesRepository pairedDevicesRepository})
      : _pairedDevicesRepository = pairedDevicesRepository,
        super(initialState: const PairedDevicesState()) {
    on<GetPairedDevicesEvent>(_onGetPairedDevices);
    on<DeletePairedDevicesEvent>(_onDeletePairedDevices);
  }

  FutureOr<void> _onGetPairedDevices(
    GetPairedDevicesEvent event,
    Emitter<PairedDevicesState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _pairedDevicesRepository.getPairedDevices();

    if (response.success) {
      List<PairedDevicesModel> devices = (response.data as List).map((e) => PairedDevicesModel.fromJson(e)).toList();
      devices.sort((a, b) => b.lastLoginDate.compareTo(a.lastLoginDate));
      //Move current device to the top of the list
      devices.sort((a, b) {
        if (a.isCurrentDevice && !b.isCurrentDevice) {
          return -1;
        } else if (!a.isCurrentDevice && b.isCurrentDevice) {
          return 1;
        } else {
          return 0;
        }
      });
      event.callback?.call(devices);
      emit(
        state.copyWith(
          type: PageState.success,
          pairedDeviceList: devices,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        type: PageState.failed,
        error: PBlocError(
          showErrorWidget: true,
          message: response.error?.message ?? '',
          errorCode: '03PD001',
        ),
      ),
    );
  }

  FutureOr<void> _onDeletePairedDevices(
    DeletePairedDevicesEvent event,
    Emitter<PairedDevicesState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _pairedDevicesRepository.deletePairedDevices(event.device);
    event.callback?.call();
    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        type: PageState.failed,
        error: PBlocError(
          showErrorWidget: true,
          message: response.error?.message ?? '',
          errorCode: '03PD001',
        ),
      ),
    );
  }
}
