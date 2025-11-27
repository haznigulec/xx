import 'package:piapiri_v2/app/enqura/utils/enqura_page_steps.dart';

class EnquraAccountSettingStatusModel {
  int personalInformation;
  int financialInformation;
  int identityVerification;
  int onlineContracts;
  int videoCall;
  String? accountStatus;
  bool isSuitableCapra;

  EnquraAccountSettingStatusModel({
    this.personalInformation = 0,
    this.financialInformation = 0,
    this.identityVerification = 0,
    this.onlineContracts = 0,
    this.videoCall = 0,
    this.accountStatus,
    this.isSuitableCapra = false,
  });

  factory EnquraAccountSettingStatusModel.fromJson(Map<String, dynamic> json) => EnquraAccountSettingStatusModel(
        personalInformation: json['personalInformation'] ?? 0,
        financialInformation: json['financialInformation'] ?? 0,
        identityVerification: json['identityVerification'] ?? 0,
        onlineContracts: json['onlineContracts'] ?? 0,
        videoCall: json['videoCall'] ?? 0,
        accountStatus: json['accountStatus'],
        isSuitableCapra: json['isSuitableCapra'],
      );

  Map<String, dynamic> toJson() => {
        'personalInformation': personalInformation,
        'financialInformation': financialInformation,
        'identityVerification': identityVerification,
        'onlineContracts': onlineContracts,
        'videoCall': videoCall,
        'accountStatus': accountStatus,
        'isSuitableCapra': isSuitableCapra,
      };
}

EnquraAccountSettingStatusModel enquraAccountSettingStatusGenerator(String lastCompletedPage) {
  if (EnquraPageSteps.personalInformation == lastCompletedPage) {
    return EnquraAccountSettingStatusModel(
      personalInformation: 1,
    );
  } else if (EnquraPageSteps.financialInformation == lastCompletedPage) {
    return EnquraAccountSettingStatusModel(
      personalInformation: 1,
      financialInformation: 1,
    );
  } else if (EnquraPageSteps.identityVerification == lastCompletedPage) {
    return EnquraAccountSettingStatusModel(
      personalInformation: 1,
      financialInformation: 1,
      identityVerification: 1,
    );
  } else if (EnquraPageSteps.onlineContracts == lastCompletedPage) {
    return EnquraAccountSettingStatusModel(
      personalInformation: 1,
      financialInformation: 1,
      identityVerification: 1,
      onlineContracts: 1,
    );
  } else if (EnquraPageSteps.videoCalling == lastCompletedPage) {
    return EnquraAccountSettingStatusModel(
      personalInformation: 1,
      financialInformation: 1,
      identityVerification: 1,
      onlineContracts: 1,
      videoCall: 1,
    );
  } else {
    return EnquraAccountSettingStatusModel();
  }
}
