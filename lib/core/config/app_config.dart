enum Flavor { dev, qa, prod }

class AppConfig {
  static late AppConfig instance;
  final Flavor _flavor;
  final String _name;
  final String _contractUrl;
  final String _baseUrl;
  final String _usCapraUrl;
  final String _polygonUrl;
  final String _polygonWssUrl;
  final String _matriksUrl;
  final String _cdnKey;
  final String _memberKvkk;
  final String _enquraBaseUrl;

  factory AppConfig({
    required Flavor flavor,
    required String name,
    required String contractUrl,
    required String baseUrl,
    required String usCapraUrl,
    required String polygonUrl,
    required String polygonWssUrl,
    required String matriksUrl,
    required String cdnKey,
    required String memberKvkk,
    required String enquraBaseUrl,
  }) {
    instance = AppConfig._internal(
      flavor,
      name,
      contractUrl,
      baseUrl,
      usCapraUrl,
      polygonUrl,
      polygonWssUrl,
      matriksUrl,
      cdnKey,
      memberKvkk,
      enquraBaseUrl,
    );
    return instance;
  }

  AppConfig._internal(
    this._flavor,
    this._name,
    this._contractUrl,
    this._baseUrl,
    this._usCapraUrl,
    this._polygonUrl,
    this._polygonWssUrl,
    this._matriksUrl,
    this._cdnKey,
    this._memberKvkk,
    this._enquraBaseUrl,
  );

  bool get isProd => _flavor == Flavor.prod;

  bool get isQa => _flavor == Flavor.qa;

  bool get isDev => _flavor == Flavor.dev;

  String get name => _name;

  Flavor get flavor => _flavor;

  String get contractUrl => _contractUrl;

  String get baseUrl => _baseUrl;

  String get usCapraUrl => _usCapraUrl;

  String get polygonUrl => _polygonUrl;

  String get polygonWssUrl => _polygonWssUrl;

  String get matriksUrl => _matriksUrl;

  String get cdnKey => _cdnKey;

  String get memberKvkk => _memberKvkk;

  String get enquraBaseUrl => _enquraBaseUrl;
}
