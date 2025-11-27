import 'package:piapiri_v2/app/enqura/model/configuration_model.dart';

enum Environment { enverifyAI, aitest, unlucoAI }

ConfigurationModel getConfiguration(Environment env) {
  switch (env) {
    case Environment.enverifyAI:
      return const ConfigurationModel(
        title: 'Enqura',
        apiServerUser: 'mobile',
        domainName: 'enverifyai-pp.enqura.com',
        aiCertificateName: ['enqualify_io_20_03_25'],
        backOfficeCertificateName: ['enqualify_io_chain'],
        aiUsername: 'demo',
        aiPassword: 'idverify',
        signalServer: 'enverifyai-pp.enqura.com:1794',
        stunServer: 'stun:enverifyai-pp.enqura.com:3478',
        turnServer: 'turn:enverifyai-pp.enqura.com:3478',
        turnServerUser: 'smartuser',
        turnServerKey: 'Sv2017_1697turn',
        apiServer: 'https://enqualifymapi-test.enqura.com',
        msPrivateKey: '12345678901234567890',
        isMediaServerEnabled: false,
      );
    case Environment.aitest:
      return const ConfigurationModel(
        title: 'Enqura',
        apiServerUser: 'mobile',
        domainName: 'aitest.enqualify.io',
        aiCertificateName: ['enqualify_io_20_03_25'],
        backOfficeCertificateName: ['enqualify_io_chain'],
        aiUsername: 'demo',
        aiPassword: 'idverify',
        signalServer: 'pstest.enqualify.io',
        stunServer: 'stun:vdtest.enqualify.io:3478',
        turnServer: 'turn:vdtest.enqualify.io:3478',
        turnServerUser: 'turnuser',
        turnServerKey: 'Sv2017_1697turn',
        apiServer: 'https://unlucomapiptest.enqualify.io',
        msPrivateKey: '12345678901234567890',
        isMediaServerEnabled: false,
      );
    case Environment.unlucoAI:
      return const ConfigurationModel(
        title: 'Enqura',
        apiServerUser: 'mobile',
        domainName: 'unlucoai.enqualify.io',
        aiCertificateName: ['enqualify_io_20_03_25'],
        backOfficeCertificateName: ['enqualify_io_chain'],
        aiUsername: 'demo',
        aiPassword: 'idverify',
        signalServer: 'unlucops.enqualify.io',
        stunServer: 'stun:unlucovd.enqualify.io:3478',
        turnServer: 'turn:unlucovd.enqualify.io:3478',
        turnServerUser: 'turnuser',
        turnServerKey: 'Sv2017_1697turn',
        apiServer: 'https://unlucomapip.enqualify.io',
        msPrivateKey: '12345678901234567890',
        isMediaServerEnabled: false,
      );
  }
}
