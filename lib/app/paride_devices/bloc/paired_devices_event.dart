import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/paired_devices_model.dart';

abstract class PairedDevicesEvent extends PEvent {}

class GetPairedDevicesEvent extends PairedDevicesEvent {
  final Function(List<PairedDevicesModel>)? callback;

  GetPairedDevicesEvent({this.callback});
}

class DeletePairedDevicesEvent extends PairedDevicesEvent {
  final PairedDevicesModel device;
  final Function()? callback;

  DeletePairedDevicesEvent({required this.device, this.callback});
}
