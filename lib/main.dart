import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_insider/flutter_insider.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/firebase_options_prod.dart';
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

/// This is the main entry point for the app.
///
/// It initializes the app, sets up the app config and initializes the Firebase
/// messaging background handler.
///
/// The app config is set up with the following values:
///
/// - [flavor]: The flavor of the app. This is used to determine which version of
///   the app to use.
/// - [name]: The name of the app. This is used to determine which version of the
///   app to use.
/// - [contractUrl]: The URL of the contract. This is used to display the contract
///   in the app.
/// - [baseUrl]: The base URL of the API. This is used to make API calls.
/// - [matriksUrl]: The URL of the Matriks API. This is used to make API calls.
/// - [cdnKey]: The key for the CDN. This is used to access the CDN.
/// - [certificate]: The certificate for the app. This is used to verify the
///   identity of the app.
///
/// The Firebase messaging background handler is set up to handle background
/// notifications. When a notification is received, the handler is called with the
/// notification data. The handler then uses the data to display the notification.
void main() async {
  // return runApp(const BzWidgetbook());

  AppConfig(
    flavor: Flavor.prod,
    name: 'prod',
    contractUrl: 'https://kyc.unluco.com/api/Contract/GetFileByte?ContractRefCode=',
    enquraBaseUrl: 'https://kyc.unluco.com/api',
    baseUrl: 'https://piapiri.unluco.com/api',
    usCapraUrl: 'https://piapiricapra.unluco.com',
    polygonUrl: 'https://api.polygon.io',
    polygonWssUrl: 'ws://piapiripoli.unluco.com:7050/stocks',
    matriksUrl: 'https://api.matriksdata.com',
    cdnKey: '62f73103-d83f-430c-a3df4ca34aad-3f05-4565',
    memberKvkk:
        'https://piapiri-std.b-cdn.net/KVKK%20Form/%C3%9Cnl%C3%BCCo%20-%20Piapiri%20Uygulama%20Ayd%C4%B1nlatma%20Metni(452390804.1).pdf',
  );

  await initApp(DefaultFirebaseOptions.currentPlatform, _firebaseMessagingBackgroundHandler);
}
