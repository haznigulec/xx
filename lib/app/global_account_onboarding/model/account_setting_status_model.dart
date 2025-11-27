class AccountSettingStatusModel {
  int personalInformation;
  int financialInformation;
  int onlineContracts;
  String? accountStatus;
  bool? isSuitableCapra;

  AccountSettingStatusModel({
    required this.personalInformation,
    required this.financialInformation,
    required this.onlineContracts,
    required this.accountStatus,
    this.isSuitableCapra,
  });

  factory AccountSettingStatusModel.fromJson(Map<String, dynamic> json) => AccountSettingStatusModel(
        personalInformation: json['personalInformation'],
        financialInformation: json['financialInformation'],
        onlineContracts: json['onlineContracts'],
        accountStatus: json['accountStatus'],
        isSuitableCapra: json['isSuitableCapra'],
      );

  Map<String, dynamic> toJson() => {
        'personalInformation': personalInformation,
        'financialInformation': financialInformation,
        'onlineContracts': onlineContracts,
        'accountStatus': accountStatus,
        'isSuitableCapra': isSuitableCapra,
      };
}
