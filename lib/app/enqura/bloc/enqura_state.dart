import 'package:piapiri_v2/app/enqura/model/account_setting_status_model.dart';
import 'package:piapiri_v2/app/enqura/model/contract_list_model.dart';
import 'package:piapiri_v2/app/enqura/model/enqura_create_user_model.dart';
import 'package:piapiri_v2/app/enqura/model/get_customer_contract_model.dart';
import 'package:piapiri_v2/app/enqura/model/item_list_model.dart';
import 'package:piapiri_v2/app/enqura/model/meeting_list_model.dart';
import 'package:piapiri_v2/app/enqura/model/onboarding_contracts_list_model.dart';
import 'package:piapiri_v2/app/enqura/model/start_integration_model.dart';
import 'package:piapiri_v2/app/enqura/model/working_hours_model.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_helpers.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class EnquraState extends PState {
  final bool sdkIsActive;
  final bool otpIsRequired;
  final String? sessionNo;
  final String? guid;
  final String? phoneNumber;
  final EnquraCreateUserModel? user;
  final EnquraAccountSettingStatusModel? accountSettingStatus;
  final List<ItemListModel>? countries;
  final List<ItemListModel>? cities;
  final List<ItemListModel>? districts;
  final List<ItemListModel>? professions;
  final List<ItemListModel>? receiptTypes;
  final List<WorkingHourModel>? workingHour;
  final List<ContractListModel>? contracts;
  final List<OnboardingContractsListModel>? onboardingContracts;
  final List<GetCustomerContractModel>? customerContracts;
  final StartIntegrationModel? startIntegration;
  final List<MeetingListModel>? meetingList;
  final String? appointmentReferenceCode;
  final AppointmentData? appointmentData;
  final String callType;
  final String identityType;

  const EnquraState({
    super.type = PageState.initial,
    super.error,
    this.sdkIsActive = false,
    this.otpIsRequired = true,
    this.sessionNo = '',
    this.guid = '',
    this.phoneNumber = '',
    this.user,
    this.countries,
    this.cities,
    this.districts,
    this.professions,
    this.receiptTypes,
    this.workingHour,
    this.accountSettingStatus,
    this.contracts,
    this.onboardingContracts,
    this.customerContracts,
    this.startIntegration,
    this.meetingList,
    this.appointmentReferenceCode,
    this.appointmentData,
    this.callType = 'NewCustomer',
    this.identityType = 'T.C. Kimlik Kartı',
  });

  @override
  EnquraState copyWith({
    PageState? type,
    PBlocError? error,
    bool? sdkIsActive,
    bool? otpIsRequired,
    String? sessionNo,
    String? guid,
    String? phoneNumber,
    EnquraCreateUserModel? user,
    EnquraAccountSettingStatusModel? accountSettingStatus,
    List<ItemListModel>? countries,
    List<ItemListModel>? cities,
    List<ItemListModel>? districts,
    List<ItemListModel>? professions,
    List<ItemListModel>? receiptTypes,
    List<WorkingHourModel>? workingHour,
    List<ContractListModel>? contracts,
    List<OnboardingContractsListModel>? onboardingContracts,
    List<GetCustomerContractModel>? customerContracts,
    StartIntegrationModel? startIntegration,
    List<MeetingListModel>? meetingList,
    String? appointmentReferenceCode,
    bool cleanAppointmentData = false,
    AppointmentData? appointmentData,
  }) {
    return EnquraState(
      type: type ?? this.type,
      error: error ?? this.error,
      sdkIsActive: sdkIsActive ?? this.sdkIsActive,
      otpIsRequired: otpIsRequired ?? this.otpIsRequired,
      sessionNo: sessionNo ?? this.sessionNo,
      guid: guid ?? this.guid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      user: user ?? this.user,
      accountSettingStatus: accountSettingStatus ?? this.accountSettingStatus,
      countries: countries ?? this.countries,
      cities: cities ?? this.cities,
      districts: districts ?? this.districts,
      professions: professions ?? this.professions,
      receiptTypes: receiptTypes ?? this.receiptTypes,
      workingHour: workingHour ?? this.workingHour,
      contracts: contracts ?? this.contracts,
      onboardingContracts: onboardingContracts ?? this.onboardingContracts,
      startIntegration: startIntegration ?? this.startIntegration,
      customerContracts: customerContracts ?? this.customerContracts,
      meetingList: meetingList ?? this.meetingList,
      appointmentReferenceCode: cleanAppointmentData ? null : appointmentReferenceCode ?? this.appointmentReferenceCode,
      appointmentData: cleanAppointmentData ? null : appointmentData ?? this.appointmentData,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        sdkIsActive,
        otpIsRequired,
        sessionNo,
        guid,
        phoneNumber,
        user,
        accountSettingStatus,
        countries,
        cities,
        districts,
        professions,
        receiptTypes,
        workingHour,
        contracts,
        onboardingContracts,
        customerContracts,
        startIntegration,
        meetingList,
        appointmentReferenceCode,
        appointmentData,
      ];
}
