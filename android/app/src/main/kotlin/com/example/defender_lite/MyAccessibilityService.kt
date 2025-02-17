package com.info.defenders

import android.accessibilityservice.AccessibilityService
import android.annotation.SuppressLint
import android.view.accessibility.AccessibilityEvent

@SuppressLint("NewApi")
class MyAccessibilityService : AccessibilityService() {
    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // Handle accessibility events if necessary
    }

    override fun onInterrupt() {
        // Handle service interruption if necessary
    }
}
