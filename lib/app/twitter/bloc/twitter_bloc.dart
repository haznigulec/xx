import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/twitter/bloc/twitter_event.dart';
import 'package:piapiri_v2/app/twitter/bloc/twitter_state.dart';
import 'package:piapiri_v2/app/twitter/repository/twitter_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/twitter_model.dart';

class TwitterBloc extends PBloc<TwitterState> {
  final TwitterRepository _twitterRepository;

  TwitterBloc({
    required TwitterRepository twitterRepository,
  })  : _twitterRepository = twitterRepository,
        super(
          initialState: const TwitterState(),
        ) {
    on<GetListEvent>(_onGetTwitterList);
  }

  FutureOr<void> _onGetTwitterList(
    GetListEvent event,
    Emitter<TwitterState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _twitterRepository.getTwitterList(
      symbolName: event.symbol.replaceAll('_', ''),
    );

    if (response.success) {
      List<TwitterModel> twitterList = [];

      twitterList = response.data.map<TwitterModel>((e) => TwitterModel.fromJson(e)).toList();

      emit(
        state.copyWith(
          type: PageState.success,
          twitterList: twitterList,
        ),
      );
    } else {
      state.twitterList?.clear();
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: response.error?.message ?? '',
            errorCode: '01TWT001',
          ),
        ),
      );
    }
  }
}
