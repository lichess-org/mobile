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
import android.util.Log
import android.util.Xml
import android.view.View
import android.widget.RemoteViews
import org.lichess.mobileV2.R
import org.lichess.mobileV2.MainActivity
import org.xmlpull.v1.XmlPullParser
import java.io.InputStream
import java.net.HttpURLConnection
import java.net.URL
import java.util.concurrent.Callable
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import kotlin.concurrent.thread

class CommunityWidgetProvider: AppWidgetProvider() {

  data class CommunityEntryItem(
    val id: String,
    val title: String,
    val link: String,
    val imageUrl: String
  )

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

  override fun onAppWidgetOptionsChanged(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int,
    newOptions: Bundle
  ) {
    super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
    updateWidget(context, appWidgetManager, appWidgetId)
  }

  private fun fetchCommunity(): List<CommunityEntryItem> {
    try {
      val url = URL("https://lichess.org/blog/community.atom")
      val connection = url.openConnection() as HttpURLConnection
      connection.connectTimeout = 10000
      connection.readTimeout = 10000
      connection.setRequestProperty("Accept", "application/atom+xml")

      try {
        return connection.inputStream.use { stream -> parseCommunityFeed(stream)}
      } finally {
        connection.disconnect()
      }
    } catch (e: Exception){
      Log.e("CommunityWidget", "Error fetching community blog feed", e)
      return emptyList()
    }
  }

  private fun parseCommunityFeed(stream: InputStream): List<CommunityEntryItem>{
    val parser = Xml.newPullParser()
    parser.setFeature(XmlPullParser.FEATURE_PROCESS_NAMESPACES, false)
    parser.setInput(stream, null)

    val items = mutableListOf<CommunityEntryItem>()
    var inEntry = false
    var id = ""
    var title = ""
    var link = ""
    var imageUrl = ""

    var eventType = parser.eventType
    while( eventType != XmlPullParser.END_DOCUMENT){
      when(eventType){
        XmlPullParser.START_TAG -> when (parser.name){
        "entry" -> {
            inEntry = true
            id = ""; title = ""; link = ""; imageUrl = ""
          }
          "id" -> if(inEntry) id = parser.nextText()
          "title" -> if(inEntry) title = parser.nextText()
          "link" -> if(inEntry && parser.getAttributeValue(null, "rel") == "alternate"){
            link = parser.getAttributeValue(null, "href") ?: link
          }
          "media:thumbnail" -> if(inEntry){
            imageUrl = parser.getAttributeValue(null, "url") ?: imageUrl
          }
        }

        XmlPullParser.END_TAG -> if(parser.name == "entry"){
          inEntry = false
          if (id.isNotBlank() && title.isNotBlank()){
            items.add(CommunityEntryItem(id = id, title = title, imageUrl = imageUrl, link = link))
          }
        }
      }
      eventType = parser.next()
    }
    return items
  }

  private fun updateWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int){
    val remoteViews = RemoteViews(context.packageName, R.layout.widget_community)

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
    remoteViews.setOnClickPendingIntent(R.id.widget_header, homePendingIntent)

    try {
      val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
      val isKidMode = prefs.getBoolean("isKidMode", false)
      val items = if (isKidMode) emptyList() else fetchCommunity()

      remoteViews.removeAllViews(R.id.community_list)

      if(items.isEmpty()) {
        remoteViews.setViewVisibility(R.id.empty_view, View.VISIBLE)
        remoteViews.setViewVisibility(R.id.community_list, View.GONE)
      } else{
        remoteViews.setViewVisibility(R.id.empty_view, View.GONE)
        remoteViews.setViewVisibility(R.id.community_list, View.VISIBLE)

        val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
        val minWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
        val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)
        val maxHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT)
        val isPortrait = context.resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT
        val availableHeight = if (isPortrait && maxHeight > 0) maxHeight else minHeight
        val numRows = if(availableHeight == 0) 3 else ((availableHeight - 44) / 60).coerceIn(1, 4)
        val showThumbnail = minWidth == 0 || minWidth >= 200

        val displayItems = items.take(numRows)
        val sizePx = (48 * context.resources.displayMetrics.density).toInt()

        val bitmaps: List<Bitmap?> = if(showThumbnail) {
          val executor = Executors.newFixedThreadPool(displayItems.size.coerceAtLeast(1))
          try {
              val futures = displayItems.map { item ->
                executor.submit(Callable<Bitmap?> {
                  item.imageUrl.takeIf { it.isNotBlank() }?.let { fetchRoundBitmap(it, sizePx) }
                })
              }
            futures.map { future ->
              try {
                future.get(12, TimeUnit.SECONDS)
              } catch (e: Exception) {
                Log.e("CommunityWidget", "Error fetching thumbnail", e)
                future.cancel(true)
                null
              }
            }
          }
          finally {
              executor.shutdownNow()
          }
        } else {
          List(displayItems.size) {null}
        }

        displayItems.forEachIndexed { index, item ->
          val itemViews = RemoteViews(context.packageName, R.layout.widget_community_item)
          itemViews.setTextViewText(R.id.item_title, item.title)

          if(showThumbnail){
            itemViews.setViewVisibility(R.id.item_thumbnail_container, View.VISIBLE)
            val bitmap = bitmaps[index]
            if(bitmap != null){
              itemViews.setImageViewBitmap(R.id.item_thumbnail, bitmap)
            } else {
              setFallbackThumbnail(context, itemViews)
            }
          } else{
            itemViews.setViewVisibility(R.id.item_thumbnail_container, View.GONE)
          }

          val intent = Intent(Intent.ACTION_VIEW, Uri.parse(item.link)).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
          }
          val pendingIntent = PendingIntent.getActivity(
            context, appWidgetId * 10 + index, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
          )
          itemViews.setOnClickPendingIntent(R.id.community_item_container, pendingIntent)

          remoteViews.addView(R.id.community_list, itemViews)
        }
      }
    } catch (e: Exception){
      Log.e("CommunityWidget", "Error updating widget $appWidgetId", e)
    }
    appWidgetManager.updateAppWidget(appWidgetId, remoteViews)
  }

  private fun setFallbackThumbnail(context: Context, itemViews: RemoteViews) {
    itemViews.setImageViewResource(R.id.item_thumbnail, R.drawable.ic_stat_lichess_notification)
    val pad = (12 * context.resources.displayMetrics.density).toInt()
    itemViews.setViewPadding(R.id.item_thumbnail, pad, pad, pad, pad)
    itemViews.setInt(
      R.id.item_thumbnail, "setColorFilter", context.getColor(
        R.color.widget_text_secondary))
  }


  private fun fetchRoundBitmap(urlStr: String, sizePx: Int): Bitmap? {
    return try {
      val url = URL(urlStr)
      val connection = url.openConnection() as HttpURLConnection
      connection.connectTimeout = 5000
      connection.readTimeout = 5000

      try {
        connection.inputStream.use { stream ->
          val src = BitmapFactory.decodeStream(stream) ?: return null
          val square = cropToSquare(src, sizePx)
          val rounded = getRoundedCornerBitmap(square, (sizePx * 0.12f).toInt())
          if (square != src) square.recycle()
          if (src != rounded) src.recycle()
          rounded
        }
      } finally {
        connection.disconnect()
      }
    } catch (e: Exception) {
      Log.e("BroadcastWidget", "Failed to fetch thumbnail: $urlStr", e)
      null
    }
  }

  private fun cropToSquare(src: Bitmap, targetSize: Int): Bitmap {
    val size = minOf(src.width, src.height)
    val cropX = (src.width - size) / 2
    val cropY = (src.height - size) / 2
    val cropped = Bitmap.createBitmap(src, cropX, cropY, size, size)
    return if (size == targetSize) {
      cropped
    } else {
      Bitmap.createScaledBitmap(cropped, targetSize, targetSize, true).also {
        if (cropped != src) cropped.recycle()
      }
    }
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
