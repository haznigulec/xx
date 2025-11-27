class OnboardingAccountInfoModel {
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String birthDate;
  final String customerType;
  final String identityNumber;
  final String countryOfCitizenship;
  final String countryOfTaxResidence;
  final String address;
  final String city;
  final String country;
  final String phoneNumber;
  final String alpacaCustomerAgreement;

  OnboardingAccountInfoModel({
    String? firstName,
    String? middleName,
    String? lastName,
    String? email,
    String? birthDate,
    String? customerType,
    String? identityNumber,
    String? countryOfCitizenship,
    String? countryOfTaxResidence,
    String? address,
    String? city,
    String? country,
    String? phoneNumber,
    String? alpacaCustomerAgreement,
  })  : firstName = firstName ?? '-',
        middleName = middleName ?? '-',
        lastName = lastName ?? '-',
        email = email ?? '-',
        birthDate = birthDate ?? '-',
        customerType = customerType ?? '-',
        identityNumber = identityNumber ?? '-',
        countryOfCitizenship = countryOfCitizenship ?? '-',
        countryOfTaxResidence = countryOfTaxResidence ?? '-',
        address = address ?? '-',
        city = city ?? '-',
        country = country ?? '-',
        phoneNumber = phoneNumber ?? '-',
        alpacaCustomerAgreement = alpacaCustomerAgreement ?? '';

  // JSON'dan nesne oluşturma
  factory OnboardingAccountInfoModel.fromJson(Map<String, dynamic> json) {
    return OnboardingAccountInfoModel(
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      email: json['email'],
      birthDate: json['birthDate'] != null ? json['birthDate'].toString().split(' ').first : '-',
      customerType: json['customerType'],
      identityNumber: json['identityNumber'],
      countryOfCitizenship: json['countryOfCitizenship'],
      countryOfTaxResidence: json['countryOfTaxResidence'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      phoneNumber: json['phoneNumber'],
      alpacaCustomerAgreement: json['alpacaCustomerAgreement'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'birthDate': birthDate,
      'customerType': customerType,
      'identityNumber': identityNumber,
      'countryOfCitizenship': countryOfCitizenship,
      'countryOfTaxResidence': countryOfTaxResidence,
      'address': address,
      'city': city,
      'country': country,
      'phoneNumber': phoneNumber,
      'alpacaCustomerAgreement': alpacaCustomerAgreement,
    };
  }
}
