import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:p_core/utils/platform_utils.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_state.dart';
import 'package:piapiri_v2/app/enqura/model/account_setting_status_model.dart';
import 'package:piapiri_v2/app/enqura/model/contract_list_model.dart';
import 'package:piapiri_v2/app/enqura/model/enqura_create_user_model.dart';
import 'package:piapiri_v2/app/enqura/model/get_customer_contract_model.dart';
import 'package:piapiri_v2/app/enqura/model/item_list_model.dart';
import 'package:piapiri_v2/app/enqura/model/meeting_list_model.dart';
import 'package:piapiri_v2/app/enqura/model/onboarding_contracts_list_model.dart';
import 'package:piapiri_v2/app/enqura/model/start_integration_model.dart';
import 'package:piapiri_v2/app/enqura/model/working_hours_model.dart';
import 'package:piapiri_v2/app/enqura/repository/enqura_repository.dart';
import 'package:piapiri_v2/app/enqura/utils/configuration_env_enum.dart';
import 'package:piapiri_v2/app/enqura/utils/enqualify_helper.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_helpers.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_page_steps.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/extension/string_extension.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EnquraBloc extends PBloc<EnquraState> {
  final EnquraRepository _enquraRepository;

  EnquraBloc({
    required EnquraRepository enquraRepository,
  })  : _enquraRepository = enquraRepository,
        super(initialState: const EnquraState()) {
    on<GetTokenEvent>(_onGetToken);
    on<AuthRefreshEvent>(_onAuthRefresh);
    on<CheckActiveProcessEvent>(_onCheckActiveProcess);
    on<ClearActiveProcessEvent>(_onClearActiveProcess);
    on<GenerateRegisterValuesEvent>(_onGenerateRegisterValues);
    on<OtpStatusEvent>(_otpChangeOtpStatus);
    on<SendOtpEvent>(_onSendOtp);
    on<CheckOtpEvent>(_onCheckOtp);
    on<CreateOrUpdateUserEvent>(_onCreateOrUpdateUser);
    on<GetUserEvent>(_onGetUser);
    on<GetCountriesEvent>(_onGetCountries);
    on<GetCitiesEvent>(_onGetCities);
    on<GetDistrictEvent>(_onGetDistrict);
    on<GetReceiptTypesEvent>(_onGetReceiptTypes);
    on<GetProfessionsEvent>(_onGetProfessions);
    on<GetWorkingHoursEvent>(_onGetWorkingHours);
    on<EnquraGetContractListEvent>(_onGetContractList);
    on<GetOnboardingContractsEvent>(_onGetOnboardingContracts);
    on<GetCustomerContractEvent>(_onGetCustomerContract);
    on<ApproveContractsEvent>(_onApproveContracts);
    on<StartIntegrationEvent>(_onStartIntegration);
    on<UpdateManualAdresRequiredEvent>(_onUpdateManualAdresRequired);
    on<InitializeSDKEvent>(_onInitializeSDK);
    on<DestroySDKEvent>(_onDestroySDK);
    on<ValidateOCREvent>(_onValidateOcr);
    on<CheckIsCustomerEvent>(_onCheckIsCustomer);
    on<GetNfcRequriedDataEvent>(_onGetNfcRequiredData);
    on<SetMeetingDataEvent>(_onSetMeetingData);
    on<GetMeetingDataEvent>(_onGetMeetingData);
    on<GetVideoCallAvailabilityEvent>(_onGetVideoCallAvailability);
    on<ReadSessionNoEvent>(_onReadSessionNo);
    on<DeleteSessionNoEvent>(_onDeleteSessionNo);
    on<EnquraAccountSettingStatusEvent>(_enquraAccountSettingStatus);
    on<EnquraCheckReferanceCodeEvent>(_onCheckReferanceCode);
    on<PostIntegrationAddEvent>(_onPostIntegrationAdd);
    on<GetAppointmentEvent>(_onGetAppointment);
    on<SaveAppointmentEvent>(_onSaveAppointment);
    on<ClearAppointmentEvent>(_onClearAppointment);
  }

  FutureOr<void> _onGetToken(
    GetTokenEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    if (!event.setNewToken) {
      final enquraAccessToken = await getIt<LocalStorage>().readSecure('enquraAccessToken');
      final enquraRefreshToken = await getIt<LocalStorage>().readSecure('enquraRefreshToken');
      if (enquraAccessToken != null && enquraRefreshToken != null) {
        event.onSuccess?.call();
        state.copyWith(
          type: PageState.success,
        );
        return;
      }
    }

    ApiResponse response = await _enquraRepository.authLogin();
    if (response.success && response.data != null) {
      getIt<LocalStorage>().writeSecure(
        'enquraAccessToken',
        response.data['accessToken'],
      );
      getIt<LocalStorage>().writeSecure(
        'enquraRefreshToken',
        response.data['refreshToken'],
      );
      event.onSuccess?.call();
      state.copyWith(
        type: PageState.success,
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onAuthRefresh(
    AuthRefreshEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.authRefresh(
      refreshToken: event.authRefresh,
    );
    if (response.success && response.data != null) {
      getIt<LocalStorage>().writeSecure(
        'enquraAccessToken',
        response.data['accessToken'],
      );
      getIt<LocalStorage>().writeSecure(
        'enquraRefreshToken',
        response.data['refreshToken'],
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
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR02',
          ),
        ),
      );
    }
  }

  FutureOr<void> _otpChangeOtpStatus(
    OtpStatusEvent event,
    Emitter<EnquraState> emit,
  ) async {
    if (state.otpIsRequired != event.otpIsRequired) {
      emit(
        state.copyWith(
          otpIsRequired: event.otpIsRequired,
        ),
      );
    }
  }

  FutureOr<void> _onSendOtp(
    SendOtpEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.sendOtp(
      sessionNo: event.sessionNo,
      phoneNo: event.phoneNo,
    );

    if (response.success && response.data != null && response.data['errorCode'] == null) {
      event.onSuccess(response);
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      //errorcode 909
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'enqura.${response.data['errorMessage']}',
            errorCode: '07ENQR03',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onCheckOtp(
    CheckOtpEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _enquraRepository.checkOtp(
      sessionNo: event.sessionNo,
      phoneNo: event.phoneNo,
      otpCode: event.otpCode,
    );

    if (response.success &&
        response.data != null &&
        response.data['errorCode'] == null &&
        response.data['isValid'] == true) {
      emit(
        state.copyWith(
          otpIsRequired: false,
          type: PageState.success,
        ),
      );
      event.onSuccess?.call();
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'enqura.${response.data['errorMessage']}',
            errorCode: '07ENQR03',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onCreateOrUpdateUser(
    CreateOrUpdateUserEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.createOrUpdateUser(
      user: event.user,
    );
    if (response.success) {
      var eventPhoneNumber = event.user.phoneNumber;
      if (eventPhoneNumber?.isNotEmpty == true) {
        var localPhone = await getIt<LocalStorage>().read(LocalKeys.enquraPhoneNumber);
        if (eventPhoneNumber != localPhone) {
          if (localPhone != null) {
            await getIt<LocalStorage>().deleteAsync(LocalKeys.enquraPhoneNumber);
          }
          if (event.user.videoCallCompleted != true) {
            await getIt<LocalStorage>().writeAsync(
              LocalKeys.enquraPhoneNumber,
              eventPhoneNumber,
            );
          }
        }
      }

      bool otpIsRequired = state.otpIsRequired;
      if (otpIsRequired && event.user.otpCode?.isNotEmpty == true) {
        otpIsRequired = false;
      }

      emit(
        state.copyWith(
          otpIsRequired: otpIsRequired,
          phoneNumber: eventPhoneNumber?.isNotEmpty == true ? eventPhoneNumber : state.phoneNumber,
          type: PageState.success,
        ),
      );
      event.onSuccess?.call();
    } else {
      emit(
        state.copyWith(
          type: PageState.success,
          error: PBlocError(
            showErrorWidget: true,
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR04',
          ),
        ),
      );
    }

    // if (response.success) {
    //   emit(
    //     state.copyWith(
    //       type: PageState.success,
    //     ),
    //   );
    // }
    // if (response.error?.message == 'OtpIsInvalid') {
    //   emit(
    //     state.copyWith(
    //       type: PageState.failed,
    //       error: PBlocError(
    //         showErrorWidget: true,
    //         message: L10n.tr(
    //           'member.${response.error?.message ?? ''}',
    //         ),
    //         errorCode: '09MEMB001',
    //       ),
    //     ),
    //   );
    // } else {
    //   emit(
    //     state.copyWith(
    //       type: PageState.success,
    //     ),
    //   );
    //   event.callback(response);
    // }
  }

  FutureOr<void> _onGetUser(
    GetUserEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _enquraRepository.getUsers(
      gsm: event.phoneNumber,
      guid: event.guid,
    );
    if (response.success) {
      EnquraAccountSettingStatusModel? accountSettingStatus;
      var user = EnquraCreateUserModel.fromJson(response.data);
      if (event.isFirstInitialize) {
        String currentState = user.occupation?.isNotEmpty == true
            ? EnquraPageSteps.financialInformation
            : EnquraPageSteps.personalInformation;
        accountSettingStatus = enquraAccountSettingStatusGenerator(currentState);
      } else {
        accountSettingStatus = event.forceOldStatus ?? enquraAccountSettingStatusGenerator(user.currentStep ?? '');
      }

      emit(
        state.copyWith(
          user: user,
          accountSettingStatus: accountSettingStatus,
          type: PageState.success,
        ),
      );
      event.successCallback?.call();
    } else {
      if (event.errorCallback != null) {
        final Completer<void> completer = Completer<void>();
        event.errorCallback?.call(completer);
        await completer.future;
      }
      emit(
        state.copyWith(
          accountSettingStatus: state.accountSettingStatus ?? EnquraAccountSettingStatusModel(),
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR05',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetCountries(
    GetCountriesEvent event,
    Emitter<EnquraState> emit,
  ) async {
    if (state.countries?.isNotEmpty == true) return;

    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.getCountries();

    if (response.success && response.data != null) {
      List<ItemListModel> countries =
          response.data['itemlist'].map<ItemListModel>((e) => ItemListModel.fromJson(e)).toList();
      event.onSuccessCallBack?.call(countries);
      emit(
        state.copyWith(
          type: PageState.success,
          countries: countries,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR06',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetCities(
    GetCitiesEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.getCities();

    if (response.success && response.data != null) {
      List<ItemListModel> cities =
          response.data['itemlist'].map<ItemListModel>((e) => ItemListModel.fromJson(e)).toList();

      emit(
        state.copyWith(
          type: PageState.success,
          cities: cities,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR07',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetDistrict(
    GetDistrictEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.getDistrict(
      cityCode: event.cityCode,
    );

    if (response.success && response.data != null) {
      List<ItemListModel> districts =
          response.data['itemlist'].map<ItemListModel>((e) => ItemListModel.fromJson(e)).toList();
      districts = districts.where((e) => e.key != '0').toList();

      emit(
        state.copyWith(
          type: PageState.success,
          districts: districts,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR08',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetProfessions(
    GetProfessionsEvent event,
    Emitter<EnquraState> emit,
  ) async {
    if (state.professions?.isNotEmpty == true) return;

    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _enquraRepository.getProfessions();
    if (response.success && response.data != null) {
      List<ItemListModel> professions =
          response.data['itemlist'].map<ItemListModel>((e) => ItemListModel.fromJson(e)).toList();
      professions = professions
          .map<ItemListModel>((e) => ItemListModel.fromJson({
                'key': e.key,
                'value': e.value.toString().toCapitalizeCaseTrAdvanced,
              }))
          .toList();

      event.onSuccessCallBack?.call(professions);
      emit(
        state.copyWith(
          type: PageState.success,
          professions: professions,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR09',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetReceiptTypes(
    GetReceiptTypesEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.getReceiptTypes();

    if (response.success && response.data != null) {
      List<ItemListModel> receiptTypes =
          response.data['itemList'].map<ItemListModel>((e) => ItemListModel.fromJson(e)).toList();

      emit(
        state.copyWith(
          type: PageState.success,
          receiptTypes: receiptTypes,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR10',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetWorkingHours(
    GetWorkingHoursEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.getWorkingHours();

    if (response.success && response.data != null) {
      List<WorkingHourModel> workingHours =
          response.data['workingHours'].map<WorkingHourModel>((e) => WorkingHourModel.fromJson(e)).toList();

      emit(
        state.copyWith(
          type: PageState.success,
          workingHour: workingHours,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR11',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetContractList(
    EnquraGetContractListEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.getContractList();

    if (response.success && response.data != null) {
      List<ContractListModel> contracts =
          response.data['contracts'].map<ContractListModel>((e) => ContractListModel.fromJson(e)).toList();

      emit(
        state.copyWith(
          type: PageState.success,
          contracts: contracts,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR12',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetOnboardingContracts(
    GetOnboardingContractsEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.getOnboardingContracts(
      sessionNo: event.sessionNo,
      referenceCode: event.referenceCode,
    );

    if (response.success && response.data != null && response.data['contractList'] != null) {
      List<OnboardingContractsListModel> onboardingContracts = response.data['contractList']
          .map<OnboardingContractsListModel>((e) => OnboardingContractsListModel.fromJson(e))
          .toList();

      emit(
        state.copyWith(
          type: PageState.success,
          onboardingContracts: onboardingContracts,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.success ? 'enqura.${response.data['errorCode']}' : 'enqura.${response.error?.message}',
            errorCode: '07ENQR13',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onStartIntegration(
    StartIntegrationEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.startIntegration(
      sessionNo: event.sessionNo,
      identityNumber: event.identityNumber,
      birthYear: event.birthYear,
      birthMonth: event.birthMonth,
      birthDay: event.birthDay,
      phone: event.phone,
      etk: event.etk,
    );

    if (response.success &&
        response.data != null &&
        response.data['errorCode'] != null &&
        response.data['errorCode'].isEmpty &&
        response.data['referanceCode']?.isNotEmpty == true) {
      StartIntegrationModel startIntegration = StartIntegrationModel.fromJson(response.data);
      if (event.manualAdresRequired != null) {
        startIntegration = startIntegration.copyWith(
          manualAdresRequired: event.manualAdresRequired,
        );
      }
      emit(
        state.copyWith(
          type: PageState.success,
          startIntegration: startIntegration,
        ),
      );
      event.successCallback?.call();
    } else {
      event.errorCallback?.call(StartIntegrationModel.fromJson(response.data));
    }
  }

  FutureOr<void> _onUpdateManualAdresRequired(
    UpdateManualAdresRequiredEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.success,
        startIntegration: state.startIntegration?.copyWith(
          manualAdresRequired: event.manualAdresRequired,
        ),
      ),
    );
  }

  FutureOr<void> _onInitializeSDK(
    InitializeSDKEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    bool isInitializedSDK = false;
    bool isStartedSession = false;

    final config = getConfiguration(
      AppConfig.instance.flavor == Flavor.dev ? Environment.aitest : Environment.unlucoAI,
    );
    final referanceCode =
        event.checkAppointment ? state.appointmentReferenceCode ?? '' : state.startIntegration?.referanceCode ?? '';
    if (PlatformUtils.isAndroid) {
      if (state.appointmentReferenceCode != null && state.appointmentReferenceCode!.isNotEmpty) {
        await EnqualifyHelper.setIsContinue(true);
      } else {
        await EnqualifyHelper.setIsContinue(false);
      }
    }

    await EnqualifyHelper.setUserInfo(
      purpose: state.callType,
      isHandicapped: false,
      tckn: state.user?.identityNumber ?? '',
      phone: state.user?.phoneNumber ?? '',
      identityType: state.identityType,
      email: state.user?.email ?? '',
    );

    isInitializedSDK = await EnqualifyHelper.initialize(
      config: config,
      referenceId: referanceCode,
    );

    AppointmentData? appointmentData;
    if (isInitializedSDK) {
      isStartedSession = PlatformUtils.isIos ? true : await EnqualifyHelper.startSession();
      if (event.checkAppointment) {
        final response = await EnqualifyHelper.getAppointments();
        if (response.isSuccessful && response.data.isNotEmpty) {
          appointmentData = response.data.first;
        }
      }
    }

    final appointmentConrol = !event.checkAppointment || (event.checkAppointment && appointmentData != null);
    if (isInitializedSDK && isStartedSession && appointmentConrol) {
      emit(
        state.copyWith(
          sdkIsActive: true,
          appointmentData: appointmentData,
          type: PageState.success,
        ),
      );
    } else {
      add(DestroySDKEvent());
      emit(
        state.copyWith(
          sdkIsActive: false,
          cleanAppointmentData: true,
          type: event.checkAppointment ? PageState.success : PageState.failed,
          error: PBlocError(
            showErrorWidget: event.checkAppointment ? false : true,
            message: L10n.tr('enqura_sdk_starting_error'),
            errorCode: '',
          ),
        ),
      );
    }
    event.callback?.call(appointmentConrol);
  }

  FutureOr<void> _onDestroySDK(
    DestroySDKEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    if (event.runDestroy) {
      await EnqualifyHelper.onDestroySDK();
    }
    emit(
      state.copyWith(
        sdkIsActive: false,
        type: PageState.success,
      ),
    );
  }

  FutureOr<void> _onGetCustomerContract(
    GetCustomerContractEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.getCustomerContract(
      sessionNo: event.sessionNo,
      identityNumber: event.identityNumber,
    );

    if (response.success && response.data != null) {
      List<GetCustomerContractModel> customerContracts = response.data['contractList']
          .map<GetCustomerContractModel>((e) => GetCustomerContractModel.fromJson(e))
          .toList();

      emit(
        state.copyWith(
          type: PageState.success,
          customerContracts: customerContracts,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR15',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onApproveContracts(
    ApproveContractsEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.approveContracts(
      sessionNo: event.sessionNo,
      contractRefCode: event.contractRefCode,
    );

    if (response.success && response.data != null) {
      event.isValidCallback?.call(
        response.data['isValid'],
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
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR16',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onValidateOcr(
    ValidateOCREvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.validateOcr(
      sessionNo: event.sessionNo,
      refCode: event.refCode,
    );

    if (response.success && response.data != null) {
      event.isValidCallback?.call(
        response.data['isValid'],
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
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR17',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onCheckIsCustomer(
    CheckIsCustomerEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.checkIsCustomer(
      sessionNo: event.sessionNo,
      tckn: event.tckn,
    );

    if (response.success && response.data != null) {
      bool isActiveAccount =
          response.data['customerExtId']?.toString().isNotEmpty == true && response.data['status'] == 'Active';
      event.onSuccess?.call(isActiveAccount);
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
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR18',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetNfcRequiredData(
    GetNfcRequriedDataEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.getNfcRequiredData(
      sessionNo: event.sessionNo,
      referanceCode: event.referanceCode,
    );

    if (response.success && response.data != null) {
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
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR19',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onSetMeetingData(
    SetMeetingDataEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final metingtime = event.meetingTime.toIso8601String();
    ApiResponse response = await _enquraRepository.setMeetingData(
        sessionNo: event.sessionNo, referanceCode: event.referanceCode, meetingTime: metingtime);

    if (response.success && response.data != null) {
      event.onSuccessCallBack?.call(
        response.data['isSuccess'],
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
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR21',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetMeetingData(
    GetMeetingDataEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.getMeetingData(
      sessionNo: event.sessionNo,
      identityNo: event.identityNo,
    );

    if (response.success && response.data != null) {
      List<MeetingListModel> meetingList =
          response.data['meetingDataList'].map<MeetingListModel>((e) => MeetingListModel.fromJson(e)).toList();
      emit(
        state.copyWith(
          meetingList: meetingList,
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR22',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetVideoCallAvailability(
    GetVideoCallAvailabilityEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _enquraRepository.getVideoCallAvailability(
      sessionNo: event.sessionNo,
    );

    if (response.success && response.data != null) {
      final Completer<void> completer = Completer<void>();
      event.onSuccessCallBack?.call(
        response.data['canConnectVideoCall'],
        completer,
      );
      await completer.future;
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
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR23',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onCheckActiveProcess(
    CheckActiveProcessEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    String? phoneNumber = await getIt<LocalStorage>().read(LocalKeys.enquraPhoneNumber);
    emit(
      state.copyWith(
        type: PageState.success,
      ),
    );
    event.callback?.call(phoneNumber != null && phoneNumber.isNotEmpty == true);
  }

  FutureOr<void> _onClearActiveProcess(
    ClearActiveProcessEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    await getIt<LocalStorage>().deleteAsync(LocalKeys.enquraPhoneNumber);
    await getIt<LocalStorage>().deleteAsync(LocalKeys.enquraAppointmentReferenceCode);

    emit(const EnquraState());
  }

  FutureOr<void> _onGenerateRegisterValues(
    GenerateRegisterValuesEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    // enqura register ekranından enqura ekranına gelirse session no üretmesine gerek olmadığı için eklendi.
    if (event.onGenerateSessionNo) {
      await _enquraRepository.generateSessionNo();
    }

    String sessionNo = await _enquraRepository.readSessionNo();
    String guid = await _enquraRepository.readGuid();
    if (guid.isEmpty) {
      await _enquraRepository.generateGuid();
      guid = await _enquraRepository.readGuid();
    }

    String? appointmentReferenceCode = await getIt<LocalStorage>().read(LocalKeys.enquraAppointmentReferenceCode);
    String? phoneNumber = await getIt<LocalStorage>().read(LocalKeys.enquraPhoneNumber);

    emit(
      state.copyWith(
        sessionNo: sessionNo,
        guid: guid,
        appointmentReferenceCode: appointmentReferenceCode,
        phoneNumber: phoneNumber,
        type: PageState.success,
      ),
    );
    event.callback?.call();
  }

  FutureOr<void> _onReadSessionNo(
    ReadSessionNoEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    String sessionNo = await _enquraRepository.readSessionNo();
    event.onCallBack?.call(sessionNo);
    emit(
      state.copyWith(
        type: PageState.success,
        sessionNo: sessionNo,
      ),
    );
  }

  FutureOr<void> _onDeleteSessionNo(
    DeleteSessionNoEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    _enquraRepository.deleteSessionNo();
    event.onSuccessCallBack?.call(
      true,
    );
    emit(
      state.copyWith(
        type: PageState.success,
      ),
    );
  }

  FutureOr<void> _enquraAccountSettingStatus(
    EnquraAccountSettingStatusEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    final accountSettingStatus = enquraAccountSettingStatusGenerator(
      event.currentStep,
    );
    emit(
      state.copyWith(
        type: PageState.success,
        accountSettingStatus: accountSettingStatus,
      ),
    );
  }

  FutureOr<void> _onCheckReferanceCode(
    EnquraCheckReferanceCodeEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    bool isValid = false;
    ApiResponse response = await _enquraRepository.refCodeValidate(refCode: event.refCode);
    if (response.success && response.data != null) {
      isValid = response.data['isValid'];
      if (isValid) {
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
              message: L10n.tr('referance_code_validate_error'),
              errorCode: '',
            ),
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'enqura.${response.error?.message}',
            errorCode: '07ENQR24',
          ),
        ),
      );
    }
    event.callBack.call(isValid);
  }

  FutureOr<void> _onPostIntegrationAdd(
    PostIntegrationAddEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final occupation = state.user?.occupation;
    ItemListModel? profession;
    if (occupation?.isNotEmpty == true) {
      profession = state.professions?.where((e) => e.key == occupation).firstOrNull;
    }

    await EnqualifyHelper.postIntegrationAddRequest(
      'Session',
      state.startIntegration?.referanceCode ?? '',
      jsonEncode({
        'name': state.startIntegration?.name ?? '',
        'surname': state.startIntegration?.surname ?? '',
        'email': state.user?.email ?? '',
        'foreignLiabilityCountry': state.user?.foreignTaxCountry ?? '',
        'foreignLiabilityEIN': state.user?.employerIdentificationNo ?? '',
        'foreignLiabilitySSN': state.user?.socialSecurityNumber ?? '',
        'foreignLiabilityTaxNumber': state.user?.foreignTaxIdentificationNo ?? '',
        'founderOfCompany': state.user?.isCompanyFounder ?? false,
        'companyName': state.user?.companyName ?? '',
        'foundingPercent': state.user?.sharePercentage ?? 0,
        'interestPreference': false,
        'professionCode': profession?.key ?? '',
        'professionDescription': profession?.value ?? '',
        'referanceCode': state.startIntegration?.referanceCode ?? '',
        'sessionNo': state.sessionNo ?? '',
        'statementPreference': state.user?.profitSharePreference == true ? 1 : 2,
        'vendorCode': 'Piapiri-Enqura',
        'IysOptIn': state.user?.etk ?? false,
      }),
    );
    event.onCallback?.call();
    emit(
      state.copyWith(
        type: PageState.success,
      ),
    );
  }

  FutureOr<void> _onGetAppointment(
    GetAppointmentEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    AppointmentData? appointmentData;
    final response = await EnqualifyHelper.getAppointments();
    if (response.isSuccessful && response.data.isNotEmpty) {
      appointmentData = response.data.first;
    }

    event.onCallback?.call(
      appointmentData,
    );

    emit(
      state.copyWith(
        cleanAppointmentData: appointmentData == null,
        appointmentData: appointmentData,
        type: PageState.success,
      ),
    );
  }

  FutureOr<void> _onSaveAppointment(
    SaveAppointmentEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    final date = event.appointmentItem.date.dateTime.date;
    final response = await EnqualifyHelper.saveAppointment(
      state.callType,
      null,
      null,
      DateTime(
        date.year,
        date.month,
        date.day,
      ),
      event.appointmentItem.startTime,
    );

    final isSuccessfull = response?.isSuccessful ?? false;
    if (isSuccessfull) {
      await getIt<LocalStorage>()
          .writeAsync(LocalKeys.enquraAppointmentReferenceCode, state.startIntegration?.referanceCode);
    }

    emit(
      state.copyWith(
        type: PageState.success,
      ),
    );
    event.onCallback?.call(isSuccessfull);
  }

  FutureOr<void> _onClearAppointment(
    ClearAppointmentEvent event,
    Emitter<EnquraState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    await getIt<LocalStorage>().deleteAsync(LocalKeys.enquraAppointmentReferenceCode);
    emit(
      state.copyWith(
        cleanAppointmentData: true,
        type: PageState.success,
      ),
    );

    event.onCallback?.call();
  }
}
