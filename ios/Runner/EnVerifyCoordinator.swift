//
//  EnVerifyCoordinator.swift
//  Runner
//
//  Created by Hazni Güleç on 1.09.2025.
//

import Foundation
import UIKit
import Flutter
import EnQualify

final class EnVerifyCoordinator: NSObject, EnVerifyDelegate, FlutterStreamHandler {
    private var name: String = ""
    private var surname: String = ""
    private var callType: String = ""
    private var TCID: String = ""
    private var phone: String = ""
    private var identityType: String = ""
    private var email: String = ""

    private var hostConnectedCompletion: (() -> Void)?
    private var idFrontStartCompletion: FlutterResult?
    private var nfcStartCompletion: FlutterResult?
    private var faceDetectStartCompletion: FlutterResult?
    private var sessionCompletion: FlutterResult?
    private var integrationCompletion: FlutterResult?
    private var isAgentFlow: Bool = false
    private var isVideoCall: Bool = false
    private var referenceId: String = ""
    var sdkVC: UIViewController?
    var videoCallVC: UIViewController?

    static let shared = EnVerifyCoordinator()
    private override init() {}

    private var navigationController: UINavigationController?

    // === Video call state for Flutter callback logic ===
    private var videoCallCompletion: FlutterResult?                   // Flutter'a tek seferlik dönüş callback'i
    private var videoCallResult: [String: Any]? = nil                 // resultGetCompleted'dan gelen payload
    private var resultArrived: Bool = false                          // resultGetCompleted geldi mi?
    private var callInProgress: Bool = false                         // çağrı zaten açık mı?
    private var callClosed: Bool = false                             // çağrı kapanmış mı? (çift dönüş engellemek için)
    var eventChannel: FlutterEventChannel?
    var eventSink: FlutterEventSink?

    func setNavigationController(_ nav: UINavigationController) {
        self.navigationController = nav
        EnVerify.setNavigationController(navigator: nav)
    }
    
    func setupChannel(with controller: FlutterViewController) {
        eventChannel = FlutterEventChannel(
            name: "PIAPIRI_EVENT_CHANNEL",
            binaryMessenger: controller.binaryMessenger
        )
        
        eventChannel?.setStreamHandler(self)
    }
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    func notifyFlutter(event: String, data: [String: Any]? = nil) {
        var payload: [String: Any] = ["event": event]
        if let data = data {
            payload["data"] = data
        }
        eventSink?(payload)
    }
    
    //================================================
    //MARK: ----------- SDK Initialize
    //================================================

    func initialize(args: [String: Any], result: @escaping FlutterResult) {
        guard
            let config = args["config"] as? [String: Any],
            let referenceId = args["referenceId"] as? String

        else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing args", details: nil))
            return
        }
        self.referenceId = referenceId // <--- Burada property'ye ata
        let apiServerUser = config["apiServerUser"] as? String ?? ""
        let apiServer = config["apiServer"] as? String ?? ""

        print("ℹ️ getAuthTokenBeforeSDK başlıyor...")
        EnVerify.setSSLPinning(required: true)
        EnVerify.setSSLPiningForIO(required: true)

        // 1️⃣ Önce token al
        EnVerify.getAuthTokenBeforeSDK(apiServerUser, apiServer) { token in

            // 2️⃣ Şimdi getSettingsBeforeSDK çağır
            EnVerify.getSettingsBeforeSDK { settingsResult in
                switch settingsResult {
                case .success(let data):
                    print("✅ getSettingsBeforeSDK success: \(String(describing: data))")
                    print("✅ referenceID: \(String(describing: referenceId))")
                    // 3️⃣ idvSettings çağır
                    let isSettingsApplied = EnVerify.idvSettings(
                        domainName: data?.domainName ?? "",
                        certificateNames: ["enqura"],
                        aiUsername: data?.aIUsername ?? "",
                        aiPassword: data?.aIPassword ?? "",
                        signalingServer: data?.signalServer ?? "",
                        stunServer: data?.stunServer ?? "",
                        turnServer: data?.turnServer ?? "",
                        turnUsername: data?.turnServerUser ?? "",
                        turnPassword: data?.turnServerKey ?? "",
                        backOfficeBasePath: apiServer,
                        userNameForToken: apiServerUser,
                        referenceID: referenceId
                    )
                    
                    print("ℹ️ idvSettings applied? \(isSettingsApplied)")
                    //EnVerify.setSpeaker(soundOn: false)
                    //EnVerify.setShowLogs(value: true)

                    // Delegate atama
                    EnVerify.assignEnVerifyDelegate(self)
                    result(true)
                    self.notifyFlutter(event: "initialize")
                case .failure(let error):
                    print("❌ getSettingsBeforeSDK error: \(error)")
                    result(FlutterError(code: "SETTINGS_ERROR", message: error.localizedDescription, details: nil))
                }
            }

        }
    }
    //================================================
    //MARK: ----------- SET USER
    //================================================

    func setUserInfo(args: [String: Any], result: @escaping FlutterResult) {
        guard
            let callType = args["purpose"] as? String,
            let id = args["tckn"] as? String,
            let identityType = args["identityType"] as? String,
            let phone = args["phone"] as? String,
            let email = args["email"] as? String
        else {
            result(FlutterError(code: "INVALID_ARGS", message: "Eksik parametreler", details: nil))
            return
        }

        print("ℹ️ setUserInfo applied \(args)")

        self.callType = callType
        self.TCID = id
        self.identityType = identityType
        self.phone = phone
        self.email = email
        EnVerify.sessionAddPhone = phone
        EnVerify.sessionAddEmail = email
        EnVerify.callType = callType
        EnVerify.identityNo = id
        EnVerify.identityType = identityType
        EnVerify.referenceId = self.referenceId
        self.notifyFlutter(event: "setUserInfo")

        result(true)
    }
    //================================================
    //MARK: ----------- ID VERIFY
    //================================================

    func startIDVerification(result: @escaping FlutterResult) {
        guard navigationController != nil else {
            result(FlutterError(code: "NO_NAV", message: "NavigationController missing", details: nil))
            return
        }

        //guard ekle
        _ = EnVerify.idVerifyStart(self)
        print("🚀 ID Verification başlatılıyor, hostConnected beklenecek...")
        hostConnectedCompletion = {
            print("✅ hostConnected tetiklendi, devam ediliyor")
            result(true)
        }
    }
    func idVerifyReady() {
        print("ℹ️ idVerifyReady")
    }

    func idSelfVerifyReady() {
        print("ℹ️ idSelfVerifyReady")
    }
    func idVerifyExited() {}
    
    func getAuthTokenFailure() {
        print("❌ getAuthTokenFailure ")
    }
    func getAuthTokenCompleted() {
        print("✅ getAuthTokenCompleted → AuthToken alındı.")
    }

    func getSettingsCompleted() {
        self.hostConnectedCompletion?()
        self.hostConnectedCompletion = nil

    }
    func getSettingsFailure() {}

    func hostConnected() {
        print("🔌 hostConnected() → bağlantı kuruldu")
        // Gerekirse token al
        EnVerify.getSettings()
    }

    //================================================
    //MARK: ----------- SELF SERVICE
    //================================================
    func selfService(result: @escaping FlutterResult) {
        print("ℹ️ idVerifyReady → selfServiceStart")
        _ = EnVerify.selfServiceStart(self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let nav = self.navigationController {
                let allVCs = nav.viewControllers.map { String(describing: type(of: $0)) }
                print("📌 Navigation stack: \(allVCs)")

                self.sdkVC = nav.viewControllers.last(where: {
                    let name = String(describing: type(of: $0))
                    return name.contains("SS") || name.contains("Verify")
                })

                print("📌 sdkVC set: \(String(describing: type(of: self.sdkVC)))")
            }
        }
        sessionCompletion = result
    }
    
    
    func sessionStartFailure() {
        print("❌ sessionStartFailure → Oturum başlatılamadı")
        sessionCompletion?(false)
        sessionCompletion = nil
    }

    func sessionStartCompleted(sessionUid: String) {
        print("✅ sessionStartCompleted → Oturum başarıyla başlatıldı, sessionUid: \(sessionUid)")
        sessionCompletion?(true)
        sessionCompletion = nil
    }
    //================================================
    //MARK: ----------- INTEGRATION ADD
    //================================================
    func integrationAdd(args: [String: Any], result: @escaping FlutterResult) {

        print("ℹ️ integrationAdd (raw args) → \(args)")

        // ---- inputs
        guard let dict = args as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGS", message: "Args is not dictionary", details: nil))
            return
        }

        guard
            let reference = dict["referance"] as? String,
            let dataJson = dict["data"] as? String
        else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing keys", details: nil))
            return
        }

        // JSON string → Dictionary parse
        func parseJSON(_ json: String) -> [String: Any]? {
            guard let data = json.data(using: .utf8) else { return nil }
            return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        }

        guard
            let dataDict = parseJSON(dataJson)
        else {
            result(FlutterError(code: "INVALID_JSON", message: "Failed to decode JSON strings", details: nil))
            return
        }        // ---- map idRegistration
        let dataJSON = jsonString(dataDict)
        
        // ---- request body
        
        EnVerify.integrationAdd(type: "Session", callType: self.callType, phone: EnVerify.sessionAddPhone, email: EnVerify.sessionAddEmail, data: dataJSON, addressRegistration: nil, iDRegistration: nil)
        
        integrationCompletion = result
    }
    
    func integrationAddCompleted() {
        print("✅ integrationAddCompleted → SDK verileri başarılı şekilde server’a aktardı.")
            integrationCompletion?(true)
            integrationCompletion = nil
    }
    func integrationAddFailure() {
        print("❌ integrationAddFailure → SDK verileri server’a gönderirken hata aldı.")
            integrationCompletion?(false)
            integrationCompletion = nil
    }

    //================================================
    //MARK: ----------- OCR
    //================================================

    func idFrontStart(result: @escaping FlutterResult) {
        print("📷 Front OCR başlıyor")
        _ = EnVerify.idTypeCheckFrontStart()
        idFrontStartCompletion = result
    }

    func idTypeCheck() {print("📷 IdTypeCheck")}

    func idTypeCheckCompleted() {
        print("📷 IdTypeCheckCompleted")
        _ = EnVerify.idFakeCheckStart()
    }

    func idFakeCheck() {print("📷 idFakeCheck")}

    func idFakeCheckCompleted() {
        print("📷 idFakeCheckCompleted")
        _ = EnVerify.idFrontStart()
    }

    func idFront() {print("📷 idFront")}

    func idFrontCompleted() {
        print("📷 idFrontCompleted")
        self.notifyFlutter(event: "idFrontCompleted")
        _ = EnVerify.idBackStart()
    }

    func idBack() {print("📷 idBack")}

    func idBackCompleted() {
        print("📷 idBackCompleted")
        self.notifyFlutter(event: "idBackCompleted")
        _ = EnVerify.idDocStore()
    }
    
    func idDocStoreCompleted() {
        print("📄 idDocStoreCompleted → Kimlik verileri hazır")
        if self.isAgentFlow {
            // Agent yönlendirmeli senaryo: ekran kapanmasın
            _ = EnVerify.onConfirmDocWithoutPop()
            self.isAgentFlow = false
        } else {
            // Normal self-service: Flutter’a dön
            _ = EnVerify.onConfirmDocWithoutPop()
            navigationController?.popViewController(animated: true) // flutter ekranına dön

        }
    }
    
    func idDocCompleted() {
        print("📄 idDocCompleted")

        let doc = EnVerifyCustomerIdentityDoc.shared

        let docNo = doc.getDocumentNo()
        let birthday = doc.getBirthday()
        let expiryDate = doc.getExpiryDate()
        let name = doc.getName()
        let surname = doc.getSurname()

        print("✅ docNo (MRZ seri): \(docNo)")
        print("✅ birthday (MRZ format yyMMdd): \(birthday)")
        print("✅ expiryDate (MRZ format yyMMdd): \(expiryDate)")
        print("✅ name : \(name)")
        print("✅ surname : \(surname)")

        EnVSession.setUserName(name)
        EnVSession.setUserSurname(surname)
        EnVSession.setUserId(self.TCID)

        // Flutter'a gönder
        idFrontStartCompletion?(true)
        idFrontStartCompletion = nil
    }
    
    func idDocStoreFailure() {
        print("📄 idDocStoreFailure → Kimlik verileri işlenemedi. Tekrar Deneniyor")
        idFrontStartCompletion?(false)
        idFrontStartCompletion = nil
    }
    
    func idCheckFailure() {
        idFrontStartCompletion?(false)
        idFrontStartCompletion = nil
    }

    func addGenericIdDocCompleted(with data: [String : String]) {
        print("📄 Kimlik OCR Completed: \(data)")
    }

    func idFakeDetected() {}
    func idTypeBackCheck() {}
    func cardFrontDetectStarted() {}
    func cardFrontDetected() {}
    func cardBackDetectStarted() {}
    func cardBackDetected() {}
    func cardHoloDetectStarted() {}
    func cardHoloDetected() {}

    //================================================
    //MARK: ----------- NFC
    //================================================

    func nfcStart(result: @escaping FlutterResult) {
        print("📷 NFC başlıyor")
        _ = EnVerify.nfcStart()
        nfcStartCompletion = result
    }

    func nfcVerify() {
        print("💳 📱 📡 nfcVerify")
    }
    
    func nfcVerifyCompleted() {
        print("💳 📱 📡 nfcVerifyCompleted")
        _ = EnVerify.nfcStore()
    }
    
    func nfcStoreCompleted() {
        print("💳 📱 📡 nfcStoreCompleted")
        nfcStartCompletion?(true)
        nfcStartCompletion = nil

        if self.isAgentFlow {
            // Agent yönlendirmeli senaryo: ekran kapanmasın
            _ = EnVerify.onConfirmNFCWithoutPop()
            self.isAgentFlow = false
        } else {
            // Normal self-service: Flutter’a dön
            _ = EnVerify.onConfirmNFCWithoutPop()
        }
    }

    func nfcCompleted() {print("💳 📱 📡 nfcCompleted")}
    
    func nfcFailure() {
        print("🔌 nfcFailure")
        nfcStartCompletion?(false)
        nfcStartCompletion = nil
    }
    
    func nfcBACDATAFailure() {
        print("🔌 nfcBACDATAFailure")
        nfcStartCompletion?(false)
        nfcStartCompletion = nil
    }

    //================================================
    //MARK: ----------- FACE
    //================================================

    func faceDetectStart(result: @escaping FlutterResult) {
        print("📷 Face Detect başlıyor")

        if let sdkVC = self.sdkVC, let nav = self.navigationController {
            // SDK ekranını tekrar en üste getir
            self.notifyFlutter(event: "faceDetectStart")
            EnVerify.faceViewStart(vc: sdkVC)
            EnVerify.faceDetectStart()
        } else {
            print("⚠️ sdkVC veya navigationController bulunamadı")
        }
        faceDetectStartCompletion = result
    }

    func faceDetect() {print("🙂 👤 🤳 👀 faceDetect")}
    
    func faceDetectCompleted() {
        print("🙂 👤 🤳 👀 faceDetectCompleted")
        _ = EnVerify.smileDetectStart()
    }
    
    func smileDetect() {print("🙂 👤 🤳 👀 smileDetect")}
    
    func smileDetectCompleted() {
        print("🙂 👤 🤳 👀 smileDetectCompleted")
        _ = EnVerify.eyeCloseStart()
    }
    
    func faceRight() {}
    func faceRightDetected() {}
    func faceLeft() {}
    func faceLeftDetected() {}
    func faceUp() {}
    func faceUpDetected() {}

    func eyeClose() {print("🙂 👤 🤳 👀 eyeClose")}
    
    func eyeCloseDetected() {
        print("🙂 👤 🤳 👀 eyeCloseDetected")
        _ = EnVerify.faceCompleteStart()
    }
    
    func faceStoreCompleted() {
        print("🙂 👤 🤳 👀 faceStoreCompleted")
        if self.isAgentFlow {
            // Agent yönlendirmeli senaryo: ekran kapanmasın
            _ = EnVerify.onConfirmFaceWithOutPop()
            self.isAgentFlow = false
        } else {
            // Normal self-service: Flutter’a dön
            _ = EnVerify.onConfirmFace()
        }
    }
    
    func faceCompleted() {
        print("🙂 👤 🤳 👀 faceCompleted")

        faceDetectStartCompletion?(true)
        faceDetectStartCompletion = nil
    }
    
    func eyeCloseInterval() {}
    func eyeCloseIntervalDetected() {}
    func eyeOpenInterval() {}
    func eyeOpenIntervalDetected() {}
    func addFaceCompleted() {}
    func addFaceFailure() {}

    //================================================
    //MARK: ----------- VIDEO CALL
    //================================================

    func startVideoCall(result: @escaping FlutterResult) {
        guard navigationController != nil else {
            result(FlutterError(code: "NO_NAV", message: "NavigationController missing", details: nil))
            return
        }

        if callInProgress {
            result(FlutterError(code: "CALL_ALREADY_ACTIVE", message: "Zaten aktif bir çağrı var", details: nil))
            return
        }

        self.isVideoCall = true
        self.callInProgress = true
        self.callClosed = false
        self.resultArrived = false
        self.videoCallResult = nil
        self.videoCallCompletion = result

        // Önce izin durumunu kontrol et
        let hasPermission = EnVerify.checkPermissions()
        print("🎤📷 Permission durumu: \(hasPermission)")
        EnVerify.setSpeaker(soundOn: false)
        if hasPermission {
            // ✅ İzin zaten var → direkt devam
            EnVerify.stopSSStartVC(self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let nav = self.navigationController {
                    let allVCs = nav.viewControllers.map { String(describing: type(of: $0)) }
                    print("📌 Navigation stack: \(allVCs)")

                    self.videoCallVC = nav.viewControllers.last(where: {
                        let name = String(describing: type(of: $0))
                        return name.contains("MainVCView")   // 👈 burayı ekle
                    })

                    if let vc = self.videoCallVC {
                        print("📌 videoCallVC yakalandı ama gösterilmedi: \(vc)")
                        nav.popToRootViewController(animated: false)

                    } else {
                        print("⚠️ videoCallVC bulunamadı")
                    }
                }
            }
        } else {
            // ❌ İzin yok → kullanıcıdan iste
            EnVerify.requestVideoAudioPermissions()
        }
    }

    func startAppointmentCall(result: @escaping FlutterResult) {
        guard navigationController != nil else {
            result(FlutterError(code: "NO_NAV", message: "NavigationController missing", details: nil))
            return
        }

        if callInProgress {
            result(FlutterError(code: "CALL_ALREADY_ACTIVE", message: "Zaten aktif bir çağrı var", details: nil))
            return
        }

        self.isVideoCall = true
        EnVerify.isContinue = true
        self.callInProgress = true
        self.callClosed = false
        self.resultArrived = false
        self.videoCallResult = nil
        self.videoCallCompletion = result

        // Önce izin durumunu kontrol et
        let hasPermission = EnVerify.checkPermissions()
        print("🎤📷 Permission durumu: \(hasPermission)")

        if hasPermission {
            // ✅ İzin zaten var → direkt devam
            EnVerify.videoCallStart(self)

        } else {
            // ❌ İzin yok → kullanıcıdan iste
            EnVerify.requestVideoAudioPermissions()
        }
    }

    func luminosityAnalyzed(result: String) {}
    func agentRequest(eventData: String) {
        let evt = eventData.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        print("📩 agentRequest → \(evt)")

        DispatchQueue.main.async {
            switch evt {
            case "backtovideocall":
                print("📩 agentRequest → \(evt)")

                //self.isAgentFlow = true

                // Halihazırda bir çağrı yanıtlandıysa call UI'ını geri getir,
                // değilse agent başlatmalı çağrıyı tetikle.
                //if EnVerify.isCallAnswered {
                //    print("📞 backtovideocall → mevcut çağrı var, videoCallRestart()")
                //    EnVerify.videoCallRestart()
                //} else {
                //    print("📞 backtovideocall → çağrı yok, startVideoAgentCall()")
                //    EnVerify.startVideoAgentCall()
                //}

            case "livenesscontrolretried":
                self.isAgentFlow = true
                print("🙂 livenesscontrolretried → onRetryFace()")
                EnVerify.faceDetectStart()

            case "ocrretried":
                self.isAgentFlow = true
                print("📷 ocrretried → onRetryDoc()")
                EnVerify.setOCRMode(value: 0)
                EnVerify.idFrontStart()

            case "nfcretried":
                self.isAgentFlow = true
                print("💳 nfcretried → onRetryNFC()")
                EnVerify.nfcStart()

            default:
                print("ℹ️ Bilinmeyen agentRequest event: \(evt)")
            }
        }
    }


    func callWait() {
        self.notifyFlutter(event: "callWait")
        print("🙂 👤 🤳 👀 callWait")
    }
    func callStart() {
        print("🙂 👤 🤳 👀 callStart")
        EnVerify.setSpeaker(soundOn: true)
        if let vc = self.videoCallVC {
            navigationController?.pushViewController(vc, animated: true)
            self.notifyFlutter(event: "callStart")
            EnVerify.startVideoChat()
            
        } else {
            print("⚠️ videoCallVC yok, prepareVideoCall yapmamışsın")
        }
    }
    func roomIDSendFailure() {
        print("🙂 👤 🤳 👀 roomIDSendFailure")
    }
    func roomIDSendCompleted() {
        print("🙂 👤 🤳 👀 roomIDSendCompleted")

    }

    func hangupLocal() {
        print("🙂 👤 🤳 👀 hangupLocal")
        failCall(reason: "hangupLocal → kullanıcı kapattı")
        EnVerify.onHangupCall()
        EnVerify.onExitCall()
    }
    func hangupRemote() {
        print("🙂 👤 🤳 👀 hangupRemote")
    }
    func failure() {
        print(" failure")
        failCall(reason: "failure")
    }
    func tokenError() {}
    func noConnectionError() {
        print("🔌 noConnectionError")
        failCall(reason: "noConnectionError → internet yok")
    }
    func timeoutFailure() {
        print("⏱ timeoutFailure")
        failCall(reason: "timeoutFailure")
        EnVerify.onHangupCall()
        EnVerify.onExitCall()
    }
    func tokenFailure() {}
    func connectionFailure() {
        print("🔌 connectionFailure")
        failCall(reason: "connectionFailure → bağlantı başarısız")
    }
    func faceLivenessCheckFailure() {}
    func resolutionChanged() {}
    func callConnectionFailure() {
        print("🔌 callConnectionFailure")
        failCall(reason: "callConnectionFailure → bağlantı hatası")
        EnVerify.onHangupCall()
        EnVerify.onExitCall()
    }

    // ✅ Görüşme sonucu başarıyla geldiğinde
    @objc func resultGetCompleted(_ value: EnQualify.EnverifyVerifyCallResult?) {
        guard let result = value else {
            print("⚠️ resultGetCompleted ama value nil geldi")
            return
        }

        print("📞 resultGetCompleted → Görüşme sonucu alındı")
        print("   🗓 dateTime   : \(result.dateTime?.description ?? "nil")")
        print("   👤 userRole   : \(result.userRole ?? "nil")")
        print("   📊 result     : \(result.result ?? "nil")")
        print("   🔗 reference  : \(result.reference ?? "nil")")
        print("   📝 desc       : \(result._description ?? "nil")")
        print("   🆔 userUId    : \(result.userUId?.uuidString ?? "nil")")

        // Eğer Flutter’a göndereceksen dictionary oluştur:
        let data: [String: Any] = [
            "dateTime": result.dateTime?.description ?? "",
            "userRole": result.userRole ?? "",
            "result": result.result ?? "",
            "reference": result.reference ?? "",
            "description": result._description ?? "",
            "userUId": result.userUId?.uuidString ?? ""
        ]

        // **ÖNEMLİ**: sadece saklıyoruz, Flutter dönüşünü sadece kapanış olayında yapacağız.
        self.resultArrived = true
        self.videoCallResult = data

        if resultArrived, let data = videoCallResult {
            succeedCall(data: data)
        } else {
            failCall(reason: "hangupRemote → resultGetCompleted gelmeden kapandı")
        }
        EnVerify.onHangupCall()
        EnVerify.onExitCall()
    }

    // ❌ Görüşme sonucu alınamadığında
    @objc func resultGetFailure() {
        print("❌ resultGetFailure → Görüşme sonucu alınamadı")
        // Burada da Flutter’a error gönderebiliriz (çağrı başarısız)
        self.resultArrived = false
        self.videoCallResult = nil
        failCall(reason: "resultGetFailure → Görüşme sonucu alınamadı")
    }
    func forceHangup() {
        print("🔌 forceHangup")

        EnVerify.onHangupCall()
        EnVerify.onExitCall()
        failCall(reason: "forceHangup")
    }
    func maximumCallTimeExpired() {
        print("⏱ maximumCallTimeExpired")
        failCall(reason: "maximumCallTimeExpired")
        EnVerify.onHangupCall()
        EnVerify.onExitCall()
    }

    func idTextRecognitionTimeout() {}

    func callSessionCloseResult(status: EnQualify.EnVerifyCallSessionStatusTypeEnum) {}

    func dismissBeforeAnswered() {
        print("🔌 dismissBeforeAnswered")
    }
    func dismissCallWait() {
        print("🔌 dismissCallWait")
    }

    func screenRecorderOnStart() {
        print("🔌 screenRecorderOnStart")

    }
    func screenRecorderOnComplete() {
        print("🔌 screenRecorderOnComplete")

    }
    //================================================
    //MARK: ----------- APPOINTEMENT
    //================================================
    func getAvailableAppointments(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard
            let args = call.arguments as? [String: Any],
            let callType = args["callType"] as? String,
            let startDate = args["startDate"] as? String,
            let endDate = args["endDate"] as? String
        else {
            result(FlutterError(code: "INVALID_ARGS", message: "Eksik parametreler", details: nil))
            return
        }

        EnVerify.getAvailableAppointment(startDate: startDate, endDate: endDate, callType: callType) { data, error in
            if let error = error {
                result(FlutterError(code: "API_ERROR", message: error.localizedDescription, details: nil))
                return
            }

            guard let list = data else {
                result(FlutterError(code: "NO_DATA", message: "Boş data geldi", details: nil))
                return
            }

            // Flutter modeline uygun JSON üret
            let mapped: [[String: Any]] = list.map { item in
                let date = item.date ?? Date()

                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

                return [
                    "Count": 1, // SDK'da yok ama Flutter model bekliyor → 1 sabit gönderebilirsin
                    "Date": [
                        "dateTime": [
                            "date": [
                                "day": components.day ?? 0,
                                "month": components.month ?? 0,
                                "year": components.year ?? 0
                            ],
                            "time": [
                                "hour": components.hour ?? 0,
                                "minute": components.minute ?? 0,
                                "second": components.second ?? 0,
                                "nano": 0
                            ]
                        ],
                        "offset": [
                            "totalSeconds": TimeZone.current.secondsFromGMT()
                        ]
                    ],
                    "StartTime": item.startTime ?? "",
                    "EndTime": item.endTime ?? ""
                ]
            }

            let response: [String: Any] = [
                "Data": mapped,
                "IsSuccessful": true,
                "ReferenceId": UUID().uuidString
            ]

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let jsonString = String(data: jsonData, encoding: .utf8)
                result(jsonString)
            } catch {
                result(FlutterError(code: "ENCODE_ERROR", message: "JSON encode hata", details: error.localizedDescription))
            }
        }
    }

    func saveAppointment(args: [String: Any], result: @escaping FlutterResult) {
        // 1) Tarihi formatla
        let appointmentDateStr: String
        if let dateStr = args["appointmentDate"] as? String {
            let isoFormatter = ISO8601DateFormatter()
            if let dateObj = isoFormatter.date(from: dateStr) {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                appointmentDateStr = formatter.string(from: dateObj)
            } else {
                appointmentDateStr = dateStr // fallback
            }
        } else {
            result(FlutterError(code: "SAVE_ERR", message: "invalide date", details: nil))
            return
        }

        // 2) IdentityType mapping
        var identityTypeReadable = "Kimlik Kartı"
        if let rawType = EnQualify.EnVerifyCustomerIdentityDoc.shared.getIdentityType() as String? {
            if rawType == "I" { identityTypeReadable = "T.C. Kimlik Kartı" }
            else if rawType == "P" { identityTypeReadable = "Pasaport" }
            else if rawType == "D" { identityTypeReadable = "Sürücü Belgesi" }
        }

        // 3) UUID handling
        let uuid: UUID
        if let uuidStr = args["uuid"] as? String, let parsed = UUID(uuidString: uuidStr) {
            uuid = parsed
        } else {
            uuid = UUID()
        }

        // 4) Model oluştur
        let model = EnQualify.EnverifyVerifyAppointmentSaveMobileModel(
            uId: uuid,
            callType: args["callType"] as? String ?? "NewCustomer",
            date: appointmentDateStr,
            startTime: args["startTime"] as? String ?? "00:00:00",
            identityType: identityTypeReadable,
            identityNo: EnQualify.EnVerifyCustomerIdentityDoc.shared.getIdentityNo(),
            name: EnQualify.EnVerifyCustomerIdentityDoc.shared.getName(),
            surname: EnQualify.EnVerifyCustomerIdentityDoc.shared.getSurname(),
            phone: self.phone,
            email: self.email
        )

        EnVerify.saveAppointment(data: model) { resp, err in
            if let err = err {
                print("❌ saveAppointment error: \(err.localizedDescription)")
                result(FlutterError(code: "SAVE_ERR", message: err.localizedDescription, details: nil))
                return
            }

            guard let resp = resp else {
                result(FlutterError(code: "SAVE_ERR", message: "response nil", details: nil))
                return
            }

            let dict: [String: Any] = [
                "IsSuccessful": resp.isSuccessful,
                "ReferenceId": resp.referenceId?.uuidString ?? "",
                "Result": [
                    "Code": resp.result?.code ?? "",
                    "Title": resp.result?.title ?? "",
                    "Message": resp.result?.message ?? ""
                ]
            ]

            if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []),
               let jsonStr = String(data: jsonData, encoding: .utf8) {
                result(jsonStr)
            } else {
                result(FlutterError(code: "ENCODE_ERR", message: "JSON encode error", details: nil))
            }
        }
        EnVerify.onExitSelfService()

    }

    func getAppointment(args: [String: Any], result: @escaping FlutterResult) {
        print("📅 getAppointment çağrıldı")

        guard
            let identityNo = args["identityNo"] as? String,
            let identityType = args["identityType"] as? String
        else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing identity params", details: nil))
            return
        }

        EnVerify.getAppointment(identityNo: identityNo, identityType: identityType) { (response: [EnverifyVerifyAppointmentResult]?, error: Error?) in
            if let err = error {
                result(FlutterError(code: "APPOINTMENT_ERR", message: err.localizedDescription, details: nil))
                return
            }

            guard let res = response else {
                result(nil)
                return
            }

            let arr = res.map { item -> [String: Any] in
                var dict: [String: Any] = [:]

                dict["UId"] = item.uId?.uuidString ?? ""
                dict["CallType"] = item.callType ?? ""
                dict["CallTypeValue"] = item.callTypeValue ?? ""
                dict["IdentityType"] = item.identityType ?? ""
                dict["IdentityNo"] = item.identityNo ?? ""
                dict["Name"] = item.name ?? ""
                dict["Surname"] = item.surname ?? ""
                dict["Phone"] = item.phone ?? ""
                dict["Email"] = item.email ?? ""
                dict["IsPriorityCustomer"] = item.isPriorityCustomer?.boolValue ?? false

                if let startDate = item.startDate {
                    dict["StartDate"] = self.dateToAppointmentDate(startDate)
                }
                if let endDate = item.endDate {
                    dict["EndDate"] = self.dateToAppointmentDate(endDate)
                }

                return dict
            }

            let dict: [String: Any] = [
                "Data": arr,
                "IsSuccessful": true,
                "ReferenceId": UUID().uuidString
            ]

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
                let jsonString = String(data: jsonData, encoding: .utf8)
                result(jsonString)
            } catch {
                result(FlutterError(code: "JSON_ERR", message: error.localizedDescription, details: nil))
            }
        }
    }


    func cancelAppointment(args: [String: Any], result: @escaping FlutterResult) {
        print("📅 cancelAppointment çağrıldı")

        guard
            let identityNo = args["identityNo"] as? String
        else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing identity params", details: nil))
            return
        }

        EnVerify.cancelAppointment(identityType: self.identityType,
                                   identityNo: identityNo,
                                   callType: self.callType) { data, error in
            if let error = error {
                print("❌ Cancel appointment failed: \(error.localizedDescription)")
                result(false)
            } else {
                print("✅ Cancel appointment success")
                result(true)
            }
        }
    }
    //================================================
    //MARK: ----------- OTHERS
    //================================================

    func idRetry() {}
    func nfcRetry() {}
    func faceRetry() {}
    func screenRecorderOnError(eventData: NSError?) {}
    func screenRecorderOnAppend() {}
    func addChipStoreFailure() {}
    func addChipStoreCompleted() {}
    func requestVideoAudioPermissionsResult(_ granted: Bool) {}
    func videoUploadSuccess() {}
    func videoUploadFailure() {}
    func currentThermalState(state: String) {}
    func appointmentTolerance(time: Int) {}
    func agentMessageRequest(message: String) {}
    func addGenericIdDocFailure() {}
    func capturePhotoCompleted() {}
    func capturePhotoFailure() {}
    func captureVideoCompleted() {}
    func captureVideoFailure() {}
    func photoLibraryAuthorization(status: String) {}
    func addGenericPassportCompleted() {}
    func addGenericPassportFailure() {}

    func destroy(result: @escaping FlutterResult) {
        EnVerify.onExitSelfService()
    }



    func resumeSelfService() {
        // SDK'nın viewController'ını bul
        if let sdkVC = navigationController?.viewControllers.first(where: {
            let name = String(describing: type(of: $0))
            return name.contains("EnVerify") || name.contains("Enqura")
        }) {
            navigationController?.popToViewController(sdkVC, animated: true)
        } else {
            // Eğer stack'te yoksa fallback: yeniden başlat
            _ = EnVerify.selfServiceStartWithoutSession(self)
        }
    }
    func str(_ v: Any?) -> String? {
        if let s = v as? String, !s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return s }
        if let i = v as? Int { return String(i) }
        if let b = v as? Bool { return b ? "true" : "false" }
        return nil
    }
    func intVal(_ v: Any?) -> Int? {
        if let i = v as? Int { return i }
        if let s = v as? String {
            let t = s.trimmingCharacters(in: .whitespacesAndNewlines)
            return Int(t)
        }
        return nil
    }
    func jsonString(_ dict: [String: Any]) -> String {
        if let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
           let json = String(data: data, encoding: .utf8) {
            return json
        }
        return "{}"
    }

    private var isoFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }

    func dateToAppointmentDate(_ date: Date) -> [String: Any] {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let simpleDate: [String: Any] = [
            "day": comps.day ?? 0,
            "month": comps.month ?? 0,
            "year": comps.year ?? 0
        ]
        
        let simpleTime: [String: Any] = [
            "hour": comps.hour ?? 0,
            "minute": comps.minute ?? 0,
            "second": comps.second ?? 0,
            "nano": 0
        ]
        
        let dateTime: [String: Any] = [
            "date": simpleDate,
            "time": simpleTime
        ]
        
        let offsetSeconds = TimeZone.current.secondsFromGMT(for: date)
        let offset: [String: Any] = [
            "totalSeconds": offsetSeconds
        ]
        
        return [
            "dateTime": dateTime,
            "offset": offset
        ]
    }

    // === Call finalize helpers ===
    private func succeedCall(data: [String: Any]) {
        guard !callClosed else { return }
        callClosed = true
        print("✅ CALL_SUCCESS → Flutter'a data gönderiliyor: \(data)")
        videoCallCompletion?(data)
        cleanupCall()
    }

    private func failCall(reason: String) {
        guard !callClosed else { return }
        callClosed = true
        print("❌ CALL_FAILED → \(reason)")
        videoCallCompletion?(
            FlutterError(code: "CALL_FAILED", message: reason, details: nil)
        )
        cleanupCall()
    }

    private func cleanupCall() {
        videoCallCompletion = nil
        videoCallResult = nil
        resultArrived = false
        callInProgress = false
        callClosed = false
        isVideoCall = false
    }
}
