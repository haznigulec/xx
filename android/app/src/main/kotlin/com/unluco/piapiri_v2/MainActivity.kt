// android/app/src/main/kotlin/com/unluco/piapiri/MainActivity.kt
package com.unluco.piapiri
import android.app.Activity
import android.content.Intent
import android.media.projection.MediaProjectionManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.fragment.app.Fragment
import com.enqura.enverify.EnVerifyApi
import com.enqura.enverify.EnVerifyCallback
import com.enqura.enverify.models.User
import com.enqura.enverify.models.enums.CloseSessionStatus
import com.google.gson.Gson
import com.smartvist.idverify.models.CustomerIdentityDoc
import com.smartvist.idverify.models.IDVerifyFailureCode
import com.smartvist.idverify.models.IDVerifyState
import com.useinsider.insider.Insider
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.swagger.client.model.VerifyCallResultModel
import com.unluco.piapiri.enqualify.model.ConfigurationModel
import io.swagger.client.ApiCallback
import io.swagger.client.ApiException
import io.swagger.client.model.VerifyAppointmentAddResponse
import io.swagger.client.model.VerifyAppointmentListMobileResponse
import io.swagger.client.model.VerifyAvailableAppointmentListResponse
import io.swagger.client.model.VerifyCallTypeNameListResponse
import kotlinx.coroutines.*
import org.threeten.bp.OffsetDateTime
import java.util.Locale
import com.unluco.piapiri_v2.NFCFragment
import com.unluco.piapiri_v2.VCNFCFragment
import io.swagger.client.model.VerifyCallAddressRegistrationModel

class MainActivity : FlutterFragmentActivity(), EnVerifyCallback {

    companion object {
        //var currentEnvironment: Environment = Environment.UNLUCO_TEST        var currentEnvironment: Environment = Environment.UNLUCO_TEST

        private const val SCREEN_RECORD_REQUEST_CODE = 9001
        private var screenRecordResult: MethodChannel.Result? = null
        private const val CH_IN = "PIAPIRI_CHANNEL"       // Flutter -> Native
        private const val CH_OUT = "PIAPIRI_CALLBACK"     // Native  -> Flutter
    }

    private var flutterEngineRef: FlutterEngine? = null
    private var outChannel: MethodChannel? = null

    /** Flutter’a event gönderimi (UI thread garantili) */
    private fun emit(event: String, args: Any? = null) {
        runOnUiThread {
            val messenger = flutterEngineRef?.dartExecutor?.binaryMessenger ?: return@runOnUiThread
            if (outChannel == null) outChannel = MethodChannel(messenger, CH_OUT)
            try {
                outChannel?.invokeMethod(event, args)
            } catch (t: Throwable) {
                Log.e("MainActivity", "emit($event) failed", t)
            }
        }
    }

    /** SDK UI/Fragment dokunan çağrıları UI thread’de güvenle çalıştıran sarmalayıcı */
    private inline fun wrapUi(result: MethodChannel.Result, crossinline block: () -> Unit) {
        runOnUiThread {
            try {
                block()
                result.success(null)
            } catch (e: Exception) {
                result.error("NATIVE_CALL_FAIL", e.message, null)
            }
        }
    }
    // MainActivity içinde, wrapUi'nin yanına ekleyin:
    private inline fun wrapUiCommit(result: MethodChannel.Result, crossinline block: () -> Unit) {
        runOnUiThread {
            val self = this
            val runner = object : Runnable {
                override fun run() {
                    if (self.isFinishing || self.isDestroyed) {
                        result.error("NATIVE_CALL_FAIL", "Activity is not in a valid state", null)
                        return
                    }
                    // Eğer FragmentManager state'i kaydettiyse commit yapmayalım; kısa bir süre bekleyip tekrar deneyelim.
                    if (supportFragmentManager.isStateSaved) {
                        window?.decorView?.postDelayed(this, 50)
                        return
                    }
                    try {
                        // Olası bekleyen transaction’ları temizle
                        supportFragmentManager.executePendingTransactions()
                    } catch (_: Exception) { /* yut */ }

                    try {
                        block()
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("NATIVE_CALL_FAIL", e.message, null)
                    }
                }
            }
            runner.run()
        }
    }

    /** Dart’tan gelecek state string’ini IDVerifyState’e map’ler */
    private fun mapVerifyState(s: String?): IDVerifyState {
        return when (s?.lowercase(Locale.ROOT)) {
            "ocr", "idtext", "text", "id" -> IDVerifyState.IDDOC_VERIFIED
            "nfc"                         -> IDVerifyState.NFC_VERIFIED
            "face", "liveness"            -> IDVerifyState.FACE_VERIFIED
            else                          -> IDVerifyState.IDDOC_VERIFIED
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Insider.Instance.init(this.application, "piapiri")
        Thread.setDefaultUncaughtExceptionHandler { thread, throwable ->
            Log.e("UncaughtException", "Thread: ${thread.name}, error: ", throwable)
        }
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        flutterEngineRef = flutterEngine
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        val inChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CH_IN)
        inChannel.setMethodCallHandler { call, result ->
            when (call.method) {

               

                // ================= / SESSION =================

                "setSessionId" -> {
                    try {
                        val referenceId = call.argument<String>("referenceId") ?: ""
                        EnVerifyApi.getBackofficeCertificatesListSize()
                        EnVerifyApi.getInstance().sessionUUID = referenceId

                        result.success(null)
                    } catch (e: Exception) {
                        result.error("SET_SESSION_ID_FAIL", e.message, null)
                    }
                }

                // ================= INITIALIZE =================
                "initialize" -> {
                    try {
                        val referenceId = call.argument<String>("referenceId") ?: ""
                        val configMap = call.argument<Map<String, Any>>("config")!!

                        CoroutineScope(Dispatchers.IO).launch {
                            try {
                                val config = ConfigurationModel(
                                    title = configMap["title"] as String,
                                    apiServerUser = configMap["apiServerUser"] as String,
                                    domainName = configMap["domainName"] as String,
                                    aiCertificateName = (configMap["aiCertificateName"] as List<String>).toTypedArray(),
                                    backOfficeCertificateName = (configMap["backOfficeCertificateName"] as List<String>).toTypedArray(),
                                    aiUsername = configMap["aiUsername"] as String,
                                    aiPassword = configMap["aiPassword"] as String,
                                    signalServer = configMap["signalServer"] as String,
                                    stunServer = configMap["stunServer"] as String,
                                    turnServer = configMap["turnServer"] as String,
                                    turnServerUser = configMap["turnServerUser"] as String,
                                    turnServerKey = configMap["turnServerKey"] as String,
                                    apiServer = configMap["apiServer"] as String,
                                    msPrivateKey = configMap["msPrivateKey"] as String,
                                    isMediaServerEnabled = configMap["isMediaServerEnabled"] as Boolean
                                )

                                val enVerifyApi = EnVerifyApi.getInstance()
                                withContext(Dispatchers.Main) {
                                    enVerifyApi.reinitialize(this@MainActivity)
                                    enVerifyApi.init(
                                        this@MainActivity,
                                        android.R.id.content,
                                        supportFragmentManager,
                                        referenceId,
                                        "mobile" // token yerine SDK gereği
                                    )
                                }
                                //enVerifyApi.setSessionUUID(referenceId)
                                enVerifyApi.setBackOfficeBaseUrl(config.apiServer)
                                enVerifyApi.setSpeaker(true)
                                enVerifyApi.setCanAutoClose(false)
                                enVerifyApi.setAgentFullScreen(true)
                                enVerifyApi.replaceFragment(Fragment())
                                enVerifyApi.setDomain(
                                    config.domainName,
                                    config.turnServer,
                                    config.stunServer,
                                    config.signalServer
                                )
                                enVerifyApi.setCredentials(config.aiUsername, config.aiPassword)
                                enVerifyApi.setTurnCredentials(config.turnServerUser, config.turnServerKey)
                                enVerifyApi.setMSPrivateKey(config.msPrivateKey)
                                enVerifyApi.setIsSSLPinningRequired(true, true)
                                enVerifyApi.setCertificate(config.aiCertificateName, config.backOfficeCertificateName)

                                withContext(Dispatchers.Main) { result.success(null) }
                            } catch (e: Exception) {
                                withContext(Dispatchers.Main) {
                                    result.error("INIT_CONFIG_FAIL", e.message, null)
                                }
                            }
                        }
                    } catch (e: Exception) {
                        result.error("INIT_CONFIG_FAIL", e.message, null)
                    }
                }

                // ================= CAMERA CLOSE / CONFIRM / OPTIONS =================
                "confirmVerification" -> {
                    val state = call.argument<String>("state")
                    wrapUi(result) {
                        try {
                            EnVerifyApi.getInstance().confirmVerification(mapVerifyState(state))
                            result.success("confirmVerification() successfully")
                        } catch (e: Exception) {
                            result.error("confirmVerification() failed", e.message, null)
                        }
                    }
                }

                "setOcrCameraCloseScreenEnabled" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: true
                    wrapUi(result) { EnVerifyApi.getInstance().setOcrCameraCloseScreenEnabled(enabled) }
                }

                "setCameraCloseNFC" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: true
                    wrapUi(result) { EnVerifyApi.getInstance().setCameraCloseNFC(enabled) }
                }

                "replaceFragment" -> {
                    try {
                        EnVerifyApi.getInstance().replaceFragment(Fragment())
                        result.success("Replace_Fragment successfully")
                    } catch (e: Exception) {
                        result.error("Replace_Fragment_ERROR", e.message, null)
                    }
                }

                // ================= USER INFO =================
                "setUserInfo" -> {
                    try {
                        val context = applicationContext
                        val purpose = call.argument<String>("purpose") ?: "None"
                        val isHandicapped = call.argument<Boolean>("isHandicapped") ?: false
                        val tckn = call.argument<String>("tckn") ?: ""
                        val phone = call.argument<String>("phone") ?: ""
                        val identityType = call.argument<String>("identityType") ?: ""
                        val email = call.argument<String>("email") ?: ""

                        val user = User.getInstance()
                        user.init(context)
                        user.setCallType(purpose)
                        user.setHandicapped(isHandicapped)
                        user.setIdentityNo(tckn)
                        user.setPhone(phone)
                        user.setIdentityType(identityType)
                        user.setEmail(email)

                        result.success("User info set successfully")
                    } catch (e: Exception) {
                        result.error("USER_INFO_ERROR", e.message, null)
                    }
                }

                // ================= OCR / CARD =================
                "startIDTypeCheckFront"   -> wrapUi(result) {
                    EnVerifyApi.getInstance().startIDTypeCheckFront()
                }
                "startIDTypeCheckBack"    -> wrapUi(result) { EnVerifyApi.getInstance().startIDTypeCheckBack()  }
                "fakeCheck"               -> wrapUi(result) { EnVerifyApi.getInstance().fakeCheck()             }
                "startIDDoc"              -> wrapUi(result) { EnVerifyApi.getInstance().startIDDoc()           }
                "startMRZ"                -> wrapUi(result) { EnVerifyApi.getInstance().startMRZ()             }
                "startCardFrontDetect"    -> wrapUi(result) { EnVerifyApi.getInstance().startCardFrontDetect() }
                "startCardHoloDetect"     -> wrapUi(result) { EnVerifyApi.getInstance().startCardHoloDetect()  }
                "startIDFrontAfterDetect" -> wrapUi(result) { EnVerifyApi.getInstance().startIDFrontAfterDetect() }
                "startIDBackAfterDetect"  -> wrapUi(result) { EnVerifyApi.getInstance().startIDBackAfterDetect()  }
                "startCardBackDetect"     -> wrapUi(result) { EnVerifyApi.getInstance().startCardBackDetect()  }

                // ================= NFC =================

                "isDeviceHasNfc" -> {
                    val activityContext = this@MainActivity
                    val nfcAdapter = android.nfc.NfcAdapter.getDefaultAdapter(activityContext)
                    if (nfcAdapter != null) {
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }

                "isNfcEnabled" -> {
                    val activityContext = this@MainActivity
                    val nfcAdapter = android.nfc.NfcAdapter.getDefaultAdapter(activityContext)
                    if (nfcAdapter != null) {
                        result.success(nfcAdapter.isEnabled)
                    } else {
                        result.success(false)
                    }
                }

                "startNFC" -> wrapUiCommit(result) {
                    val nfc = com.enqura.enverify.models.NfcBACData.getInstance()
                    val nfcFragment = NFCFragment()
                    nfcFragment.setOutChannel(outChannel)
                    supportFragmentManager.beginTransaction()
                        .replace(android.R.id.content, nfcFragment)
                        .commitAllowingStateLoss()

                    val hasValue = nfc.checkIfDataStoredBefore()
                    if (!hasValue) {
                        emit(
                            "onFailure", mapOf(
                                "state" to "NFC",
                                "code" to "StartNFCError",
                                "message" to "NFC Başlatılamadı OCR tarafındaki bilgiler kaydedilemedi."
                            )
                        )
                        result.error(
                            "Start_NFC_Error",
                            "NFC Başlatılamadı OCR tarafındaki bilgiler kaydedilemedi.",
                            null
                        )
                        return@wrapUiCommit
                    }

                    val activityContext = this@MainActivity
                    val nfcAdapter = android.nfc.NfcAdapter.getDefaultAdapter(activityContext)
                    if (nfcAdapter == null) {
                        emit(
                            "onFailure", mapOf(
                                "state" to "NFC",
                                "code" to "DeviceNotSupported",
                                "message" to "Cihazda NFC donanımı bulunamadı."
                            )
                        )
                        result.error("NFC_NOT_SUPPORTED", "Cihazda NFC donanımı yok.", null)
                        return@wrapUiCommit
                    }

                    if (!nfcAdapter.isEnabled) {
                        emit(
                            "onFailure", mapOf(
                                "state" to "NFC",
                                "code" to "NFCDisabled",
                                "message" to "Cihazda NFC özelliği kapalı."
                            )
                        )
                        result.error("NFC_DISABLED", "Cihazda NFC özelliği kapalı.", null)
                        return@wrapUiCommit
                    }
                    EnVerifyApi.getInstance().startNFC(nfcFragment)
                }

                "startNFCWithValues" -> {
                    wrapUiCommit(result) {
                        val nfcFragment = NFCFragment()
                        nfcFragment.setOutChannel(outChannel)
                        val activityContext = this@MainActivity
                        val nfcAdapter = android.nfc.NfcAdapter.getDefaultAdapter(activityContext)
                        if (nfcAdapter == null) {
                            emit("onFailure", mapOf(
                                "state" to "NFC",
                                "code" to "DeviceNotSupported",
                                "message" to "Cihazda NFC donanımı bulunamadı."
                            ))
                            result.error("NFC_NOT_SUPPORTED", "Cihazda NFC donanımı yok.", null)
                            return@wrapUiCommit
                        }
                        if (!nfcAdapter.isEnabled) {
                            emit("onFailure", mapOf(
                                "state" to "NFC",
                                "code" to "NFCDisabled",
                                "message" to "Cihazda NFC özelliği kapalı."
                            ))
                            result.error("NFC_DISABLED", "Cihazda NFC özelliği kapalı.", null)
                            return@wrapUiCommit
                        }
                        val serialNo = call.argument<String>("serialNo")!!
                        val birthDate = call.argument<String>("birthDate")!!
                        val expiryDate = call.argument<String>("expiryDate")!!
                        EnVerifyApi.getInstance().startNFCWithValues(
                            nfcFragment,
                            serialNo,
                            birthDate,
                            expiryDate
                        )
                    }
                }

                "isCameraCloseNFC" -> {
                    val isCameraCloseNFC = call.argument<Boolean>("isCameraCloseNFC") ?: true
                    EnVerifyApi.getInstance().isCameraCloseNFC = isCameraCloseNFC
                    result.success("isCameraCloseNFC successfully")
                }

                "startNfcRetried" -> wrapUiCommit(result) {

                    val title = call.argument<String>("title") ?: ""
                    val subtitle = call.argument<String>("subtitle") ?: ""

                    val nfc = com.enqura.enverify.models.NfcBACData.getInstance()
                    val vcNFCFragment = VCNFCFragment()
                    vcNFCFragment.setOutChannel(outChannel,title,subtitle)
                    supportFragmentManager.beginTransaction()
                        .replace(android.R.id.content, vcNFCFragment)
                        .commitAllowingStateLoss()

                    val hasValue = nfc.checkIfDataStoredBefore()
                    if (!hasValue) {
                        result.error("Start_NFC_Error", "NFC Başlatılamadı OCR tarafındaki bilgiler kaydedilemedi.", null)
                        return@wrapUiCommit
                    }

                    val activityContext = this@MainActivity
                    val nfcAdapter = android.nfc.NfcAdapter.getDefaultAdapter(activityContext)
                    if (nfcAdapter == null) {
                        emit("onFailure", mapOf(
                            "state" to "NFC",
                            "code" to "DeviceNotSupported",
                            "message" to "Cihazda NFC donanımı bulunamadı."
                        ))
                        result.error("NFC_NOT_SUPPORTED", "Cihazda NFC donanımı yok.", null)
                        return@wrapUiCommit
                    }

                    if (!nfcAdapter.isEnabled) {
                        emit("onFailure", mapOf(
                            "state" to "NFC",
                            "code" to "NFCDisabled",
                            "message" to "Cihazda NFC özelliği kapalı."
                        ))
                        result.error("NFC_DISABLED", "Cihazda NFC özelliği kapalı.", null)
                        return@wrapUiCommit
                    }

                    runOnUiThread {
                        try {
                            EnVerifyApi.getInstance().startNFC(vcNFCFragment)
                        } catch (e: Exception) {
                            result.error("NFC_START", e.message, null)
                        }
                    }
                }

                // ================= FACE / LIVENESS =================

                "startFaceDetect"        -> wrapUi(result) { EnVerifyApi.getInstance().startFaceDetect() }
                "smileDetect"            -> wrapUi(result) { EnVerifyApi.getInstance().smileDetect() }
                "eyeCloseDetect"         -> wrapUi(result) { EnVerifyApi.getInstance().eyeCloseDetect() }
                "eyeCloseIntervalDetect" -> wrapUi(result) { EnVerifyApi.getInstance().eyeCloseIntervalDetect() }
                "faceRightDetect"        -> wrapUi(result) { EnVerifyApi.getInstance().faceRightDetect() }
                "faceLeftDetect"         -> wrapUi(result) { EnVerifyApi.getInstance().faceLeftDetect() }
                "faceUpDetect"           -> wrapUi(result) { EnVerifyApi.getInstance().faceUpDetect() }
                "setFaceCompleted"       -> wrapUi(result) { EnVerifyApi.getInstance().setFaceCompleted() }

                // ================= CALL =================

                "setIsHandicapped" -> wrapUi(result) { EnVerifyApi.getInstance().setIsHandicapped(false) }
                "startVideoVerify" -> wrapUi(result) { EnVerifyApi.getInstance().startVideoVerify() }
                "startVideoCall"   -> wrapUi(result) { EnVerifyApi.getInstance().startVideoCall() }
                "startVideoChat"   -> wrapUi(result) { 
                    EnVerifyApi.getInstance().startVideoChat()
                }
                "startCall"        -> wrapUi(result) { EnVerifyApi.getInstance().startCall() }
                "restartVideoChat" ->  {
                    try {
                        EnVerifyApi.getInstance().restartVideoChat() 
                        result.success("restartVideoChat successfully")
                    } catch (e: Exception)
                    {
                        result.error("restartVideoChat() failed", e.message, null)
                    }     
                }

                "hangupCall" -> {
                    try {
                        EnVerifyApi.getInstance().setSpeaker(false)
                        EnVerifyApi.getInstance().hangupCall()
                        result.success("hangupCall successfully")
                    } catch (e: Exception)
                    {
                        result.error("hangupCall() failed", e.message, null)
                    }
                }

                "exit" -> {
                    try {
                        EnVerifyApi.getInstance().setSpeaker(false)
                        EnVerifyApi.getInstance().exit()
                        result.success("exit successfully")
                    } catch (e: Exception)
                    {
                        result.error("exit() failed", e.message, null)
                    }
                }
                
                "exitCall" -> { 
                    try {
                        EnVerifyApi.getInstance().setSpeaker(false)
                        EnVerifyApi.getInstance().exitCall()
                        result.success("exitCall successfully")
                    } catch (e: Exception)
                    {
                        result.error("exitCall() failed", e.message, null)
                    }
                }

                // ================= SELF SERVICE =================

                "startSelfServiceVerify" -> wrapUi(result) {
                    EnVerifyApi.getInstance().startSelfServiceVerify()
                }
                "startSelfService"      -> wrapUi(result) { EnVerifyApi.getInstance().startSelfService() }
                "verificationCompleted" -> wrapUi(result) { EnVerifyApi.getInstance().verificationCompleted() }

                // ================= Appointments =================

                "getAppointments" -> {

                    try {

                        EnVerifyApi.getInstance().getAppointments(
                            object : ApiCallback<VerifyAppointmentListMobileResponse> {
                                override fun onSuccess(
                                    p0: VerifyAppointmentListMobileResponse?,
                                    p1: Int,
                                    p2: MutableMap<String, MutableList<String>>?
                                ) {
                                    val gson = Gson()
                                    val jsonData = gson.toJson(p0)
                                    result.success(jsonData)
                                }

                                override fun onFailure(
                                    p0: ApiException?,
                                    p1: Int,
                                    p2: MutableMap<String, MutableList<String>>?
                                ) {
                                    val errorMessage = p0?.message ?: "Unknown error occurred"
                                    result.error("Get_Appointments_FAIL", errorMessage, null)
                                }

                                override fun onUploadProgress(p0: Long, p1: Long, p2: Boolean) {
                                }

                                override fun onDownloadProgress(p0: Long, p1: Long, p2: Boolean) {
                                }
                            }
                        )
                    } catch (e: Exception) {
                        result.error("Get_Available_Appointments", e.message, null)
                    }
                }
                "getAvailableAppointments" -> {

                    try {

                        val callType = call.argument<String>("callType")
                        val startDateStr = call.argument<String>("startDate")
                        val endDateStr = call.argument<String>("endDate")

                        val startDate: OffsetDateTime = OffsetDateTime.parse(startDateStr)
                        val endDate: OffsetDateTime = OffsetDateTime.parse(endDateStr)

                        EnVerifyApi.getInstance().getAvailableAppointments(
                            callType,
                            startDate,
                            endDate,
                            object : ApiCallback<VerifyAvailableAppointmentListResponse> {
                                override fun onSuccess(
                                    p0: VerifyAvailableAppointmentListResponse?,
                                    p1: Int,
                                    p2: MutableMap<String, MutableList<String>>?
                                ) {
                                    val gson = Gson()
                                    val jsonData = gson.toJson(p0)
                                    result.success(jsonData)
                                }

                                override fun onFailure(
                                    p0: ApiException?,
                                    p1: Int,
                                    p2: MutableMap<String, MutableList<String>>?
                                ) {
                                    val errorMessage = p0?.message ?: "Unknown error occurred"
                                    result.error("Get_CallTypes_FAIL", errorMessage, null)
                                }

                                override fun onUploadProgress(p0: Long, p1: Long, p2: Boolean) {
                                }

                                override fun onDownloadProgress(p0: Long, p1: Long, p2: Boolean) {
                                }
                            }
                        )
                    } catch (e: Exception) {
                        result.error("Get_Available_Appointments", e.message, null)
                    }
                }
                "saveAppointment" -> {

                    try {

                        val callType = call.argument<String>("callType")
                        val id = call.argument<String>("id")
                        val uuid = call.argument<String>("uuid")
                        val appointmentDateStr = call.argument<String>("appointmentDate")
                        val appointmentDate: OffsetDateTime = OffsetDateTime.parse(appointmentDateStr)
                        val startTime = call.argument<String>("startTime")

                        EnVerifyApi.getInstance().saveAppointment(
                            callType,
                            startTime,
                            appointmentDate,
                            null,
                            null,
                            null,
                            object : ApiCallback<VerifyAppointmentAddResponse> {
                                override fun onSuccess(
                                    p0: VerifyAppointmentAddResponse?,
                                    p1: Int,
                                    p2: MutableMap<String, MutableList<String>>?
                                ) {
                                    val gson = Gson()
                                    val jsonData = gson.toJson(p0)
                                    result.success(jsonData)
                                }

                                override fun onFailure(
                                    p0: ApiException?,
                                    p1: Int,
                                    p2: MutableMap<String, MutableList<String>>?
                                ) {
                                    val errorMessage = p0?.message ?: "Unknown error occurred"
                                    result.error("Save_Appointment_FAIL", errorMessage, null)
                                }

                                override fun onUploadProgress(p0: Long, p1: Long, p2: Boolean) {
                                }

                                override fun onDownloadProgress(p0: Long, p1: Long, p2: Boolean) {
                                }
                            }
                        )

                    } catch (e: Exception) {
                        result.error("Get_Available_Appointments", e.message, null)
                    }
                }

                // Continue

                    "setIsContinue" -> wrapUi(result) {

                        try{
                        val isContinue = call.argument<Boolean>("aContinue")!!
                        EnVerifyApi.getInstance().setIsContinue(isContinue)
                            result.success("isContinue successfully")
                        }catch (e: Exception) {
                        result.error("IsContinueError", e.message, null)
                    }
             }

                // ================= SCREEN RECORDING =================

                "startScreenRecording" -> {
                    try {
                        val mpm = getSystemService(MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
                        val captureIntent = mpm.createScreenCaptureIntent()
                        screenRecordResult = result
                        startActivityForResult(captureIntent, SCREEN_RECORD_REQUEST_CODE)
                    } catch (e: Exception) {
                        result.error("SCREEN_RECORD_FAIL", e.message, null)
                    }
                }
                "stopScreenRecording" -> wrapUi(result) { EnVerifyApi.getInstance().stopScreenRecording() }

                // ================= General Methods =================

                "postIntegrationAddRequest" -> wrapUi(result) {
                    val type = call.argument<String>("type")!!
                    val referance = call.argument<String>("referance")!!
                    val data = call.argument<String>("data")!!
                    val addressRegistrationModel = VerifyCallAddressRegistrationModel()
                    EnVerifyApi.getInstance().postIntegrationAddRequest(type, referance, data, null, addressRegistrationModel)
                }
                "getCallTypes" -> {
                    try {
                        EnVerifyApi.getInstance().getCallTypes(
                            object : ApiCallback<VerifyCallTypeNameListResponse> {
                                override fun onSuccess(
                                    p0: VerifyCallTypeNameListResponse?,
                                    p1: Int,
                                    p2: MutableMap<String, MutableList<String>>?
                                ) {
                                    val gson = Gson()
                                    val jsonData = gson.toJson(p0)
                                    result.success(jsonData)
                                }

                                override fun onFailure(
                                    p0: ApiException?,
                                    p1: Int,
                                    p2: MutableMap<String, MutableList<String>>?
                                ) {
                                    val errorMessage = p0?.message ?: "Unknown error occurred"
                                    result.error("Get_CallTypes_FAIL", errorMessage, null)
                                }

                                override fun onUploadProgress(p0: Long, p1: Long, p2: Boolean) {
                                }

                                override fun onDownloadProgress(p0: Long, p1: Long, p2: Boolean) {
                                }
                            }
                        )
                    } catch (e: Exception) {
                        result.error("Get_CallTypes_FAIL", e.message, null)
                    }
                }
                "closeFragmentByTag" -> {
                    val tag = call.argument<String>("tag")
                    if (tag != null) {
                        val fragmentManager = this.supportFragmentManager
                        val fragment = fragmentManager.findFragmentByTag(tag)
                        fragment?.let {
                            fragmentManager.beginTransaction()
                                .remove(fragment)
                                .commitAllowingStateLoss()
                        }
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "Tag is null", null)
                    }
                }
                "destroy" -> {
                    try {
                        EnVerifyApi.getInstance().destroy()
                        result.success("destroy successfully")
                    } catch (e: Exception)
                    {
                        result.error("destroy() failed", e.message, null)
                    }
                }

                // ================= MARKET =================

                "marketRedirect" -> {
                    val marketIntent = Intent(
                        Intent.ACTION_VIEW, Uri.parse("market://details?id=com.unluco.piapiri")
                    ).apply {
                        addFlags(
                            Intent.FLAG_ACTIVITY_NO_HISTORY or
                            Intent.FLAG_ACTIVITY_NEW_DOCUMENT or
                            Intent.FLAG_ACTIVITY_MULTIPLE_TASK
                        )
                    }
                    this.startActivity(marketIntent)
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }

    // ---- Screen recording izin sonucu
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == SCREEN_RECORD_REQUEST_CODE) {
            val granted = resultCode == Activity.RESULT_OK && data != null
            screenRecordResult?.success(granted)
            emit("onScreenRecordPermission", mapOf("granted" to granted))
            screenRecordResult = null
        }
    }

    // MainActivity'de intentleri Fragment'a ilet
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val fragment = supportFragmentManager.findFragmentById(android.R.id.content)
        if (fragment is NFCFragment) {
            fragment.setIntent(intent)
        }
        else if (fragment is VCNFCFragment) {
            fragment.setIntent(intent)
        }
    }

    // ===================== EnVerifyCallback → Flutter ====================
    // READY
    override fun videoCallReady()      { emit("onVideoCallReady") }
    override fun selfServiceReady()    { emit("onSelfServiceReady") }
    override fun idVerifyReady()       { emit("onIdVerifyReady") }
    override fun idSelfVerifyReady()   { emit("onIdSelfVerifyReady") }

    // OCR / ID
    override fun idRetry()             { emit("onIdRetry") }
    override fun idTypeVerified()      { emit("onIdTypeVerified") }
    override fun fakeChecked()         { emit("onFakeChecked") }
    override fun idDocCompleted()      {
        val user = User.getInstance()
        val doc = CustomerIdentityDoc.getInstance()
        user.firstName = doc.name
        user.lastName = doc.surname
        emit("onIdDocCompleted")
    }
    override fun idDocVerified()       { emit("onIdDocVerified") }
    override fun idDocStored()         {  emit("onIdDocStored") }
    override fun idDocStoreFailed()    { emit("onIdDocStoreFailed") }
    override fun cardFrontDetected()   { emit("onCardFrontDetected") }
    override fun cardBackDetected()    { emit("onCardBackDetected") }
    override fun cardHoloDetected()    { emit("onCardHoloDetected") }
    override fun idFrontCompleted()    { emit("onIdFrontCompleted") }
    override fun retryTextVerification()   { emit("onRetryTextVerification") }


    // NFC
    override fun nfcReady()            { emit("onNfcReady") }
    override fun nfcRetry()            { emit("onNfcRetry") }
    override fun nfcCompleted()        { emit("onNfcCompleted") }
    override fun nfcVerified()         { emit("onNfcVerified") }
    override fun nfcStored()           { emit("onNfcStored") }
    override fun nfcStoreFailed()      { emit("onNfcStoreFailed") }
    override fun nfcBACDataFailure()   { emit("onNfcBACDataFailure") }
    override fun retryNFCVerification()    { emit("onRetryNFCVerification") }

    // FACE / LIVENESS
    override fun faceReady()               { emit("onFaceReady") }
    override fun faceRetry()               { emit("onFaceRetry") }
    override fun faceDetected()            { emit("onFaceDetected") }
    override fun smileDetected()           { emit("onSmileDetected") }
    override fun faceCompleted()           { emit("onFaceCompleted") }
    override fun faceVerified()            { emit("onFaceVerified") }
    override fun faceStored()              { emit("onFaceStored") }
    override fun faceStoreFailed()         { emit("onFaceStoreFailed") }
    override fun faceStoreCompleted()      { emit("onFaceStoreCompleted") }
    override fun eyeCloseDetected()        { emit("onEyeCloseDetected") }
    override fun eyeCloseIntervalDetected(){ emit("onEyeCloseIntervalDetected") }
    override fun rightEyeCloseDetected()   { emit("onRightEyeCloseDetected") }
    override fun leftEyeCloseDetected()    { emit("onLeftEyeCloseDetected") }
    override fun faceLeftDetected()        { emit("onFaceLeftDetected") }
    override fun faceRightDetected()       { emit("onFaceRightDetected") }
    override fun faceUpDetected()          { emit("onFaceUpDetected") }
    override fun retryFaceVerification()   { emit("onRetryFaceVerification") }

    // CALL FLOW
    override fun callWait()                { emit("onCallWait") }
    override fun callStarted()             { emit("onCallStarted") }
    override fun localHangedUp()           { emit("onLocalHangedUp") }
    override fun remoteHangedUp()          { emit("onRemoteHangedUp") }
    override fun resolutionChanged()       { emit("onResolutionChanged") }
    override fun forceHangup()             { emit("onForceHangup") }
    override fun onRoomIDSendSucceed()     { emit("onRoomIDSendSucceed") }
    override fun onRoomIDSendFailed()      { emit("onRoomIDSendFailed") }
    override fun callSessionCloseResult(p0: CloseSessionStatus?) {
        emit("onCallSessionCloseResult", mapOf("status" to (p0?.name ?: "UNKNOWN")))
    }
    override fun maximumCallTimeExpired()  { emit("onMaximumCallTimeExpired") }

    // INTEGRATION / RESULT
    override fun onIntegrationSucceed()    { emit("onIntegrationSucceed") }
    override fun onIntegrationFailed()     { emit("onIntegrationFailed") }
    override fun onResultGetSucceed(p0: VerifyCallResultModel?) {
        emit("onResultGetSucceed", mapOf("verifyCallResult" to (p0?.result)))
    }
    override fun onResultGetFailed()       { emit("onResultGetFailed") }

    // AGENT / MISC
    override fun agentRequest(p0: String?) { emit("onAgentRequest", mapOf("request" to (p0 ?: ""))) }
    override fun agentCameraDisabled()     { emit("onAgentCameraDisabled") }
    override fun agentCameraEnabled()      { emit("onAgentCameraEnabled") }
    override fun onVideoAddSucceed()       { emit("onVideoAddSucceed") }
    override fun onVideoAddFailure(p0: String?) { emit("onVideoAddFailure", mapOf("message" to (p0 ?: ""))) }
    override fun signingSucceed()          { emit("onSigningSucceed") }
    override fun signingFailed()           { emit("onSigningFailed") }
    override fun sessionUpdateSucceed()    { emit("onSessionUpdateSucceed") }
    override fun sessionUpdateFailed()     { emit("onSessionUpdateFailed") }

    override fun onNonIcaoStarted()  { emit("onNonIcaoStarted") }
    override fun onNonIcaoCompleted(){ emit("onNonIcaoCompleted") }
    override fun onNonIcaoStored()   { emit("onNonIcaoStored") }
    override fun onNonIcaoStoreFailed(){ emit("onNonIcaoStoreFailed") }

    // SESSION START/FAIL
    override fun onSessionStartFailed() {
        Log.e("MainActivity", "Session start failed.")
        emit("onSessionStartFailed")
    }
    override fun onSessionStartSucceed(isSettingsSucceed: Boolean, sessionUID: String?) {
        //Log.d("Enqualify", "Session başlatıldı: $sessionUID (settings=$isSettingsSucceed)")
        emit("onSessionStartSucceed", mapOf(
            "sessionUID" to (sessionUID ?: ""),
            "isSettingsSucceed" to isSettingsSucceed
        ))
    }

    // CERTIFICATE
    override fun onCertificateSucceed() { Log.d("Enqualify", "Sertifika OK"); emit("onCertificateSucceed") }
    override fun onCertificateFailed()  { Log.e("Enqualify", "Sertifika FAIL"); emit("onCertificateFailed") }

    // SCREEN RECORDER EVENTS
    override fun screenRecorderOnStart()      { emit("onScreenRecorderStart") }
    override fun screenRecorderOnComplete()   { emit("onScreenRecorderComplete") }
    override fun screenRecorderOnAppend()     { emit("onScreenRecorderAppend") }
    override fun screenRecorderOnError(code: Int, msg: String?) {
        emit("onScreenRecorderError", mapOf("code" to code, "message" to (msg ?: "")))
    }

    // RESTART VERIFICATION (interface metodu)
    override fun restartVerification() { emit("onRestartVerification") }

    // FAILURE MAPPING
    override fun onFailure(state: IDVerifyState?, code: IDVerifyFailureCode?, raw: String?) {
        val message = when (code) {
            IDVerifyFailureCode.IDTextRecognitionTimeout   -> "Kimlik okuma zaman aşımı."
            IDVerifyFailureCode.SmilingCheckFailure        -> "Gülümseme algılanamadı."
            IDVerifyFailureCode.RightEyeCloseCheckFailure  -> "Sağ göz kapanmadı."
            IDVerifyFailureCode.LeftEyeCloseCheckFailure   -> "Sol göz kapanmadı."
            IDVerifyFailureCode.EyeCloseCheckFailure       -> "Göz kırpma tespiti başarısız."
            IDVerifyFailureCode.EyeOpenCheckFailure        -> "Göz açma tespiti başarısız."
            IDVerifyFailureCode.faceNotFound               -> "Yüz algılanamadı."
            IDVerifyFailureCode.FakeIDCheckFailure         -> "Kimlik sahte olabilir."
            IDVerifyFailureCode.FaceAngleFailure           -> "Yüz çok eğik."

            IDVerifyFailureCode.AuthFailureError           -> "Kimlik doğrulama hatası."
            IDVerifyFailureCode.NoConnectionError          -> "İnternet bağlantısı yok."
            IDVerifyFailureCode.ServerError                -> "Sunucu hatası."
            IDVerifyFailureCode.NetworkError               -> "Ağ hatası."
            IDVerifyFailureCode.DeviceNotSupported         -> "Cihaz desteklemiyor."

            IDVerifyFailureCode.NFCTimeout                 -> "NFC zaman aşımı."
            IDVerifyFailureCode.NFCConnectionError         -> "NFC bağlantı hatası."
            IDVerifyFailureCode.NFCKeysFailure             -> "NFC anahtarları okunamadı."

            else                                           -> raw ?: "Bilinmeyen hata."
        }

        if (message.isNotEmpty())
        {
            runOnUiThread {
                Toast.makeText(this, message, Toast.LENGTH_LONG).show()
            }
        }

        Log.e("ENQUALIFY", "Hata (${state?.name}): $code - $message")
        emit("onFailure", mapOf(
            "state" to (state?.name ?: "UNKNOWN"),
            "code" to (code?.name ?: "UNKNOWN"),
            "message" to message
        ))
    }

}
