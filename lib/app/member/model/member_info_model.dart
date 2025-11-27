class MemberInfoModel {
  String fullName;
  String phoneNumber;
  String? email;

  MemberInfoModel({
    required this.fullName,
    required this.phoneNumber,
    this.email,
  });

  factory MemberInfoModel.fromJson(Map<String, dynamic> json) => MemberInfoModel(
        fullName: json['FullName'] ?? '',
        phoneNumber: json['PhoneNumber'] ?? '',
        email: json['Email'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'FullName': fullName,
        'PhoneNumber': phoneNumber,
        'Email': email,
      };
}
