package com.unluco.piapiri_v2

import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.os.Bundle
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import com.smartvist.idverify.nfcreader.NFCBaseFragment
import com.unluco.piapiri.R
import io.flutter.plugin.common.MethodChannel

class VCNFCFragment : NFCBaseFragment() {

    private var outChannel: MethodChannel? = null
    private var title: String = ""
    private var subtitle: String = ""
    private var progressBar: ProgressBar? = null
    private var statusIcon: ImageView? = null
    private var statusText: TextView? = null
    private var infoTitle: TextView? = null
    private var infoSubtitle: TextView? = null


    fun setOutChannel(channel: MethodChannel?,strTitle:String,strSubtitle:String) {
        outChannel = channel
        title = strTitle
        subtitle = strSubtitle
    }

    override fun nfcFragmentView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View {
        val view = inflater.inflate(R.layout.fragment_nfc_read, container, false)
        progressBar = view.findViewById(R.id.customProgressBar)
        statusIcon = view.findViewById(R.id.infoImage)
        statusText = view.findViewById(R.id.progressText)
        infoTitle = view.findViewById(R.id.infoTitle)
        infoSubtitle = view.findViewById(R.id.infoSubtitle)
        infoTitle?.text = title
        infoSubtitle?.text = subtitle
        return view
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
        requireActivity().runOnUiThread {
            outChannel?.invokeMethod(event, data ?: emptyMap<String, Any>())
        }
    }

    override fun nfcReadStarted() {
        progressBar?.progress = 0
        statusText?.text = "NFC okuma başladı"
        statusIcon?.setImageResource(R.drawable.ic_nfc)
        sendEvent("onNfcReadStarted")
    }

    override fun nfcTagDetected() {
        statusText?.text = "NFC etiketi algılandı"
        sendEvent("onNfcTagDetected")
    }

    override fun nfcFirstLevel() {
        progressBar?.progress = 25
        statusText?.text = "Kimlik doğrulama 1. seviye"
        sendEvent("onNfcFirstLevel")
    }

    override fun nfcSecondLevel() {
        progressBar?.progress = 50
        statusText?.text = "Kimlik doğrulama 2. seviye"
        sendEvent("onNfcSecondLevel")
    }

    override fun nfcThirdLevel() {
        progressBar?.progress = 75
        statusText?.text = "Kimlik doğrulama 3. seviye"
        sendEvent("onNfcThirdLevel")
    }

    override fun nfcFourthLevel() {
        progressBar?.progress = 100
        statusText?.text = "NFC başarıyla tamamlandı"
        sendEvent("onNfcFourthLevel")
        progressBar?.postDelayed({
            progressBar?.visibility = View.GONE
            statusIcon?.setImageResource(R.drawable.ic_check_circle)
        }, 100)
    }

    override fun nfcReadError(var1: String) {
        progressBar?.progress = 0
        statusText?.text = "NFC okuma hatası lütfen tekrar deneyin"
        statusIcon?.setImageResource(R.drawable.ic_nfc)
        sendEvent("onNfcReadError", mapOf("message" to var1))
    }
}
