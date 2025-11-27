class SettingsModel {
  final int id;
  final String key;
  final String title;
  final String value;
  final int order;
  final List<SettingsModel> children;

  SettingsModel({
    required this.id,
    required this.key,
    required this.title,
    required this.value,
    this.order = 0,
    this.children = const [],
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      id: json['id'] ?? 0,
      key: json['key'],
      title: json['title'],
      value: json['value'],
      order: json['order'] ?? 0,
      children:
          json['children'] != null ? (json['children'] as List).map((e) => SettingsModel.fromJson(e)).toList() : [],
    );
  }

  factory SettingsModel.decoy() {
    return SettingsModel(
      id: 0,
      key: '',
      title: '',
      value: '',
      order: 0,
      children: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'value': value,
        'title': title,
        'order': order,
      };

  Map<String, dynamic> toUpdateJson(int newOrder) => {
        'key': key,
        'value': value,
        'order': newOrder,
      };

  SettingsModel copyWith({
    int? id,
    String? key,
    String? title,
    String? value,
    int? order,
    List<SettingsModel>? children,
  }) {
    return SettingsModel(
      id: id ?? this.id,
      key: key ?? this.key,
      title: title ?? this.title,
      value: value ?? this.value,
      order: order ?? this.order,
      children: children ?? this.children,
    );
  }
}
