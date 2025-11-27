import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class BalanceService {
  final MatriksApiClient matriksApiClient;

  BalanceService(
    this.matriksApiClient,
  );

  Future<ApiResponse> getBalanceYearInfo({
    required String symbolName,
  }) async {
    return matriksApiClient.get(
      '${getIt<MatriksBloc>().state.endpoints!.rest!.fundamentals!.periods!.url ?? ''}?symbol=$symbolName',
    );
  }

  Future<ApiResponse> getBalance({
    required String symbolName,
    required String period,
  }) async {
    return matriksApiClient.get(
      '${getIt<MatriksBloc>().state.endpoints!.rest!.fundamentals!.bS!.url ?? ''}?symbols=$symbolName&periods=$period',
    );
  }
}
