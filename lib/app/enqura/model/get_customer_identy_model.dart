class GetCustomerIdentyModel {
  final String errorCode;
  final String errorMessage;
  final IdRegistration? idRegistration;
  final AddressRegistration? addressRegistration;
  final RegistrationData data;
  final bool gtpUserExists;

  GetCustomerIdentyModel({
    required this.errorCode,
    required this.errorMessage,
    this.idRegistration,
    this.addressRegistration,
    required this.data,
    required this.gtpUserExists,
  });

  factory GetCustomerIdentyModel.fromJson(Map<String, dynamic> json) {
    return GetCustomerIdentyModel(
      errorCode: json['errorCode'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
      idRegistration: json['idRegistration'] != null ? IdRegistration.fromJson(json['idRegistration']) : null,
      addressRegistration:
          json['addressRegistration'] != null ? AddressRegistration.fromJson(json['addressRegistration']) : null,
      data: RegistrationData.fromJson(json['data']),
      gtpUserExists: json['gtpUserExists'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'errorCode': errorCode,
        'errorMessage': errorMessage,
        'idRegistration': idRegistration?.toJson(),
        'addressRegistration': addressRegistration?.toJson(),
        'data': data.toJson(),
        'gtpUserExists': gtpUserExists,
      };
}

class IdRegistration {
  final String errorCode;
  final String errorMessage;
  final String fatherName;
  final String motherName;
  final String birthPlace;
  final String registrationPlace;
  final String registrationPlaceFamilyRow;
  final String registrationPlacePersonalRow;
  final String serialNo;
  final String recordNo;
  final String identityType;
  final String identityNo;
  final String documentNo;
  final String name;
  final String surname;
  final String gender;
  final String birthDate;
  final String nationality;
  final String issuedBy;
  final String issuedDate;
  final String expireDate;

  IdRegistration({
    required this.errorCode,
    required this.errorMessage,
    required this.fatherName,
    required this.motherName,
    required this.birthPlace,
    required this.registrationPlace,
    required this.registrationPlaceFamilyRow,
    required this.registrationPlacePersonalRow,
    required this.serialNo,
    required this.recordNo,
    required this.identityType,
    required this.identityNo,
    required this.documentNo,
    required this.name,
    required this.surname,
    required this.gender,
    required this.birthDate,
    required this.nationality,
    required this.issuedBy,
    required this.issuedDate,
    required this.expireDate,
  });

  factory IdRegistration.fromJson(Map<String, dynamic> json) {
    return IdRegistration(
      errorCode: json['errorCode'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
      fatherName: json['fatherName'] ?? '',
      motherName: json['motherName'] ?? '',
      birthPlace: json['birthPlace'] ?? '',
      registrationPlace: json['registrationPlace'] ?? '',
      registrationPlaceFamilyRow: json['registrationPlaceFamilyRow'] ?? '',
      registrationPlacePersonalRow: json['registrationPlacePersonalRow'] ?? '',
      serialNo: json['serialNo'] ?? '',
      recordNo: json['recordNo'] ?? '',
      identityType: json['identityType'] ?? '',
      identityNo: json['identityNo'] ?? '',
      documentNo: json['documentNo'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      gender: json['gender'] ?? '',
      birthDate: json['birthDate'] ?? '',
      nationality: json['nationality'] ?? '',
      issuedBy: json['issuedBy'] ?? '',
      issuedDate: json['issuedDate'] ?? '',
      expireDate: json['expireDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'errorCode': errorCode,
        'errorMessage': errorMessage,
        'fatherName': fatherName,
        'motherName': motherName,
        'birthPlace': birthPlace,
        'registrationPlace': registrationPlace,
        'registrationPlaceFamilyRow': registrationPlaceFamilyRow,
        'registrationPlacePersonalRow': registrationPlacePersonalRow,
        'serialNo': serialNo,
        'recordNo': recordNo,
        'identityType': identityType,
        'identityNo': identityNo,
        'documentNo': documentNo,
        'name': name,
        'surname': surname,
        'gender': gender,
        'birthDate': birthDate,
        'nationality': nationality,
        'issuedBy': issuedBy,
        'issuedDate': issuedDate,
        'expireDate': expireDate,
      };
}

class AddressRegistration {
  final String errorCode;
  final String errorMessage;
  final String addressType;
  final int addressNo;
  final String district;
  final int districtCode;
  final String street;
  final int streetCode;
  final int villageCode;
  final String addressDetail;
  final int townCode;
  final String town;
  final String city;
  final int cityCode;
  final String country;
  final int countryCode;

  AddressRegistration({
    required this.errorCode,
    required this.errorMessage,
    required this.addressType,
    required this.addressNo,
    required this.district,
    required this.districtCode,
    required this.street,
    required this.streetCode,
    required this.villageCode,
    required this.addressDetail,
    required this.townCode,
    required this.town,
    required this.city,
    required this.cityCode,
    required this.country,
    required this.countryCode,
  });

  factory AddressRegistration.fromJson(Map<String, dynamic> json) {
    return AddressRegistration(
      errorCode: json['errorCode'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
      addressType: json['addressType'] ?? '',
      addressNo: json['addressNo'] ?? 0,
      district: json['district'] ?? '',
      districtCode: json['districtCode'] ?? 0,
      street: json['street'] ?? '',
      streetCode: json['streetCode'] ?? 0,
      villageCode: json['villageCode'] ?? 0,
      addressDetail: json['addressDetail'] ?? '',
      townCode: json['townCode'] ?? 0,
      town: json['town'] ?? '',
      city: json['city'] ?? '',
      cityCode: json['cityCode'] ?? 0,
      country: json['country'] ?? '',
      countryCode: json['countryCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'errorCode': errorCode,
        'errorMessage': errorMessage,
        'addressType': addressType,
        'addressNo': addressNo,
        'district': district,
        'districtCode': districtCode,
        'street': street,
        'streetCode': streetCode,
        'villageCode': villageCode,
        'addressDetail': addressDetail,
        'townCode': townCode,
        'town': town,
        'city': city,
        'cityCode': cityCode,
        'country': country,
        'countryCode': countryCode,
      };
}

class RegistrationData {
  final bool uavtValidationApproved;
  final String uavtValidation;
  final bool worldCheckValidationExists;
  final String worldCheckValidation;

  RegistrationData({
    required this.uavtValidationApproved,
    required this.uavtValidation,
    required this.worldCheckValidationExists,
    required this.worldCheckValidation,
  });

  factory RegistrationData.fromJson(Map<String, dynamic> json) {
    return RegistrationData(
      uavtValidationApproved: json['uavtValidationApproved'] ?? false,
      uavtValidation: json['uavtValidation'] ?? '',
      worldCheckValidationExists: json['worldCheckValidationExists'] ?? false,
      worldCheckValidation: json['worldCheckValidation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'uavtValidationApproved': uavtValidationApproved,
        'uavtValidation': uavtValidation,
        'worldCheckValidationExists': worldCheckValidationExists,
        'worldCheckValidation': worldCheckValidation,
      };
}
