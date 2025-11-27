enum LicenseRequestStatusEnum {
  requested(1),
  accepted(2),
  rejected(3);

  final int value;
  const LicenseRequestStatusEnum(this.value);
}

enum LicenseRequestTypeEnum {
  licenseNew(1),
  licenseCancel(2);

  const LicenseRequestTypeEnum(this.value);
  final int value;
}
