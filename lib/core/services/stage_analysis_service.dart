import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class StageAnalysisService {
  final MatriksApiClient matriksApiClient;

  StageAnalysisService(this.matriksApiClient);

  Future<ApiResponse> stageAnalysisData({
    required String symbol,
  }) async {
    return await matriksApiClient.get(
      '${getIt<MatriksBloc>().state.endpoints!.rest!.tpd!.url ?? ''}?symbol=$symbol',
    );
  }
}
