enum OrderStatusEnum {
  filled('completed'),
  pending('waiting'),
  canceled('deleted');

  final String value;
  const OrderStatusEnum(this.value);
}
