class VirementInstitutionModel {
  final int institutionId;
  final String institutionName;
  final String institutionEmail;

  VirementInstitutionModel(
    this.institutionId,
    this.institutionName,
    this.institutionEmail,
  );

  factory VirementInstitutionModel.fromJson(Map<String, dynamic> json) {
    return VirementInstitutionModel(
      json['institutionId'] as int,
      json['institutionName'] as String,
      json['institutionEmail'] as String,
    );
  }
}
