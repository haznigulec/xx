class CustomerTargetModel {
  int? id;
  String? customerExtId;
  String? targetDate;
  double? target;
  String? createdDate;

  CustomerTargetModel({
    this.id,
    this.customerExtId,
    this.targetDate,
    this.target,
    this.createdDate,
  });

  factory CustomerTargetModel.fromJson(Map<String, dynamic> json) {
    return CustomerTargetModel(
      id: json['id'],
      customerExtId: json['customerExtId'],
      targetDate: json['targetDate'],
      target: double.parse((json['target'] ?? 0).toString()),
      createdDate: json['createdDate'],
    );
  }
}
