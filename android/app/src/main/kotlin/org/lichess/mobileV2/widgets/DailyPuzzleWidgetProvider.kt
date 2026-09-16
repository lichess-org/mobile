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
        val cornerRadiusPx = (12 * context.resources.displayMetrics.density).toInt()

        val boardBitmap = getBoardBitmap(context, minWidth, puzzle.fen, puzzle.lastMove)
        val roundBoard = getRoundedCornerBitmap(boardBitmap, cornerRadiusPx)
        remoteViews.setImageViewBitmap(R.id.puzzle_board_image, roundBoard)

      }
    } catch (e: Exception) {
      Log.e("DailyPuzzleWidget", "Error updating widget $appWidgetId", e)
    }

    appWidgetManager.updateAppWidget(appWidgetId, remoteViews)
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
    if(resId == 0){
      Log.e("Daily Puzzle Widget", "Missing piece asset: $name")
      return null
    }
    return BitmapFactory.decodeResource(context.resources, resId)
  }

  private fun getBoardBitmap(
    context : Context,
    minWidth : Int,
    fen : String,
    lastMove: String
  ) : Bitmap
  {
    val boardSizedPx = (minWidth * context.resources.displayMetrics.density).toInt()
    val bitmap = Bitmap.createBitmap(boardSizedPx, boardSizedPx, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bitmap)

    val sqrSize = boardSizedPx / 8
    val lightPaint = Paint().apply { color = Color.rgb(0xF0, 0xD9, 0xB6) }
    val darkPaint = Paint().apply { color = Color.rgb(0xB5, 0x88, 0x63) }
    val highlightedPaint = Paint().apply { color = Color.argb(128, 156, 199, 0)}

    val highlighted = highlightedSquare(lastMove)
    val boardData = parseFen(fen)
    val isWhiteToMove = fen.split(" ").getOrNull(1) == "w"
    val flipped = !isWhiteToMove

    for(row in 0 until 8){
      for(col in 0 until 8){
        val rankIndex = if (flipped) 7 - row else row
        val fileIndex = if (flipped) 7 - col else col
        val isLight = (rankIndex + fileIndex) % 2 == 0
        val left = fileIndex *sqrSize
        val top = rankIndex * sqrSize
        val sqrRect = Rect(left, top, left + sqrSize, top + sqrSize)
        val piece = boardData.getOrNull(rankIndex)?.getOrNull(fileIndex)
        val name = sqrName(rankIndex, fileIndex)

        canvas.drawRect(sqrRect, if(isLight) lightPaint else darkPaint)
        if(highlighted.contains(name)){
          canvas.drawRect(sqrRect, highlightedPaint)
        }

        if(piece != null){
          val pieceBitmap = getPieceBitmap(context, piece)
          if(pieceBitmap != null){
            val inset = (sqrSize * 0.05f).toInt()
            val pieceRect = Rect(left + inset, top + inset, left + sqrSize -inset, top + sqrSize - inset)
            canvas.drawBitmap(pieceBitmap, null, pieceRect, null)
            pieceBitmap.recycle()
          }
        }
      }
    }
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
