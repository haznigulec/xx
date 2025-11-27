abstract class Analytics {
  Future<void> initialize();

  Future<void> track(
    String event, {
    Map<String, dynamic> properties,
    List<String> taxonomy,
  });

  Future<void> screen(
    String screenName, {
    Map<String, dynamic> properties,
  });

  Future<void> setFirebaseUserProperties({
    required String customerId,
    required String deviceId,
  });

  Future<void> setFirebaseUserProperty(String name, String? value);
}
