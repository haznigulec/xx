import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/paired_devices_model.dart';

abstract class PairedDevicesRepository {
  Future<ApiResponse> getPairedDevices();
  Future<ApiResponse> deletePairedDevices(PairedDevicesModel device);
}
