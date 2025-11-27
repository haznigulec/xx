import 'package:piapiri_v2/app/brokerage_distribution/repository/brokerage_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class BrokerageRepositoryImpl implements BrokerageRepository {
  @override
  Future<ApiResponse> getBrokerageDistribution({
    required String symbol,
    required int top,
    String dateFilter = '',
    required String url,
  }) async {
    return getIt<PPApi>().brokerageService.getBrokerageDistribution(
          symbol: symbol,
          top: top,
          dateFilter: dateFilter,
          url: getIt<MatriksBloc>().state.endpoints!.rest!.akd!.url ?? '',
        );
  }
}
