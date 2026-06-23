package org.lichess.mobileV2

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Rect
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.core.view.ViewCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  private val GESTURES_CHANNEL = "mobile.lichess.org/gestures_exclusion"
  private val SYSTEM_CHANNEL = "mobile.lichess.org/system"
  private val SHARE_CHANNEL = "mobile.lichess.org/share"
  private val SHARE_EVENTS_CHANNEL = "mobile.lichess.org/share/events"

  // PGN the app was cold-started with, served once via the `getInitialPgn` method
  // call. Also holds a PGN shared while running if Flutter isn't listening yet.
  private var initialPgn: String? = null
  private var shareEventSink: EventChannel.EventSink? = null

  override fun onCreate(savedInstanceState: Bundle?) {
    installSplashScreen()
    initialPgn = readPgnFromIntent(intent)
    super.onCreate(savedInstanceState)
  }

  // Deep links (study/broadcast/puzzle/share/open-web, etc.) delivered while the app is already
  // running arrive here. Flutter's default handling leaves getIntent() pointing at the stale launch
  // intent, so app_links would read the wrong URI; setIntent() updates the activity's current intent
  // to the freshly received one so app_links surfaces it correctly. (OAuth callbacks no longer pass
  // through here — flutter_appauth captures them in its own RedirectUriReceiverActivity.)
  override fun onNewIntent(intent: Intent) {
    setIntent(intent)
    super.onNewIntent(intent)
    readPgnFromIntent(intent)?.let { pgn ->
      val sink = shareEventSink
      if (sink != null) sink.success(pgn) else initialPgn = pgn
    }
  }

  // Reads the text of a shared/opened PGN file. The manifest only routes the
  // chess-pgn mime types and *.pgn content URIs here, so we can read the stream
  // directly without inspecting the mime type.
  private fun readPgnFromIntent(intent: Intent?): String? {
    val uri: Uri? = when (intent?.action) {
      Intent.ACTION_VIEW -> intent.data
      Intent.ACTION_SEND -> {
        @Suppress("DEPRECATION")
        intent.getParcelableExtra(Intent.EXTRA_STREAM)
      }
      else -> null
    }
    return uri?.let {
      try {
        contentResolver.openInputStream(it)?.use { stream ->
          stream.readBytes().toString(Charsets.UTF_8)
        }
      } catch (e: Exception) {
        Log.w("SharePgn", "Failed to read shared PGN", e)
        null
      }
    }
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
          // Returns the default browser's package and version, used to attribute login failures.
          "getDefaultBrowser" -> {
            result.success(getDefaultBrowserInfo())
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

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SHARE_CHANNEL).setMethodCallHandler {
      call, result ->
      if (call.method == "getInitialPgn") {
        result.success(initialPgn)
        initialPgn = null
      } else {
        result.notImplemented()
      }
    }

    EventChannel(flutterEngine.dartExecutor.binaryMessenger, SHARE_EVENTS_CHANNEL).setStreamHandler(
      object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
          shareEventSink = events
        }

        override fun onCancel(arguments: Any?) {
          shareEventSink = null
        }
      }
    )
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

  private fun getDefaultBrowserInfo(): Map<String, String?>? {
    return try {
      val pm = packageManager
      val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse("https://lichess.org"))
      val resolveInfo = pm.resolveActivity(browserIntent, PackageManager.MATCH_DEFAULT_ONLY)
      val pkg = resolveInfo?.activityInfo?.packageName ?: return null
      val version = try {
        pm.getPackageInfo(pkg, 0).versionName
      } catch (e: Exception) {
        null
      }
      mapOf("package" to pkg, "version" to version)
    } catch (e: Exception) {
      null
    }
  }
}
