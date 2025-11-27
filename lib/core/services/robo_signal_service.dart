import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class RoboSignalService {
  final ApiClient api;

  RoboSignalService(this.api);

  static const String _getRoboSignalsUrl = '/robosignals/getall';

  Future<ApiResponse> getRoboSignals() async {
    return api.post(
      _getRoboSignalsUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }
}
