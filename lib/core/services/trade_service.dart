import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';

class TradeService {
  final MatriksApiClient matriksApiClient;

  TradeService(this.matriksApiClient);

  // Future<ApiResponse> getTradeData({
  //   required String date,
  //   required String symbol,
  //   String? top,
  // }) async {
  //   String url = getIt<MatriksBloc>().state.endpoints!.rest!.agentAssets!.url ?? '';
  //   return await matriksApiClient.get(
  //     top == null ? '$url?symbol=$symbol&date=$date' : '$url?symbol=$symbol&top=$top&date=$date',
  //   );
  // }
}
