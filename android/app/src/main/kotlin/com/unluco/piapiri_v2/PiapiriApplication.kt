package com.unluco.piapiri

import android.app.Application
import android.util.Log
import com.enqura.enverify.helpers.EnActivityStateTracker

class PiapiriApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        Log.d("PiapiriApplication", "Uygulama başlatıldı!")
        EnActivityStateTracker.init(this)
    }
}