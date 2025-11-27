class NotificationPreferencesModel {
  final String key;
  String value;
  final String title;
  final int order;
  final List<Children> children;

  NotificationPreferencesModel({
    required this.key,
    required this.value,
    required this.title,
    required this.order,
    required this.children,
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      key: json['key'],
      value: json['value'],
      title: json['title'],
      order: json['order'],
      children: json['children']
          .map<Children>(
            (dynamic element) => Children.fromJson(element),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }
}

class Children {
  final String key;
  final String value;
  final String title;
  final int order;

  Children({
    required this.key,
    required this.value,
    required this.title,
    required this.order,
  });

  factory Children.fromJson(Map<String, dynamic> json) {
    return Children(
      key: json['key'],
      value: json['value'],
      title: json['title'],
      order: json['order'],
    );
  }
}
