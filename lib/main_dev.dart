import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_insider/flutter_insider.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/firebase_options_dev.dart';
import 'package:piapiri_v2/init_app.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  if (message.data['source'] == 'Insider') {
    FlutterInsider.Instance.handleNotification(<String, dynamic>{'data': message.data});
  }
}

void main() async {
  AppConfig(
    flavor: Flavor.dev,
    name: 'dev',
    enquraBaseUrl: 'https://kycdev.unluco.com/api',
    contractUrl: 'https://kycdev.unluco.com/api/Contract/GetFileByte?ContractRefCode=',
    baseUrl: 'https://devpiapiri.unluco.com/service3',
    usCapraUrl: 'https://devpiapiricapra.unluco.com:7040',
    polygonUrl: 'https://api.polygon.io',
    polygonWssUrl: 'ws://devpiapiripoli.unluco.com:7050/stocks',
    matriksUrl: 'https://apitest.matriksdata.com',
    cdnKey: '62f73103-d83f-430c-a3df4ca34aad-3f05-4565',
    memberKvkk:
        'https://piapiri-test.b-cdn.net/KVKK%20Form/%C3%9Cnl%C3%BCCo%20-%20Piapiri%20Uygulama%20Ayd%C4%B1nlatma%20Metni(452390804.1).pdf',
  );

  await initApp(DefaultFirebaseOptions.currentPlatform, _firebaseMessagingBackgroundHandler);
}
