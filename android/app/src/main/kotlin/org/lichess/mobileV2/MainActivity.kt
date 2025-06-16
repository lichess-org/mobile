package org.lichess.mobileV2

import android.app.ActivityManager
import android.content.Context
import android.graphics.Rect
import android.os.Bundle
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.core.view.ViewCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  private val GESTURES_CHANNEL = "mobile.lichess.org/gestures_exclusion"
  private val SYSTEM_CHANNEL = "mobile.lichess.org/system"

  override fun onCreate(savedInstanceState: Bundle?) {
    installSplashScreen()
    super.onCreate(savedInstanceState)
  }

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, GESTURES_CHANNEL).setMethodCallHandler {
      call, result ->
      if (call.method == "setSystemGestureExclusionRects") {
        val arguments = call.arguments as List<Map<String, Int>>
        val decodedRects = decodeExclusionRects(arguments)
        ViewCompat.setSystemGestureExclusionRects(activity.window.decorView, decodedRects)
        result.success(null)
      } else {
        result.notImplemented()
      }
    }

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SYSTEM_CHANNEL).setMethodCallHandler {
      call, result ->
      when (call.method) {
          "clearApplicationUserData" -> {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            result.success(activityManager.clearApplicationUserData())
          }
          "getTotalRam" -> {
            val memoryInfo = getAvailableMemory()
            val totalMemInMb = memoryInfo.totalMem / 1048576L
            result.success(totalMemInMb.toInt())
          }
          // "getAvailableRam" -> {
          //   val memoryInfo = getAvailableMemory()
          //   val availMemInMb = memoryInfo.availMem / 1048576L
          //   result.success(availMemInMb.toInt())
          // }
          else -> {
            result.notImplemented()
          }
      }
    }
  }

  private fun decodeExclusionRects(inputRects: List<Map<String, Int>>): List<Rect> =
    inputRects.mapIndexed { index, item ->
      Rect(
        item["left"] ?: error("rect at index $index doesn't contain 'left' property"),
        item["top"] ?: error("rect at index $index doesn't contain 'top' property"),
        item["right"] ?: error("rect at index $index doesn't contain 'right' property"),
        item["bottom"] ?: error("rect at index $index doesn't contain 'bottom' property")
      )
    }

  private fun getAvailableMemory(): ActivityManager.MemoryInfo {
    val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
    return ActivityManager.MemoryInfo().also { memoryInfo ->
        activityManager.getMemoryInfo(memoryInfo)
    }
  }
}
