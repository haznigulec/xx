import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:piapiri_v2/app/member/bloc/member_event.dart';
import 'package:piapiri_v2/app/member/bloc/member_state.dart';
import 'package:piapiri_v2/app/member/repository/member_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class MemberBloc extends PBloc<MemberState> {
  final MemberRepository _memberRepository;
  MemberBloc({required MemberRepository memberRepository})
      : _memberRepository = memberRepository,
        super(initialState: const MemberState()) {
    on<CreateMemberEvent>(_onCreateMember);
    on<MemberRequestOtpEvent>(_onMemberRequestOtp);
    on<MemberInfoEvent>(_onMemberInfo);
    on<DeleteMemberEvent>(_onDeleteMember);
  }

  FutureOr<void> _onCreateMember(
    CreateMemberEvent event,
    Emitter<MemberState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _memberRepository.createMember(
      fullName: event.fullName,
      gsm: event.gsm,
      email: event.email ?? '',
      kvkk: event.kvkk,
      etk: event.etk,
      otp: event.otp,
    );
    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    }
    if (response.error?.message == 'OtpIsInvalid') {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr(
              'member.${response.error?.message ?? ''}',
            ),
            errorCode: '09MEMB001',
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.callback(response);
    }
  }

  FutureOr<void> _onMemberRequestOtp(
    MemberRequestOtpEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _memberRepository.memberRequestOtp(
      gsm: event.gsm,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.onSuccess(response);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '09MEMB002',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onMemberInfo(
    MemberInfoEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _memberRepository.memberInfo(
      gsm: event.gsm,
    );

    if (response.success) {
      emit(
        state.copyWith(
          memberInfo: response.data,
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '09MEMB003',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onDeleteMember(
    DeleteMemberEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _memberRepository.memberDelete(
      gsm: event.gsm,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.onSuccess(response.success);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '09MEMB004',
          ),
        ),
      );
    }
  }
}
