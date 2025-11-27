class CountriesModel {
  final String iso;
  final String tr;
  final String en;

  CountriesModel({
    required this.iso,
    required this.tr,
    required this.en,
  });

  factory CountriesModel.fromJson(Map<String, dynamic> json) {
    return CountriesModel(
      iso: json['iso'],
      tr: json['tr'],
      en: json['en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iso': iso,
      'tr': tr,
      'en': en,
    };
  }
}
