package com.info.defenders

import android.annotation.TargetApi
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.util.Log

class DialReceiver : BroadcastReceiver() {

    @TargetApi(Build.VERSION_CODES.CUPCAKE)
    override fun onReceive(context: Context, intent: Intent) {
        val uri: Uri? = intent.data
        if (uri != null && uri.schemeSpecificPart == "426548") {
            Log.d("DialReceiver", "Secret code entered. Launching app...")

            // Launch your main activity here
            val launchIntent: Intent? =
                context.packageManager.getLaunchIntentForPackage("com.info.defenders")
            launchIntent?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(launchIntent)
        }
    }
}
