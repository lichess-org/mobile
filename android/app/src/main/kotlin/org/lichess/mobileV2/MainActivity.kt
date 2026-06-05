package org.lichess.mobileV2

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.graphics.Rect
import android.os.Bundle
import android.util.Log
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

  // The OAuth redirect (org.lichess.mobile://login-callback) is delivered here, not in onCreate,
  // because OAuthCallbackActivity forwards it to this already-running singleTop instance. Flutter's
  // default handling leaves getIntent() pointing at the stale launch intent, so app_links would read
  // the wrong URI and the login flow would never receive the callback. setIntent() updates the
  // activity's current intent to the one carrying the OAuth code so app_links surfaces it correctly.
  override fun onNewIntent(intent: Intent) {
    setIntent(intent)
    super.onNewIntent(intent)
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
    inputRects.mapNotNull { item ->
        val left = item["left"]
        val top = item["top"]
        val right = item["right"]
        val bottom = item["bottom"]

        // If any of these are null, the whole block returns null
        if (left != null && top != null && right != null && bottom != null) {
            Rect(left, top, right, bottom)
        } else {
            // Log a warning instead
            Log.w("RectDecoder", "Skipping malformed rect: $item")
            null
        }
    }

  private fun getAvailableMemory(): ActivityManager.MemoryInfo {
    val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
    return ActivityManager.MemoryInfo().also { memoryInfo ->
        activityManager.getMemoryInfo(memoryInfo)
    }
  }
}
