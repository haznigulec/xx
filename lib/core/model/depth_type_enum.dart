enum DepthTypeEnum {
  stage('stage', 'stage_total'),
  total('total', 'total_depth_2');

  const DepthTypeEnum(
    this.value,
    this.localizationKey,
  );
  final String value;
  final String localizationKey;
}
