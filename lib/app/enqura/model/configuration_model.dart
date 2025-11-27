class ConfigurationModel {
  final String title;
  final String apiServerUser;
  final String domainName;
  final List<String> aiCertificateName;
  final List<String> backOfficeCertificateName;
  final String aiUsername;
  final String aiPassword;
  final String signalServer;
  final String stunServer;
  final String turnServer;
  final String turnServerUser;
  final String turnServerKey;
  final String apiServer;
  final String msPrivateKey;
  final bool isMediaServerEnabled;

  const ConfigurationModel({
    required this.title,
    required this.apiServerUser,
    required this.domainName,
    required this.aiCertificateName,
    required this.backOfficeCertificateName,
    required this.aiUsername,
    required this.aiPassword,
    required this.signalServer,
    required this.stunServer,
    required this.turnServer,
    required this.turnServerUser,
    required this.turnServerKey,
    required this.apiServer,
    required this.msPrivateKey,
    required this.isMediaServerEnabled,
  });

  factory ConfigurationModel.fromJson(Map<String, dynamic> json) {
    return ConfigurationModel(
      title: json['title'],
      apiServerUser: json['apiServerUser'],
      domainName: json['domainName'],
      aiCertificateName: json['aiCertificateName'],
      backOfficeCertificateName: json['backOfficeCertificateName'],
      aiUsername: json['aiUsername'],
      aiPassword: json['aiPassword'],
      signalServer: json['signalServer'],
      stunServer: json['stunServer'],
      turnServer: json['turnServer'],
      turnServerUser: json['turnServerUser'],
      turnServerKey: json['turnServerKey'],
      apiServer: json['apiServer'],
      msPrivateKey: json['msPrivateKey'],
      isMediaServerEnabled: json['isMediaServerEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'apiServerUser': apiServerUser,
      'domainName': domainName,
      'aiCertificateName': aiCertificateName,
      'backOfficeCertificateName': backOfficeCertificateName,
      'aiUsername': aiUsername,
      'aiPassword': aiPassword,
      'signalServer': signalServer,
      'stunServer': stunServer,
      'turnServer': turnServer,
      'turnServerUser': turnServerUser,
      'turnServerKey': turnServerKey,
      'apiServer': apiServer,
      'msPrivateKey': msPrivateKey,
      'isMediaServerEnabled': isMediaServerEnabled,
    };
  }

  @override
  String toString() {
    return 'ConfigurationModel(title: $title, domainName: $domainName, apiServer: $apiServer)';
  }
}
