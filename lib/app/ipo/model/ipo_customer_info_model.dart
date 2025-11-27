class IpoCustomerInfoModel {
  String? token;
  List<CustomerInfo>? customerInfo;

  IpoCustomerInfoModel({this.token, this.customerInfo});

  factory IpoCustomerInfoModel.fromJson(Map<String, dynamic> json) {
    return IpoCustomerInfoModel(
      token: json['token'],
      customerInfo: json['customerInfo']
          .map<CustomerInfo>(
            (dynamic element) => CustomerInfo.fromJson(element),
          )
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (customerInfo != null) {
      data['customerInfo'] = customerInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerInfo {
  String? fullName;
  String? phoneNumber;
  String? email;
  String? address;
  String? created;

  CustomerInfo({
    this.fullName,
    this.phoneNumber,
    this.email,
    this.address,
    this.created,
  });

  CustomerInfo.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    address = json['address'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['address'] = address;
    data['created'] = created;
    return data;
  }
}
