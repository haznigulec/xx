enum OrderCompletionEnum {
  close('close', 'closed'),
  notification('push_notification', 'push_notification'),
  sms('sms', 'sms'),
  mail('mail', 'email');

  const OrderCompletionEnum(
    this.value,
    this.localizationKey,
  );
  final String value;
  final String localizationKey;
}
