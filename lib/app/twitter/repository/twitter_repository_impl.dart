import 'package:piapiri_v2/app/twitter/repository/twitter_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class TwitterRepositoryImpl extends TwitterRepository {
  @override
  Future<ApiResponse> getTwitterList({
    required String symbolName,
  }) {
    return getIt<PPApi>().twitterService.getTwitterList(
          url: getIt<MatriksBloc>().state.endpoints!.rest!.twitter!.twitter?.url ?? '',
          parameter: getIt<MatriksBloc>().state.endpoints!.rest!.twitter!.twitter?.parameters?[0] ?? '',
          symbolName: symbolName,
        );
  }
}
