class BankModel {
  String? recipientName;
  List<BankInfoModel>? bankInfos;

  BankModel({
    this.recipientName,
    this.bankInfos,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
        recipientName: json['recipientName'],
        bankInfos: List<BankInfoModel>.from(
          json['bankInfos'].map(
            (x) => BankInfoModel.fromJson(x),
          ),
        ).toList());
  }
}

class BankInfoModel {
  int? id;
  String? title;
  String? symbolIcon;
  String? scheme;
  String? iban;
  String? usdIban;
  String? iosAppId;
  String? androidAppId;
  String? webUrl;

  BankInfoModel({
    this.id,
    this.title,
    this.iban,
    this.usdIban,
    this.scheme,
    this.iosAppId,
    this.androidAppId,
    this.symbolIcon,
    this.webUrl,
  });

  factory BankInfoModel.fromJson(Map<String, dynamic> json) {
    return BankInfoModel(
      id: json['id'],
      title: json['title'],
      iban: json['iban'],
      usdIban: json['usdIban'],
      scheme: json['scheme'],
      iosAppId: json['iosAppId'],
      androidAppId: json['androidAppId'],
      symbolIcon: json['symbolIcon'],
      webUrl: json['webUrl'],
    );
  }
}
