package com.example.flutter_application_4

import io.flutter.embedding.android.FlutterActivity
import android.view.WindowManager.LayoutParams
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode.transparent
import io.flutter.embedding.android.FlutterActivityLaunchConfigs

class MainActivity: FlutterActivity() {
    override fun onResume() {
        super.onResume()
        window.addFlags(LayoutParams.FLAG_SECURE)
    }
    override fun getBackgroundMode(): FlutterActivityLaunchConfigs.BackgroundMode {
        return transparent
    }
}
