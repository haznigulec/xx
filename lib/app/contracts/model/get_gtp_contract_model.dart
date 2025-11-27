class GetGtpContractModel {
  String? contractTypeId;
  String? name;
  String? description;
  String? status;
  String? enumCode;
  int? versionNo;
  String? cmContractCode;
  String? cmContractRefCode;
  bool? canSignContract;
  bool? gtpContractExists;
  DateTime? gtpContractCreatedDate;
  DateTime? cmContractApprovedDate;

  GetGtpContractModel({
    this.contractTypeId,
    this.name,
    this.description,
    this.status,
    this.enumCode,
    this.versionNo,
    this.cmContractCode,
    this.cmContractRefCode,
    this.canSignContract,
    this.gtpContractExists,
    this.gtpContractCreatedDate,
    this.cmContractApprovedDate,
  });

  factory GetGtpContractModel.fromJson(Map<String, dynamic> json) => GetGtpContractModel(
        contractTypeId: json['contractTypeId'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        status: json['status'] ?? '',
        enumCode: json['enumCode'] ?? '',
        versionNo: json['versionNo'] ?? 0,
        cmContractCode: json['cmContractCode'] ?? '',
        cmContractRefCode: json['cmContractRefCode'] ?? '',
        canSignContract: json['canSignContract'] ?? false,
        gtpContractExists: json['gtpContractExists'] ?? false,
        gtpContractCreatedDate:
            json['gtpContractCreatedDate'] != null ? DateTime.parse(json['gtpContractCreatedDate']) : null,
        cmContractApprovedDate:
            json['cmContractApprovedDate'] != null ? DateTime.parse(json['cmContractApprovedDate']) : null,
      );

  Map<String, dynamic> toJson() => {
        'contractTypeId': contractTypeId,
        'name': name,
        'description': description,
        'status': status,
        'enumCode': enumCode,
        'versionNo': versionNo,
        'cmContractCode': cmContractCode,
        'cmContractRefCode': cmContractRefCode,
        'canSignContract': canSignContract,
        'gtpContractExists': gtpContractExists,
        'gtpContractCreatedDate': gtpContractCreatedDate?.toIso8601String(),
        'cmContractApprovedDate': cmContractApprovedDate?.toIso8601String()
      };
}
