package com.example.khutwa_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import ly.manara.khutwa.privacy.LibyanRedactor

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        RedactorChannel(flutterEngine.dartExecutor.binaryMessenger, LibyanRedactor())
    }
}
