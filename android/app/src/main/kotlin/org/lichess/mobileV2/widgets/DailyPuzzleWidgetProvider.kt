package org.lichess.mobileV2.widgets

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
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
import android.text.format.DateUtils
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
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

  private fun updateWidget(context : Context, appWidgetManager : AppWidgetManager, appWidgetId : Int){
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
      val boardTheme = prefs.getString("boardTheme", "brown") ?: "brown"
      val pieceSet = prefs.getString("pieceSet", "cburnett") ?: "cburnett"
      val puzzle = fetchDailyPuzzle(lichessHost)

      if(puzzle == null){
        remoteViews.setViewVisibility(R.id.no_puzzle, View.VISIBLE)
        remoteViews.setViewVisibility(R.id.puzzle_board_image,  View.GONE)
      } else {
        puzzleId = puzzle.id
        remoteViews.setViewVisibility(R.id.no_puzzle, View.GONE)
        remoteViews.setViewVisibility(R.id.puzzle_board_image, View.VISIBLE)

        val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
        val minWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
        val cornerRadiusPx = (12 * context.resources.displayMetrics.density).toInt()

        val boardBitmap = getBoardBitmap(context, minWidth, puzzle.fen, puzzle.lastMove, boardTheme, pieceSet)
        val roundBoard = getRoundedCornerBitmap(boardBitmap, cornerRadiusPx)
        boardBitmap.recycle()
        remoteViews.setImageViewBitmap(R.id.puzzle_board_image, roundBoard)

      }
    } catch (e: Exception) {
      Log.e("DailyPuzzleWidget", "Error updating widget $appWidgetId", e)
      remoteViews.setTextViewText(R.id.no_puzzle, context.getString(R.string.widget_daily_puzzle_error))
      remoteViews.setViewVisibility(R.id.no_puzzle, View.VISIBLE)
      remoteViews.setViewVisibility(R.id.puzzle_board_image, View.GONE)
    }

    val clickPendingIntent = buildClickPendingIntent(context, appWidgetId, puzzleId)
    remoteViews.setOnClickPendingIntent(R.id.widget_container, clickPendingIntent)

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

  private fun getPieceBitmap(context: Context, piece : Char, pieceSet: String): Bitmap?{
    val color = if(piece.isUpperCase()) "w" else "b"
    val kind = piece.lowercaseChar()
    val setName = pieceSet.lowercase()

    fun load(set: String): Bitmap? {
      val name = "piece_${set}_$color$kind"
      val resId = context.resources.getIdentifier(name, "drawable", context.packageName)
      return if(resId != 0) BitmapFactory.decodeResource(context.resources, resId) else null
    }

    return load(setName) ?: if (setName != "cburnett"){
      Log.e("Daily Puzzle Widget", "Missing piece asset for set '$setName', falling back to cburnett")
      load("cburnett")
    } else {
      Log.e("Daily Puzzle Widget", "Missing piece asset: piece_cburnett_$color$kind")
      null
    }
  }

  private fun getBoardBitmap(
    context : Context,
    minWidth : Int,
    fen : String,
    lastMove: String,
    boardTheme: String,
    pieceSet : String
  ) : Bitmap
  {
    val boardSizedPx = (minWidth * context.resources.displayMetrics.density).toInt()
    val bitmap = Bitmap.createBitmap(boardSizedPx, boardSizedPx, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bitmap)

    val sqrSize = boardSizedPx / 8
    val colors = boardColorsFor(context, boardTheme)
    val lightPaint = Paint().apply { color = colors.light }
    val darkPaint = Paint().apply { color = colors.dark }
    val highlightedPaint = Paint().apply { color = colors.lastMove}

    val boardTextureBitmap = colors.board?.let { resName ->
      val resId = context.resources.getIdentifier(resName, "drawable", context.packageName)
      if(resId != 0) BitmapFactory.decodeResource(context.resources, resId) else null
    }
    if (boardTextureBitmap !=  null) {
      canvas.drawBitmap(boardTextureBitmap, null, Rect(0, 0, boardSizedPx, boardSizedPx), null)
      boardTextureBitmap.recycle()
    }

    val highlighted = highlightedSquare(lastMove)
    val boardData = parseFen(fen)
    val piecesInFen = boardData.flatten().filterNotNull().toSet()
    val pieceBitmap = piecesInFen.associateWith { getPieceBitmap(context, it, pieceSet) }
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

        if (boardTextureBitmap == null) {
          canvas.drawRect(sqrRect, if (isLight) lightPaint else darkPaint)
        }
        if(highlighted.contains(name)){
          canvas.drawRect(sqrRect, highlightedPaint)
        }

        if(piece != null){
          val pieceBitmap = pieceBitmap[piece]
          if(pieceBitmap != null){
            val inset = (sqrSize * 0.05f).toInt()
            val pieceRect = Rect(left + inset, top + inset, left + sqrSize -inset, top + sqrSize - inset)
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

  private data class BoardColors(
    val light: Int,
    val dark: Int,
    val lastMove: Int,
    val board: String?
  )

  private fun boardColorsFor(context: Context, themeName: String): BoardColors{
    val fallback = BoardColors(
      light = Color.parseColor("#F0D9B6"),
      dark = Color.parseColor("#B58863"),
      lastMove = Color.parseColor("#809CC700"),
      board = null
    )

    return try{
      context.resources.openRawResource(R.raw.board_themes).use { stream ->
        val json = JSONObject(stream.bufferedReader().use { it.readText()})
        val theme = json.optJSONObject(themeName) ?: json.optJSONObject("brown") ?: return fallback
        val board = theme.optString("board").takeIf { it.isNotBlank() }
        BoardColors(
          light = Color.parseColor(theme.getString("light")),
          dark = Color.parseColor(theme.getString("dark")),
          lastMove = Color.parseColor(theme.getString("lastMove")),
          board = board
        )
      }
    } catch (e : Exception){
      Log.e("DailyPuzzleWidget", "Eror loading board theme colors", e)
      fallback
    }
  }

}
