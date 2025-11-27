enum IpoStatusEnum {
  all(0),
  future(1),
  active(2),
  past(3);

  final int value;
  const IpoStatusEnum(this.value);
}
