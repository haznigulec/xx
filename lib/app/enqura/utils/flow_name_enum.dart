enum FlowNameEnum {
  iDTypeCheck,
  hologram,
  iDDocFront,
  iDDocBack,
  iDChip,
  face,
  smile,
  eyeCloseInterval,
  eyeClose,
  randomLiveness,
  call,
}

extension FlowNameExtension on FlowNameEnum {
  String get flowName => toString().split('.').last;
}
