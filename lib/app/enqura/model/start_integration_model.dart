class StartIntegrationModel {
  final String name;
  final String surname;
  final String referanceCode;
  final bool manualAdresRequired;
  final bool gtpUserExists;
  final bool appointmentExists;
  final bool onboardingExists;

  StartIntegrationModel({
    required this.name,
    required this.surname,
    required this.referanceCode,
    required this.manualAdresRequired,
    required this.gtpUserExists,
    required this.appointmentExists,
    required this.onboardingExists,
  });

  factory StartIntegrationModel.fromJson(Map<String, dynamic> json) {
    return StartIntegrationModel(
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      referanceCode: json['referanceCode'] ?? '',
      manualAdresRequired: json['manualAdresRequired'] ?? false,
      gtpUserExists: json['gtpUserExists'] ?? false,
      appointmentExists: json['appointmentExists'] ?? false,
      onboardingExists: json['onboardingExists'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'referanceCode': referanceCode,
      'manualAdresRequired': manualAdresRequired,
      'gtpUserExists': gtpUserExists,
      'appointmentExists': appointmentExists,
      'onboardingExists': onboardingExists,
    };
  }

  StartIntegrationModel copyWith({
    String? name,
    String? surname,
    String? referanceCode,
    bool? manualAdresRequired,
    bool? gtpUserExists,
    bool? appointmentExists,
    bool? onboardingExists,
  }) {
    return StartIntegrationModel(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      referanceCode: referanceCode ?? this.referanceCode,
      manualAdresRequired: manualAdresRequired ?? this.manualAdresRequired,
      gtpUserExists: gtpUserExists ?? this.gtpUserExists,
      appointmentExists: appointmentExists ?? this.appointmentExists,
      onboardingExists: onboardingExists ?? this.onboardingExists,
    );
  }
}
