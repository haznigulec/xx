import 'package:piapiri_v2/app/enqura/utils/flow_name_enum.dart';

class SessionInfo {
  static final SessionInfo _instance = SessionInfo._internal();

  factory SessionInfo() {
    return _instance;
  }

  SessionInfo._internal();

  String? connectionType;
  bool nfCIsOpen = false;
  bool idTypeCheckStart = false;
  bool idTypeCheckFinish = false;
  bool hologramStart = false;
  bool hologramFinish = false;
  bool idDocFrontStart = false;
  bool idDocFrontFinish = false;
  bool idDocBackStart = false;
  bool idDocBackFinish = false;
  bool idChipStart = false;
  bool idChipFinish = false;
  bool faceStart = false;
  bool faceFinish = false;
  bool smileStart = false;
  bool smileFinish = false;
  bool eyeCloseIntervalStart = false;
  bool eyeCloseIntervalFinish = false;
  bool eyeCloseFinish = false;
  bool eyeCloseStart = false;
  bool faceRightStart = false;
  bool faceRightFinish = false;
  bool faceLeftStart = false;
  bool faceLeftFinish = false;
  bool faceUpStart = false;
  bool faceUpFinish = false;
  bool roomSendMobile = false;
  bool callRequest = false;
  bool waitCall = false;
  bool startCall = false;
  int? battery;
  String flowName = '';

  void clearInfoData() {
    connectionType = null;
    nfCIsOpen = false;
    idTypeCheckStart = false;
    idTypeCheckFinish = false;
    hologramStart = false;
    hologramFinish = false;
    idDocFrontStart = false;
    idDocFrontFinish = false;
    idDocBackStart = false;
    idDocBackFinish = false;
    idChipStart = false;
    idChipFinish = false;
    faceStart = false;
    faceFinish = false;
    smileStart = false;
    smileFinish = false;
    eyeCloseIntervalStart = false;
    eyeCloseIntervalFinish = false;
    eyeCloseFinish = false;
    eyeCloseStart = false;
    faceRightStart = false;
    faceRightFinish = false;
    faceLeftStart = false;
    faceLeftFinish = false;
    faceUpStart = false;
    faceUpFinish = false;
    roomSendMobile = false;
    callRequest = false;
    waitCall = false;
    startCall = false;
    battery = null;
    flowName = '';
  }

  void _addFlowName(String currentFlow) {
    if (flowName.isEmpty || !flowName.contains(currentFlow)) {
      flowName = flowName.isEmpty ? currentFlow : '$flowName+$currentFlow';
    }
  }

  set setIdTypeCheckStart(bool value) {
    idTypeCheckStart = value;
    if (value) _addFlowName(FlowNameEnum.iDTypeCheck.flowName);
  }

  set setHologramStart(bool value) {
    hologramStart = value;
    if (value) _addFlowName(FlowNameEnum.hologram.flowName);
  }

  set setIdDocFrontStart(bool value) {
    idDocFrontStart = value;
    if (value) _addFlowName(FlowNameEnum.iDDocFront.flowName);
  }

  set setIdDocBackStart(bool value) {
    idDocBackStart = value;
    if (value) _addFlowName(FlowNameEnum.iDDocBack.flowName);
  }

  set setIdChipStart(bool value) {
    idChipStart = value;
    if (value) _addFlowName(FlowNameEnum.iDChip.flowName);
  }

  set setFaceStart(bool value) {
    faceStart = value;
    if (value) _addFlowName(FlowNameEnum.face.flowName);
  }

  set setSmileStart(bool value) {
    smileStart = value;
    if (value) _addFlowName(FlowNameEnum.smile.flowName);
  }

  set setEyeCloseIntervalStart(bool value) {
    eyeCloseIntervalStart = value;
    if (value) _addFlowName(FlowNameEnum.eyeCloseInterval.flowName);
  }

  set setEyeCloseStart(bool value) {
    eyeCloseStart = value;
    if (value) _addFlowName(FlowNameEnum.eyeClose.flowName);
  }

  set setFaceRightFinish(bool value) {
    faceRightFinish = value;
    if (value) _addFlowName(FlowNameEnum.randomLiveness.flowName);
  }

  set setFaceLeftStart(bool value) {
    faceLeftStart = value;
    if (value) _addFlowName(FlowNameEnum.randomLiveness.flowName);
  }

  set setFaceUpStart(bool value) {
    faceUpStart = value;
    if (value) _addFlowName(FlowNameEnum.randomLiveness.flowName);
  }

  set setStartCall(bool value) {
    startCall = value;
    if (value) _addFlowName(FlowNameEnum.call.flowName);
  }
}
