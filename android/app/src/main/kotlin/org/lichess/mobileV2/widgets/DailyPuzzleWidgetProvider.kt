package org.lichess.mobileV2.widgets

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
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
import android.text.format.DateUtils
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import java.util.concurrent.Callable
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import java.util.concurrent.TimeoutException
import kotlin.concurrent.thread
import org.lichess.mobileV2.R
import org.lichess.mobileV2.MainActivity



class DailyPuzzleWidgetProvider : AppWidgetProvider() {

  data class DailyPuzzle(
    val id: String,
    val fen: String,
    val lastMove: String
  )

  private fun fetchDailyPuzzle(lichessHost : String): DailyPuzzle? {
    try{
        val scheme = if (lichessHost.startsWith("localhost")) "http" else "https"
        val url = URL("$scheme://$lichessHost/api/puzzle/daily")

        val connection = url.openConnection() as HttpURLConnection
        connection.connectTimeout = 10000
        connection.readTimeout = 10000
        connection.setRequestProperty("Accept", "application/json")
      try{
        return connection.inputStream.use{ stream ->

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
    } catch (e: Exception){
       Log.e("DailyPuzzleWidget", "Error fetching daily puzzle", e)
       return null
    }
  }

  override fun onReceive(context: Context, intent: Intent) {
    val pendingResult = goAsync()
    thread {
      try {
        super.onReceive(context, intent)
      } finally {
        pendingResult.finish()
      }
    }
  }

  override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
    super.onUpdate(context, appWidgetManager, appWidgetIds)
    appWidgetIds.forEach { updateWidget(context, appWidgetManager, it) }
  }

  private fun updateWidget(context : Context, appWidgetManager : AppWidgetManager, appWidgetId : Int){
    val remoteViews = RemoteViews(context.packageName, R.layout.widget_daily_puzzle)

    val homeIntent = Intent(context, MainActivity::class.java).apply {
      action = Intent.ACTION_MAIN
      addCategory(Intent.CATEGORY_LAUNCHER)
      addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    }

    val homePendingIntent = PendingIntent.getActivity(
      context,
      appWidgetId,
      homeIntent,
      PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )
    remoteViews.setOnClickPendingIntent(R.id.widget_container, homePendingIntent)

    val dateStr = DateUtils.formatDateTime(
      context,
      System.currentTimeMillis(),
      DateUtils.FORMAT_SHOW_DATE or DateUtils.FORMAT_ABBREV_ALL
    )
    remoteViews.setTextViewText(R.id.daily_puzzle_date, dateStr)

    try {
      val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
      val lichessHost = prefs.getString("lichessHost", "lichess.org") ?: "lichess.org"
      val puzzle = fetchDailyPuzzle(lichessHost)

      if(puzzle == null){
        remoteViews.setViewVisibility(R.id.no_puzzle, View.VISIBLE)
        remoteViews.setViewVisibility(R.id.puzzle_board_image,  View.GONE)
      } else {
        remoteViews.setViewVisibility(R.id.no_puzzle, View.GONE)
        remoteViews.setViewVisibility(R.id.puzzle_board_image, View.VISIBLE)

        val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
        val minWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)


        val boardBitmap = getBoardBitmap(context, minWidth)
        remoteViews.setImageViewBitmap(R.id.puzzle_board_image, boardBitmap)

      }
    } catch (e: Exception) {
      Log.e("DailyPuzzleWidget", "Error updating widget $appWidgetId", e)
    }

    appWidgetManager.updateAppWidget(appWidgetId, remoteViews)
  }

  private fun parseFen(fen : String): List<List<Char?>>
  {

  }

  private fun getBoardBitmap(
    context : Context,
    minWidth : Int
  ) : Bitmap
  {
    val boardSizedPx = (minWidth * context.resources.displayMetrics.density).toInt()
    val bitmap = Bitmap.createBitmap(boardSizedPx, boardSizedPx, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bitmap)

    val sqrSize = boardSizedPx / 8
    val lightPaint = Paint().apply { color = Color.rgb(0xF0, 0xD9, 0xB6) }
    val darkPaint = Paint().apply { color = Color.rgb(0xB5, 0x88, 0x63) }

    for(row in 0 until 8){
      for(col in 0 until 8){
        val flipped = false
        val rankIndex = if (flipped) 7 - row else row
        val fileIndex = if (flipped) 7 - col else col
        val isLight = (rankIndex + fileIndex) % 2 == 0
        val left = fileIndex *sqrSize
        val top = rankIndex * sqrSize
        val sqrRect = Rect(left, top, left + sqrSize, top + sqrSize)

        canvas.drawRect(sqrRect, if(isLight) lightPaint else darkPaint)
      }
    }
    return bitmap
  }
}
