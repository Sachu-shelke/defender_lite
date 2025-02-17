package com.info.defenders

import android.Manifest
import android.content.pm.PackageManager
import android.database.Cursor
import android.provider.CallLog
import android.provider.Telephony
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "call_sms_log_channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getCallLogs" -> {
                    if (checkSelfPermission(Manifest.permission.READ_CALL_LOG) == PackageManager.PERMISSION_GRANTED) {
                        result.success(getCallLogs())
                    } else {
                        result.error("PERMISSION_DENIED", "Call log permission denied", null)
                    }
                }
                "getSmsLogs" -> {
                    if (checkSelfPermission(Manifest.permission.READ_SMS) == PackageManager.PERMISSION_GRANTED) {
                        result.success(getSmsLogs())
                    } else {
                        result.error("PERMISSION_DENIED", "SMS log permission denied", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getCallLogs(): List<Map<String, String>> {
        val callLogs = mutableListOf<Map<String, String>>()
        val cursor: Cursor? = contentResolver.query(
            CallLog.Calls.CONTENT_URI,
            arrayOf(CallLog.Calls.NUMBER, CallLog.Calls.DURATION, CallLog.Calls.TYPE),
            null, null, CallLog.Calls.DATE + " DESC"
        )

        cursor?.use {
            val numberIndex = it.getColumnIndex(CallLog.Calls.NUMBER)
            val durationIndex = it.getColumnIndex(CallLog.Calls.DURATION)
            val typeIndex = it.getColumnIndex(CallLog.Calls.TYPE)

            while (it.moveToNext()) {
                val number = it.getString(numberIndex) ?: "Unknown"
                val duration = it.getString(durationIndex) ?: "0"
                val type = it.getString(typeIndex) ?: "0"

                callLogs.add(mapOf(
                    "number" to number,
                    "duration" to duration,
                    "type" to type
                ))
            }
        }
        return callLogs
    }

    private fun getSmsLogs(): List<Map<String, String>> {
        val smsLogs = mutableListOf<Map<String, String>>()
        val cursor: Cursor? = contentResolver.query(
            Telephony.Sms.CONTENT_URI,
            arrayOf(Telephony.Sms.ADDRESS, Telephony.Sms.BODY, Telephony.Sms.TYPE),
            null, null, Telephony.Sms.DATE + " DESC"
        )

        cursor?.use {
            val addressIndex = it.getColumnIndex(Telephony.Sms.ADDRESS)
            val bodyIndex = it.getColumnIndex(Telephony.Sms.BODY)
            val typeIndex = it.getColumnIndex(Telephony.Sms.TYPE)

            while (it.moveToNext()) {
                val address = it.getString(addressIndex) ?: "Unknown"
                val message = it.getString(bodyIndex) ?: ""
                val type = it.getString(typeIndex) ?: "0"

                smsLogs.add(mapOf(
                    "address" to address,
                    "body" to message,  // Make sure 'body' is included
                    "type" to type
                ))
            }
        }
        return smsLogs
    }
}
