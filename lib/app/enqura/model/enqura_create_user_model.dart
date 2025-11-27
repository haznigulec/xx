class EnquraCreateUserModel {
  final String? identityNumber;
  final DateTime? birthDate;
  final String? email;
  final String? phoneNumber;
  final bool? kvkk;
  final bool? etk;
  final String? buddyReferenceCode;
  final String? occupation;
  final bool? hasForeignTaxLiability;
  final String? foreignTaxCountry;
  final String? foreignTaxIdentificationNo;
  final String? socialSecurityNumber;
  final String? employerIdentificationNo;
  final bool? isCompanyFounder;
  final String? companyName;
  final double? sharePercentage;
  final bool? profitSharePreference;
  final String? currentStep;
  final String? sessionNo;
  final String? guid;
  final String? otpCode;
  final bool? spis;
  final bool? fatca;
  final bool? w8;
  final bool? videoCallCompleted;
  final String? city;
  final String? district;
  final String? neighborhood;
  final String? street;
  final String? apartmentNo;
  final String? videoCallAppointmentDate;
  final String? videoCallAppointmentTime;
  final bool? agreementAcknowledgement;
  final String? agreementIpAddress;
  final String? agreementSignedAt;

  EnquraCreateUserModel({
    this.identityNumber,
    this.birthDate,
    this.email,
    this.phoneNumber,
    this.kvkk,
    this.etk,
    this.buddyReferenceCode,
    this.occupation,
    this.hasForeignTaxLiability,
    this.foreignTaxCountry,
    this.foreignTaxIdentificationNo,
    this.socialSecurityNumber,
    this.employerIdentificationNo,
    this.isCompanyFounder,
    this.companyName,
    this.sharePercentage,
    this.profitSharePreference,
    this.currentStep,
    this.sessionNo,
    this.guid,
    this.otpCode,
    this.spis,
    this.fatca,
    this.w8,
    this.videoCallCompleted,
    this.city,
    this.district,
    this.neighborhood,
    this.street,
    this.apartmentNo,
    this.videoCallAppointmentDate,
    this.videoCallAppointmentTime,
    this.agreementAcknowledgement,
    this.agreementIpAddress,
    this.agreementSignedAt,
  });

  EnquraCreateUserModel copyWith({
    String? identityNumber,
    DateTime? birthDate,
    String? email,
    String? phoneNumber,
    bool? kvkk,
    bool? etk,
    String? buddyReferenceCode,
    String? occupation,
    bool? hasForeignTaxLiability,
    String? foreignTaxCountry,
    String? foreignTaxIdentificationNo,
    String? socialSecurityNumber,
    String? employerIdentificationNo,
    bool? isCompanyFounder,
    String? companyName,
    double? sharePercentage,
    bool? profitSharePreference,
    String? currentStep,
    String? sessionNo,
    String? guid,
    String? otpCode,
    bool? spis,
    bool? fatca,
    bool? w8,
    bool? videoCallCompleted,
    String? city,
    String? district,
    String? neighborhood,
    String? street,
    String? apartmentNo,
    String? videoCallAppointmentDate,
    String? videoCallAppointmentTime,
    bool? agreementAcknowledgement,
    String? agreementIpAddress,
    String? agreementSignedAt,
  }) {
    return EnquraCreateUserModel(
      identityNumber: identityNumber ?? this.identityNumber,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      kvkk: kvkk ?? this.kvkk,
      etk: etk ?? this.etk,
      buddyReferenceCode: buddyReferenceCode ?? this.buddyReferenceCode,
      occupation: occupation ?? this.occupation,
      hasForeignTaxLiability: hasForeignTaxLiability ?? this.hasForeignTaxLiability,
      foreignTaxCountry: foreignTaxCountry ?? this.foreignTaxCountry,
      foreignTaxIdentificationNo: foreignTaxIdentificationNo ?? this.foreignTaxIdentificationNo,
      socialSecurityNumber: socialSecurityNumber ?? this.socialSecurityNumber,
      employerIdentificationNo: employerIdentificationNo ?? this.employerIdentificationNo,
      isCompanyFounder: isCompanyFounder ?? this.isCompanyFounder,
      companyName: companyName ?? this.companyName,
      sharePercentage: sharePercentage ?? this.sharePercentage,
      profitSharePreference: profitSharePreference ?? this.profitSharePreference,
      currentStep: currentStep ?? this.currentStep,
      sessionNo: sessionNo ?? this.sessionNo,
      guid: guid ?? this.guid,
      otpCode: otpCode ?? this.otpCode,
      spis: spis ?? this.spis,
      fatca: fatca ?? this.fatca,
      w8: w8 ?? this.w8,
      videoCallCompleted: videoCallCompleted ?? this.videoCallCompleted,
      city: city ?? this.city,
      district: district ?? this.district,
      neighborhood: neighborhood ?? this.neighborhood,
      street: street ?? this.street,
      apartmentNo: apartmentNo ?? this.apartmentNo,
      videoCallAppointmentDate: videoCallAppointmentDate ?? this.videoCallAppointmentDate,
      videoCallAppointmentTime: videoCallAppointmentTime ?? this.videoCallAppointmentTime,
      agreementAcknowledgement: agreementAcknowledgement ?? this.agreementAcknowledgement,
      agreementIpAddress: agreementIpAddress ?? this.agreementIpAddress,
      agreementSignedAt: agreementSignedAt ?? this.agreementSignedAt,
    );
  }

  factory EnquraCreateUserModel.fromJson(Map<String, dynamic> json) {
    return EnquraCreateUserModel(
      identityNumber: json['identityNumber'] as String?,
      birthDate: json['birthDate'] != null ? DateTime.tryParse(json['birthDate']) : null,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      kvkk: json['kvkk'] as bool?,
      etk: json['etk'] as bool?,
      buddyReferenceCode: json['buddyReferenceCode'] as String?,
      occupation: json['occupation'] as String?,
      hasForeignTaxLiability: json['hasForeignTaxLiability'] as bool?,
      foreignTaxCountry: json['foreignTaxCountry'] as String?,
      foreignTaxIdentificationNo: json['foreignTaxIdentificationNo'] as String?,
      socialSecurityNumber: json['socialSecurityNumber'] as String?,
      employerIdentificationNo: json['employerIdentificationNo'] as String?,
      isCompanyFounder: json['isCompanyFounder'] as bool?,
      companyName: json['companyName'] as String?,
      sharePercentage: (json['sharePercentage'] as num?)?.toDouble(),
      profitSharePreference: bool.tryParse(json['profitSharePreference'].toString().toLowerCase()),
      currentStep: json['currentStep'] as String?,
      sessionNo: json['sessionNo'] as String?,
      guid: json['guid'] as String?,
      otpCode: json['otpCode'] as String?,
      spis: json['spis'] as bool?,
      fatca: json['fatca'] as bool?,
      w8: json['w8'] as bool?,
      videoCallCompleted: json['videoCallCompleted'] as bool?,
      city: json['City'] as String?,
      district: json['District'] as String?,
      neighborhood: json['Neighborhood'] as String?,
      street: json['Street'] as String?,
      apartmentNo: json['ApartmentNumber'] as String?,
      videoCallAppointmentDate: json['videoCallAppointmentDate'] ?? '',
      videoCallAppointmentTime: json['videoCallAppointmentTime'] ?? '',
      agreementAcknowledgement: json['agreementAcknowledgement'],
      agreementIpAddress: json['agreementIpAddress'] ?? '',
      agreementSignedAt: json['agreementSignedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (identityNumber?.isNotEmpty ?? false) data['identityNumber'] = identityNumber;
    if (birthDate != null) data['birthDate'] = birthDate!.toIso8601String();
    if (email?.isNotEmpty ?? false) data['email'] = email;
    if (phoneNumber?.isNotEmpty ?? false) data['phoneNumber'] = phoneNumber;
    if (kvkk != null) data['kvkk'] = kvkk;
    if (etk != null) data['etk'] = etk;
    if (buddyReferenceCode?.isNotEmpty ?? false) data['buddyReferenceCode'] = buddyReferenceCode;
    if (occupation?.isNotEmpty ?? false) data['occupation'] = occupation;
    if (hasForeignTaxLiability != null) data['hasForeignTaxLiability'] = hasForeignTaxLiability;
    if (foreignTaxCountry != null) data['foreignTaxCountry'] = foreignTaxCountry;
    if (foreignTaxIdentificationNo != null) {
      data['foreignTaxIdentificationNo'] = foreignTaxIdentificationNo;
    }
    if (socialSecurityNumber != null) {
      data['socialSecurityNumber'] = socialSecurityNumber;
    }
    if (employerIdentificationNo != null) {
      data['employerIdentificationNo'] = employerIdentificationNo;
    }
    if (isCompanyFounder != null) data['isCompanyFounder'] = isCompanyFounder;
    if (companyName != null) data['companyName'] = companyName;
    if (sharePercentage != null) data['sharePercentage'] = sharePercentage;
    if (profitSharePreference != null) data['profitSharePreference'] = profitSharePreference;
    if (currentStep?.isNotEmpty ?? false) data['currentStep'] = currentStep;
    if (sessionNo?.isNotEmpty ?? false) data['sessionNo'] = sessionNo;
    if (guid?.isNotEmpty ?? false) data['guid'] = guid;
    if (otpCode?.isNotEmpty ?? false) data['otpCode'] = otpCode;
    if (spis != null) data['spis'] = spis;
    if (fatca != null) data['fatca'] = fatca;
    if (w8 != null) data['w8'] = w8;
    if (videoCallCompleted != null) data['videoCallCompleted'] = videoCallCompleted;
    if (city?.isNotEmpty ?? false) data['City'] = city;
    if (district?.isNotEmpty ?? false) data['District'] = district;
    if (neighborhood?.isNotEmpty ?? false) data['Neighborhood'] = neighborhood;
    if (street?.isNotEmpty ?? false) data['Street'] = street;
    if (apartmentNo?.isNotEmpty ?? false) data['ApartmentNumber'] = apartmentNo;
    if (videoCallAppointmentDate?.isNotEmpty ?? false) {
      data['videoCallAppointmentDate'] = videoCallAppointmentDate;
    }
    if (videoCallAppointmentTime?.isNotEmpty ?? false) {
      data['videoCallAppointmentTime'] = videoCallAppointmentTime;
    }
    if (agreementAcknowledgement != null) data['agreementAcknowledgement'] = agreementAcknowledgement;
    if (agreementIpAddress != null) data['agreementIpAddress'] = agreementIpAddress;
    if (agreementSignedAt != null) data['agreementSignedAt'] = agreementSignedAt;
    return data;
  }
}
