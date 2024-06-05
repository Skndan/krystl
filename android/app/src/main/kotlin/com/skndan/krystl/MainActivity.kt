package com.skndan.krystl

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.PackageManager.NameNotFoundException
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var activity: Activity? = null
    private var _result: MethodChannel.Result? = null
    private var requestCodeNumber = 1907

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "skndan.com/flutter_upi"
        ).setMethodCallHandler { call, result ->
            if (call.method == "initiateTransaction") {
                val app: String =
                    if (call.argument<String?>("app") == null) "in.org.npci.upiapp" else call.argument<String>(
                        "app"
                    )
                        .toString()
                val pa: String? = call.argument<String?>("pa")
                val pn: String? = call.argument<String?>("pn")
                val tr: String? = call.argument<String?>("tr")
                val tn: String? = call.argument<String?>("tn")
                val am: String? = call.argument<String?>("am")
                val cu: String? = call.argument<String?>("cu")
                try {
                    val uriBuilder = Uri.Builder()
                    uriBuilder.scheme("upi").authority("pay")
                    uriBuilder.appendQueryParameter("pa", pa)
                    uriBuilder.appendQueryParameter("pn", pn)
                    uriBuilder.appendQueryParameter("tr", tr)
                    uriBuilder.appendQueryParameter("tn", tn)
                    uriBuilder.appendQueryParameter("am", am)
                    uriBuilder.appendQueryParameter("cu", cu)
                    val uri = uriBuilder.build()
                    Log.d("krystl", uri.toString())
                    val intent = Intent(Intent.ACTION_VIEW)
                    intent.setData(uri)
                    intent.setPackage(app)
                    if (appInstalledOrNot(app)) {
                        activity!!.startActivityForResult(intent, requestCodeNumber)
                        _result = result
                    } else {
                        result.success("app_not_installed")
                        Log.d("flutter_upi", "$app not installed on the device.")
                    }
                } catch (ex: Exception) {
                    result.success("invalid_params")
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCodeNumber == requestCode && _result != null) {
            if (data != null) {
                try {
                    val response = data.getStringExtra("response")
                    _result!!.success(response)
                } catch (ex: Exception) {
                    _result!!.success("null_response")
                }
            } else {
                Log.d("Result", "Data = null (User canceled)")
                _result!!.success("user_canceled")
            }
        } else {
            _result!!.success("null_response")
        }
    }

    private fun appInstalledOrNot(uri: String): Boolean {
        val pm = activity!!.packageManager
        try {
            pm.getPackageInfo(uri, PackageManager.GET_ACTIVITIES)
            return true
        } catch (_: NameNotFoundException) {
        }
        return false
    }
}
