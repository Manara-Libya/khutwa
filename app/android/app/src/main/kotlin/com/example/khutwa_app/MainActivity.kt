package com.example.khutwa_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import ly.manara.khutwa.privacy.StubRedactor

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // TODO(#58): replace StubRedactor() with Anas's real Redactor.
        RedactorChannel(flutterEngine.dartExecutor.binaryMessenger, StubRedactor())
    }
}
