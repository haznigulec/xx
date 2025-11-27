import 'package:piapiri_v2/app/paride_devices/repository/paired_devices_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/paired_devices_model.dart';

class PairedDevicesRepositoryImpl extends PairedDevicesRepository {
  @override
  Future<ApiResponse> getPairedDevices() async {
    return getIt<PPApi>().profileService.getPairedDevices();
  }

  @override
  Future<ApiResponse> deletePairedDevices(PairedDevicesModel device) async {
    return getIt<PPApi>().profileService.deletePairedDevices(device);
  }
}
