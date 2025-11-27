import UIKit
import Flutter
import EnQualify
import Firebase
import FirebaseMessaging
import UserNotifications
import InsiderMobile

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
    var navigationController: UINavigationController!
    var notificationTapChannel: FlutterMethodChannel?
    private var initialNotificationUserInfo: [AnyHashable: Any]?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // App push notification ile launch olduysa
        if let remote = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            initialNotificationUserInfo = remote
        }

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        GeneratedPluginRegistrant.register(with: self)

        guard let flutterController = window?.rootViewController as? FlutterViewController else {
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }

        EnVerifyCoordinator.shared.setupChannel(with: flutterController)

        navigationController = UINavigationController(rootViewController: flutterController)
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        // ANA METHOD CHANNEL
        let channel = FlutterMethodChannel(
            name: "PIAPIRI_CHANNEL",
            binaryMessenger: flutterController.binaryMessenger
        )

        channel.setMethodCallHandler { call, result in
            switch call.method {
            case "initialize":
                if let args = call.arguments as? [String: Any] {
                    EnVerifyCoordinator.shared.setNavigationController(self.navigationController)
                    EnVerifyCoordinator.shared.initialize(args: args, result: result)
                }
            case "startIDVerification":
                EnVerifyCoordinator.shared.startIDVerification(result: result)
            case "startSelfService":
                EnVerifyCoordinator.shared.selfService(result: result)
            case "postIntegrationAddRequest":
                if let args = call.arguments as? [String: Any] {
                    EnVerifyCoordinator.shared.integrationAdd(args: args, result: result)
                }
            case "setUserInfo":
                if let args = call.arguments as? [String: Any] {
                    EnVerifyCoordinator.shared.setUserInfo(args: args, result: result)
                }
            case "startIDTypeCheckFront":
                EnVerifyCoordinator.shared.idFrontStart(result: result)
            case "startNFC":
                EnVerifyCoordinator.shared.nfcStart(result: result)
            case "startFaceDetect":
                EnVerifyCoordinator.shared.faceDetectStart(result: result)
            case "startVideoCall":
                EnVerifyCoordinator.shared.startVideoCall(result: result)
            case "startAppointmentCall":
                EnVerifyCoordinator.shared.startAppointmentCall(result: result)
            case "getAvailableAppointments":
                EnVerifyCoordinator.shared.getAvailableAppointments(call: call, result: result)
            case "saveAppointment":
                if let args = call.arguments as? [String: Any] {
                    EnVerifyCoordinator.shared.saveAppointment(args: args, result: result)
                }
            case "getAppointments":
                if let args = call.arguments as? [String: Any] {
                    EnVerifyCoordinator.shared.getAppointment(args: args, result: result)
                }
            case "cancelAppointment":
                if let args = call.arguments as? [String: Any] {
                    EnVerifyCoordinator.shared.cancelAppointment(args: args, result: result)
                }
            case "destroy":
                EnVerifyCoordinator.shared.destroy(result: result)
            case "marketRedirect":
                var iTunesLink: String? = "itms-apps://itunes.apple.com/xy/app/foo/id1605946348"
                if let iTunesLink = iTunesLink, let url = URL(string: iTunesLink) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                result(true)

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        notificationTapChannel = FlutterMethodChannel(
            name: "NOTIFICATION_TAP_CHANNEL",
            binaryMessenger: flutterController.binaryMessenger
        )

        notificationTapChannel?.setMethodCallHandler { call, result in
            switch call.method {
            case "getInitialNotification":
                if let initial = self.initialNotificationUserInfo {
                    result(initial)
                    self.initialNotificationUserInfo = nil
                } else {
                    result(nil)
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - APNs Token → FCM + Insider

    override func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // FCM için APNs token
        Messaging.messaging().apnsToken = deviceToken
        print("APNs token set for FCM")

        // Insider token kaydı
        Insider.registerDeviceToken(with: application, deviceToken: deviceToken)
        print("Insider device token registered")

        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    override func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register for remote notifications: \(error)")
        super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM registration token: \(fcmToken ?? "nil")")
    }

    // MARK: - Push callbacks 

    override func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        let state = application.applicationState
        if let source = userInfo["source"] as? String, source == "Insider" {
            Insider.handlePushLog(userInfo: userInfo)
            completionHandler(.noData)
            return
        }
        super.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }

    // Foreground (uygulama açıkken)
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        print("willPresent notification: \(userInfo)")

        super.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
    }

    // Background / app açık veya arkadayken tap
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        print("didReceive response: \(userInfo)")

        // Tüm provider'lardan gelen (Firebase + Insider vs.) tap event'ini Flutter'a fırlat
        notificationTapChannel?.invokeMethod("onNotificationTap", arguments: userInfo)

        // Aynı zamanda Firebase / diğer plugin zincirleri de çalışsın diye super çağır
        super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
    }
}
