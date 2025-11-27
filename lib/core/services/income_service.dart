import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class IncomeService {
  final MatriksApiClient matriksApiClient;

  IncomeService(
    this.matriksApiClient,
  );

  Future<ApiResponse> getIncome({
    required String symbolName,
    required String period,
  }) async {
    return matriksApiClient.get(
      '${getIt<MatriksBloc>().state.endpoints!.rest!.fundamentals!.iNC!.url ?? ''}?symbols=$symbolName&periods=$period',
    );
  }
}
