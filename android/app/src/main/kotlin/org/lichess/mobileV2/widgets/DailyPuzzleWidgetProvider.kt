package org.lichess.mobileV2.widgets

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.PorterDuff
import android.graphics.PorterDuffXfermode
import android.graphics.Rect
import android.graphics.RectF
import android.net.Uri
import android.os.Bundle
import android.os.SystemClock
import android.text.format.DateUtils
import android.util.Log
import android.util.TypedValue
import android.view.View
import android.widget.RemoteViews
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import java.net.UnknownHostException
import kotlin.concurrent.thread
import org.lichess.mobileV2.R
import org.lichess.mobileV2.MainActivity


class DailyPuzzleWidgetProvider : AppWidgetProvider() {

  companion object {
    private const val ACTION_RETRY = "org.lichess.mobileV2.widgets.DAILY_PUZZLE_RETRY"
    private const val RETRY_DELAY_MILLIS = 60 * 60 * 1000L
    private const val FETCH_ATTEMPTS = 3
  }

  data class DailyPuzzle(
    val id: String,
    val fen: String,
    val lastMove: String
  )

  // Since Android 15 the system cuts the network of an app idling in the background, and gives it
  // back only shortly after a broadcast wakes it up. An update that comes in before that fails
  // right away with an UnknownHostException, so retry it a few times before giving up.
  private fun fetchDailyPuzzleWithRetry(lichessHost: String): DailyPuzzle {
    var attempt = 1
    while (true) {
      try {
        return fetchDailyPuzzle(lichessHost)
      } catch (e: UnknownHostException) {
        if (attempt == FETCH_ATTEMPTS) throw e
        Log.w("DailyPuzzleWidget", "Network not ready (attempt $attempt), retrying: $e")
        Thread.sleep(attempt * 1000L)
        attempt++
      }
    }
  }

  // Throws on network, HTTP or JSON errors: there is always a daily puzzle, so a failure is an
  // error to show, not an empty state.
  private fun fetchDailyPuzzle(lichessHost : String): DailyPuzzle {
    val scheme = if (lichessHost.startsWith("localhost")) "http" else "https"
    val url = URL("$scheme://$lichessHost/api/puzzle/daily")

    val connection = url.openConnection() as HttpURLConnection
    connection.connectTimeout = 10000
    connection.readTimeout = 10000
    connection.setRequestProperty("Accept", "application/json")
    try {
      return connection.inputStream.use { stream ->
        val jsonString = stream.bufferedReader().use { it.readText() }
        val puzzle = JSONObject(jsonString).getJSONObject("puzzle")
        DailyPuzzle(
          id = puzzle.getString("id"),
          fen = puzzle.getString("fen"),
          lastMove = puzzle.getString("lastMove")
        )
      }
    } finally {
      connection.disconnect()
    }
  }

  override fun onReceive(context: Context, intent: Intent) {
    val pendingResult = goAsync()
    thread {
      try {
        if (intent.action == ACTION_RETRY) {
          val appWidgetManager = AppWidgetManager.getInstance(context)
          val appWidgetIds = appWidgetManager.getAppWidgetIds(
            ComponentName(context, DailyPuzzleWidgetProvider::class.java)
          )
          onUpdate(context, appWidgetManager, appWidgetIds)
        } else {
          super.onReceive(context, intent)
        }
      } finally {
        pendingResult.finish()
      }
    }
  }

  override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
    super.onUpdate(context, appWidgetManager, appWidgetIds)
    // `map` rather than `all`: every widget must be updated, even after a failure.
    val succeeded = appWidgetIds.map { updateWidget(context, appWidgetManager, it) }.all { it }
    if (succeeded) cancelRetry(context) else scheduleRetry(context)
  }

  override fun onDisabled(context: Context) {
    super.onDisabled(context)
    cancelRetry(context)
  }

  // The regular update comes every 6 hours (updatePeriodMillis), so a failed update is retried
  // sooner, like the iOS widget. The alarm is inexact, so it needs no exact alarm permission and
  // the system can batch it; scheduling again replaces the pending one.
  private fun scheduleRetry(context: Context) {
    val alarmManager = context.getSystemService(AlarmManager::class.java)
    alarmManager.set(
      AlarmManager.ELAPSED_REALTIME,
      SystemClock.elapsedRealtime() + RETRY_DELAY_MILLIS,
      retryPendingIntent(context)
    )
  }

  private fun cancelRetry(context: Context) {
    context.getSystemService(AlarmManager::class.java).cancel(retryPendingIntent(context))
  }

  private fun retryPendingIntent(context: Context): PendingIntent {
    val intent = Intent(context, DailyPuzzleWidgetProvider::class.java).setAction(ACTION_RETRY)
    return PendingIntent.getBroadcast(
      context,
      0,
      intent,
      PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )
  }

  private fun buildClickPendingIntent(
    context: Context,
    appWidgetId: Int,
    puzzleId: String?
  ): PendingIntent {
    val intent = if (puzzleId != null) {
      Intent(Intent.ACTION_VIEW, Uri.parse("org.lichess.mobile://training/daily/$puzzleId")).apply {
        setClass(context, MainActivity::class.java)
        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      }
    } else {
      Intent(context, MainActivity::class.java).apply {
        action = Intent.ACTION_MAIN
        addCategory(Intent.CATEGORY_LAUNCHER)
        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      }
    }
    return PendingIntent.getActivity(
      context,
      appWidgetId,
      intent,
      PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )
  }

  // Returns whether the puzzle was loaded and drawn.
  private fun updateWidget(
    context : Context,
    appWidgetManager : AppWidgetManager,
    appWidgetId : Int
  ): Boolean {
    var succeeded = false
    val remoteViews = RemoteViews(context.packageName, R.layout.widget_daily_puzzle)

    val dateStr = DateUtils.formatDateTime(
      context,
      System.currentTimeMillis(),
      DateUtils.FORMAT_SHOW_DATE or DateUtils.FORMAT_ABBREV_ALL
    )
    remoteViews.setTextViewText(R.id.daily_puzzle_date, dateStr)

    var puzzleId: String? = null
    try {
      val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
      val lichessHost = prefs.getString("lichessHost", "lichess.org") ?: "lichess.org"
      val puzzle = fetchDailyPuzzleWithRetry(lichessHost)

      puzzleId = puzzle.id
      remoteViews.setViewVisibility(R.id.no_puzzle, View.GONE)
      remoteViews.setViewVisibility(R.id.puzzle_board_image, View.VISIBLE)

      val cornerRadiusPx = (12 * context.resources.displayMetrics.density).toInt()
      val boardSizePx = boardSizePx(context, appWidgetManager.getAppWidgetOptions(appWidgetId))

      val boardBitmap = getBoardBitmap(context, boardSizePx, puzzle.fen, puzzle.lastMove)
      val roundBoard = getRoundedCornerBitmap(boardBitmap, cornerRadiusPx)
      boardBitmap.recycle()
      remoteViews.setImageViewBitmap(R.id.puzzle_board_image, roundBoard)
      succeeded = true
    } catch (e: Exception) {
      // Log the exception itself: Log drops the stack trace of an UnknownHostException.
      Log.e("DailyPuzzleWidget", "Error updating widget $appWidgetId: $e", e)
      remoteViews.setViewVisibility(R.id.no_puzzle, View.VISIBLE)
      remoteViews.setViewVisibility(R.id.puzzle_board_image, View.GONE)
    }

    val clickPendingIntent = buildClickPendingIntent(context, appWidgetId, puzzleId)
    remoteViews.setOnClickPendingIntent(R.id.widget_container, clickPendingIntent)

    appWidgetManager.updateAppWidget(appWidgetId, remoteViews)
    return succeeded
  }

  private fun parseFen(fen : String): List<List<Char?>> {
    val position = fen.split(" ").firstOrNull() ?: fen
    val ranks = position.split('/')

    if(ranks.size != 8) return emptyList()

    return ranks.map { rank ->
      val row = mutableListOf<Char?>()
      for (ch in rank){
        val emptyCount = ch.digitToIntOrNull()
        if(emptyCount != null){
          repeat(emptyCount) { row.add(null) }
        } else {
          row.add(ch)
        }
      }
      row
    }
  }

  private fun sqrName(rankIndex: Int, fileIndex: Int): String {
    val files = "abcdefgh"
    return "${files[fileIndex]}${8 - rankIndex}"
  }

  private fun highlightedSquare(lastMove: String): Set<String?>{
    if(lastMove.length < 4) return emptySet()
    return setOf(lastMove.substring(0, 2), lastMove.substring(2, 4))
  }

  private fun getPieceBitmap(context: Context, piece : Char): Bitmap?{
    val color = if(piece.isUpperCase()) "w" else "b"
    val kind = piece.lowercaseChar()
    val name = "piece_cburnett_$color$kind"
    val resId = context.resources.getIdentifier(name, "drawable", context.packageName)

    if (resId == 0){
      Log.e("DailyPuzzleWidget", "Missing piece asset: $name")
      return null
    }
    return BitmapFactory.decodeResource(context.resources, resId)
  }

  // Side of the board in pixels: the largest multiple of 8 that fits in the widget once the
  // layout's padding, header and board margin are taken out.
  private fun boardSizePx(context: Context, options: Bundle): Int {
    val metrics = context.resources.displayMetrics
    val isPortrait =
      context.resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT
    // In portrait the widget is minWidth x maxHeight, in landscape maxWidth x minHeight. The
    // options can be 0 before the launcher has filled them in: fall back to the provider's
    // declared size (widget_daily_puzzle_info.xml).
    val widthDp = options.getInt(
      if (isPortrait) AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH
      else AppWidgetManager.OPTION_APPWIDGET_MAX_WIDTH
    ).takeIf { it > 0 } ?: 300
    val heightDp = options.getInt(
      if (isPortrait) AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT
      else AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT
    ).takeIf { it > 0 } ?: 330

    // Keep in sync with widget_daily_puzzle.xml: 14dp horizontal and 10dp vertical padding,
    // a header as tall as its 14sp title (16dp icon at least) and a 6dp margin above the board.
    val titlePx = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 14f, metrics) * 1.3f
    val headerPx = maxOf(16 * metrics.density, titlePx)
    val availableWidthPx = (widthDp - 2 * 14) * metrics.density
    val availableHeightPx = (heightDp - 2 * 10 - 6) * metrics.density - headerPx

    val sizePx = minOf(availableWidthPx, availableHeightPx).toInt()
    return maxOf(sizePx / 8, 1) * 8
  }

  private fun getBoardBitmap(
    context : Context,
    boardSizePx : Int,
    fen : String,
    lastMove: String,
  ) : Bitmap
  {
    val bitmap = Bitmap.createBitmap(boardSizePx, boardSizePx, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bitmap)

    val sqrSize = boardSizePx / 8
    val lightPaint = Paint().apply { color = Color.parseColor("#F0D9B6")}
    val darkPaint = Paint().apply { color = Color.parseColor("#B58863")}
    val highlightedPaint = Paint().apply { color = Color.parseColor("#809CC700")}


    val highlighted = highlightedSquare(lastMove)
    val boardData = parseFen(fen)
    val piecesInFen = boardData.flatten().filterNotNull().toSet()
    val pieceBitmap = piecesInFen.associateWith { getPieceBitmap(context, it) }
    val isWhiteToMove = fen.split(" ").getOrNull(1) == "w"
    val flipped = !isWhiteToMove


    for(row in 0 until 8){
      for(col in 0 until 8){
        val rankIndex = if (flipped) 7 - row else row
        val fileIndex = if (flipped) 7 - col else col
        val isLight = (rankIndex + fileIndex) % 2 == 0
        val left = col *sqrSize
        val top = row * sqrSize
        val sqrRect = Rect(left, top, left + sqrSize, top + sqrSize)
        val piece = boardData.getOrNull(rankIndex)?.getOrNull(fileIndex)
        val name = sqrName(rankIndex, fileIndex)

        canvas.drawRect(sqrRect, if (isLight) lightPaint else darkPaint)

        if(highlighted.contains(name)){
          canvas.drawRect(sqrRect, highlightedPaint)
        }

        if(piece != null){
          val pieceBitmap = pieceBitmap[piece]
          if(pieceBitmap != null){
            val inset = (sqrSize * 0.05f).toInt()
            val pieceRect = Rect(left + inset, top + inset, left + sqrSize - inset, top + sqrSize - inset)
            canvas.drawBitmap(pieceBitmap, null, pieceRect, null)
          }
        }
      }
    }
    pieceBitmap.values.forEach { it?.recycle() }
    return bitmap
  }

  private fun getRoundedCornerBitmap(bitmap: Bitmap, pixels: Int): Bitmap {
    val output = Bitmap.createBitmap(bitmap.width, bitmap.height, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(output)
    val paint = Paint().apply { isAntiAlias = true }
    val rect = Rect(0, 0, bitmap.width, bitmap.height)
    val rectF = RectF(rect)
    val roundPx = pixels.toFloat()

    canvas.drawARGB(0, 0, 0, 0)
    paint.color = Color.BLACK
    canvas.drawRoundRect(rectF, roundPx, roundPx, paint)
    paint.xfermode = PorterDuffXfermode(PorterDuff.Mode.SRC_IN)
    canvas.drawBitmap(bitmap, rect, rect, paint)

    return output
  }
}
