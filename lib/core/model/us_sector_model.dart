class UsSectorModel {
  int sectorId;
  bool status;
  int orderNo;
  String cdnUrl;
  String sectorName;
  List<String> symbolList;

  UsSectorModel({
    required this.sectorId,
    required this.status,
    required this.orderNo,
    required this.cdnUrl,
    required this.sectorName,
    required this.symbolList,
  });

  factory UsSectorModel.fromJson(Map<String, dynamic> json) {
    return UsSectorModel(
      sectorId: json['sectorId'] as int,
      status: json['status'] == 1,
      orderNo: json['orderNo'] as int,
      cdnUrl: json['cdnUrl'] as String,
      sectorName: json['sectorName'] as String,
      symbolList: List<String>.from(json['symbolNames']),
    );
  }
}
