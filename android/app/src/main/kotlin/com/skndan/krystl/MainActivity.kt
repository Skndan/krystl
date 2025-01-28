package com.skndan.krystl

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.IntentFilter

class MainActivity: FlutterActivity()  {
    private val CHANNEL = "com.skndan.krystl/launch"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method.equals("launchUpi")) {
                val uri: String? = call.argument("uri")
                val packageName: String? = call.argument("packageName")
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(uri))
                intent.setPackage(packageName)
                try {
                    startActivity(intent)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("ERROR", "UPI app not available or failed to launch", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
