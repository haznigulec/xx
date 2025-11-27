import 'package:piapiri_v2/core/model/settings_model.dart';

class DashboardTemplate {
  int? id;
  String? header;
  String? description;
  List<SettingsModel>? settings;
  bool? isSelected;
  String? icon;
  int? order;

  DashboardTemplate({
    this.id,
    this.header,
    this.description,
    this.settings,
    this.isSelected,
    this.icon,
    this.order,
  });

  factory DashboardTemplate.fromJson(Map<String, dynamic> json) => DashboardTemplate(
        id: json['id'] ?? 0,
        header: json['header'] ?? '',
        description: json['description'] ?? '',
        settings: json['settings'] != null
            ? List<SettingsModel>.from(json['settings'].map((x) => SettingsModel.fromJson(x)))
            : null,
        isSelected: json['isSelected'] ?? false,
        icon: json['icon'] ?? '',
        order: json['order'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'header': header,
        'description': description,
        'settings': settings != null ? List<dynamic>.from(settings!.map((x) => x.toJson())) : null,
        'isSelected': isSelected,
        'icon': icon,
        'order': order,
      };
}

class DashboardTemplateSetting {
  int? id;
  String? key;
  String? value;
  String? title;
  String? icon;
  int? order;

  DashboardTemplateSetting({
    this.id,
    this.key,
    this.value,
    this.title,
    this.icon,
    this.order,
  });

  factory DashboardTemplateSetting.fromJson(Map<String, dynamic> json) => DashboardTemplateSetting(
        id: json['id'] ?? 0,
        key: json['key'] ?? '',
        value: json['value'] ?? '',
        title: json['title'] ?? '',
        icon: json['icon'] ?? '',
        order: json['order'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'value': value,
        'title': title,
        'icon': icon,
        'order': order,
      };
}
