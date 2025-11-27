package com.unluco.piapiri_v2
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.nfc.NfcAdapter
import android.content.Intent
import android.os.Bundle
import com.smartvist.idverify.nfcreader.NFCBaseFragment
import com.enqura.enverify.EnVerifyApi
import io.flutter.plugin.common.MethodChannel

class NFCFragment : NFCBaseFragment() {

    private var outChannel: MethodChannel? = null
    fun setOutChannel(channel: MethodChannel? = null) {
        outChannel = channel
    }

    override fun nfcFragmentView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View {
        return FrameLayout(inflater.context).apply {
            layoutParams = ViewGroup.LayoutParams(1, 1)
            visibility = View.GONE
            isClickable = false
            isFocusable = false
        }
    }

    fun setIntent(intent: Intent?) {
        onNewIntent(intent)
    }

    fun onNewIntent(intent: Intent?) {
        if (intent != null) {
            resolveIntent(intent)
        }
    }

    private fun sendEvent(event: String, data: Map<String, Any>? = null) {
        val payload = mutableMapOf<String, Any>("event" to event)
        if (data != null) payload["data"] = data

        requireActivity().runOnUiThread {
            outChannel?.invokeMethod(event, data ?: emptyMap<String, Any>())
        }
    }

    override fun nfcReadStarted() {
        sendEvent("onNfcReadStarted")
    }

    override fun nfcTagDetected() {
        sendEvent("onNfcTagDetected")
    }

    override fun nfcFirstLevel() {
        sendEvent("onNfcFirstLevel")
    }

    override fun nfcSecondLevel() {
        sendEvent("onNfcSecondLevel")
    }

    override fun nfcThirdLevel() {
        sendEvent("onNfcThirdLevel")
    }

    override fun nfcFourthLevel() {
        sendEvent("onNfcFourthLevel")
    }

    override fun nfcReadError(var1: String) {
        sendEvent("onNfcReadError", mapOf("message" to var1))
    }
}
