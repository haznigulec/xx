enum AgentRequestTypeEnum {
  agent,
  ocr,
  ocrResult,
  nnf,
  nfcResult,
  liveness,
  livenessResult,
  faceRecognition,
  busy,
  pending,
  none,
}

extension AgentRequestTypeExtension on AgentRequestTypeEnum {
  String get value => toString().split('.').last;

  static AgentRequestTypeEnum fromString(String str) {
    return AgentRequestTypeEnum.values.firstWhere(
      (e) => e.value.toUpperCase() == str.toUpperCase(),
      orElse: () => AgentRequestTypeEnum.none,
    );
  }
}
