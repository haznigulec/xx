class ItemListModel {
  final String key;
  final dynamic value;

  ItemListModel({
    required this.key,
    required this.value,
  });

  factory ItemListModel.fromJson(Map<String, dynamic> json) {
    return ItemListModel(
      key: json['key'] ?? '',
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }
}
