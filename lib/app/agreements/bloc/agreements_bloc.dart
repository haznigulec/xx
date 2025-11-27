import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:piapiri_v2/app/agreements/bloc/agreements_event.dart';
import 'package:piapiri_v2/app/agreements/bloc/agreements_state.dart';
import 'package:piapiri_v2/app/agreements/repository/agreements_repository.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/agreements_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class AgreementsBloc extends PBloc<AgreementsState> {
  final AgreementsRepository _agreementsRepository;

  AgreementsBloc({
    required AgreementsRepository agreementsRepository,
  })  : _agreementsRepository = agreementsRepository,
        super(initialState: const AgreementsState()) {
    on<GetAgreementsEvent>(_onGetAgreements);
    on<SetAgreementsEvent>(_onSetAgreements);
  }

  FutureOr<void> _onGetAgreements(
    GetAgreementsEvent event,
    Emitter<AgreementsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    List<AgreementsModel> agreementsList = [
      AgreementsModel(
        periodId: 'daily_agreements_period_id',
        periodStartDate: '',
        periodEndDate: DateTime.now()
            .subtract(
              const Duration(
                days: 1,
              ),
            )
            .toString(),
        noticeStartDate: '',
        noticeEndDate: '',
      ),
    ];
    String customerId = UserModel.instance.customerId ?? '';
    Map<String, int> loginCount = _agreementsRepository.readLoginCount();
    if (loginCount.keys.isNotEmpty && loginCount.keys.first != customerId) {
      _agreementsRepository.writeLastReconciliationDate(date: null);
    }
    String? lastGetReconciliationDate = _agreementsRepository.getLastReconciliationDate();
    if (lastGetReconciliationDate != DateTimeUtils.serverDate(DateTime.now())) {
      ApiResponse response = await _agreementsRepository.getAgreements(
        date: event.date,
      );
      if (response.success) {
        agreementsList.addAll(
          response.data['reconciliationDetails'].map<AgreementsModel>((e) => AgreementsModel.fromJson(e)).toList(),
        );

        if (agreementsList.length <= 1) {
          _agreementsRepository.writeLastReconciliationDate(date: event.date);
          _agreementsRepository.writeLoginCount(
            count: {
              customerId.toString(): 0,
            },
          );
        } else {
          if (loginCount.keys.isNotEmpty && loginCount.keys.first != customerId) {
            loginCount = {
              customerId: 1,
            };
          } else {
            loginCount[customerId] = (loginCount[customerId] ?? 0) + 1;
          }
          _agreementsRepository.writeLoginCount(
            count: loginCount,
          );
          event.callback?.call(loginCount, agreementsList);
        }
        emit(
          state.copyWith(
            type: PageState.success,
            agreementsList: agreementsList,
          ),
        );
      } else {
        emit(
          state.copyWith(
            type: PageState.failed,
            error: PBlocError(
              showErrorWidget: true,
              message: response.error?.message ?? '',
              errorCode: '01AGRE01',
            ),
          ),
        );
      }
    } else {
      event.callback?.call({}, []);
      emit(
        state.copyWith(
          type: PageState.success,
          agreementsList: agreementsList,
        ),
      );
    }
  }

  FutureOr<void> _onSetAgreements(
    SetAgreementsEvent event,
    Emitter<AgreementsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    String deviceIp = await IpAddress().getIpAddress();
    ApiResponse response = await _agreementsRepository.setAgreements(
      accountId: event.accountId,
      agreementPeriodId: event.agreementPeriodId,
      agreementPortfolioDate: event.agreementPortfolioDate,
      clientIp: deviceIp,
    );

    if (response.success) {
      add(
        GetAgreementsEvent(
          date: DateTimeUtils.serverDate(DateTime.now()),
          callback: (_, __) {
            event.onSuccess?.call();
          },
        ),
      );

      emit(
        state.copyWith(
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
            errorCode: '01AGRE02',
          ),
        ),
      );
    }
  }
}
