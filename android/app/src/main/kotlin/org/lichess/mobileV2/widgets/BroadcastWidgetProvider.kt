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
import kotlin.concurrent.thread
import org.lichess.mobileV2.R
import org.lichess.mobileV2.MainActivity

class BroadcastWidgetProvider : AppWidgetProvider() {

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

    private fun updateWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        val remoteViews = RemoteViews(context.packageName, R.layout.widget_broadcast)
        
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
            val defaultHost = if (org.lichess.mobileV2.BuildConfig.DEBUG) "lichess.dev" else "lichess.org"
            val lichessHost = prefs.getString("lichessHost", defaultHost) ?: defaultHost
            val broadcasts = fetchBroadcasts(lichessHost)

            remoteViews.removeAllViews(R.id.broadcast_list)

            if (broadcasts.isEmpty()) {
                remoteViews.setViewVisibility(R.id.empty_view, View.VISIBLE)
                remoteViews.setViewVisibility(R.id.broadcast_list, View.GONE)
            } else {
                remoteViews.setViewVisibility(R.id.empty_view, View.GONE)
                remoteViews.setViewVisibility(R.id.broadcast_list, View.VISIBLE)

                val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
                val minWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
                val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)
                val maxHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT)
                val isPortrait = context.resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT
                
                val availableHeight = if (isPortrait && maxHeight > 0) maxHeight else minHeight

                val numRows = if (availableHeight == 0) 3 else ((availableHeight - 44) / 60).coerceIn(1, 4)
                val showThumbnails = minWidth == 0 || minWidth >= 200

                val displayItems = broadcasts.take(numRows)

                // Fetch all thumbnails concurrently, mirroring the iOS withTaskGroup approach.
                // Each item gets its own thread so all network requests run in parallel;
                // total wait time ≈ slowest single request instead of sum of all requests.
                val sizePx = (48 * context.resources.displayMetrics.density).toInt()
                val bitmaps: List<Bitmap?> = if (showThumbnails) {
                    val executor = Executors.newFixedThreadPool(displayItems.size.coerceAtLeast(1))
                    try {
                        val futures = displayItems.map { item ->
                            executor.submit(Callable<Bitmap?> {
                                item.imageUrl?.let { fetchRoundBitmap(it, sizePx) }
                            })
                        }
                        futures.map { future ->
                            try { future.get() } catch (e: Exception) {
                                Log.e("BroadcastWidget", "Error fetching thumbnail", e)
                                null
                            }
                        }
                    } finally {
                        executor.shutdown()
                    }
                } else {
                    List(displayItems.size) { null }
                }

                displayItems.forEachIndexed { index, item ->
                    val itemViews = RemoteViews(context.packageName, R.layout.widget_broadcast_item)
                    setupItemViews(context, itemViews, item, index, showThumbnails, bitmaps[index], lichessHost, appWidgetId)
                    remoteViews.addView(R.id.broadcast_list, itemViews)
                }
            }
            appWidgetManager.updateAppWidget(appWidgetId, remoteViews)
        } catch (e: Exception) {
            Log.e("BroadcastWidget", "Error updating widget $appWidgetId", e)
        }
    }

    private fun setupItemViews(
        context: Context,
        itemViews: RemoteViews,
        item: BroadcastItem,
        index: Int,
        showThumbnails: Boolean,
        bitmap: Bitmap?,  // Pre-fetched concurrently; null when thumbnails are disabled or fetch failed
        lichessHost: String,
        appWidgetId: Int
    ) {
        itemViews.setTextViewText(R.id.item_title, item.title)

        if (item.isLive) {
            itemViews.setViewVisibility(R.id.item_live_indicator, View.VISIBLE)
            itemViews.setTextViewText(R.id.item_status, "${context.getString(R.string.widget_live)} · ${item.roundName}")
            itemViews.setTextColor(R.id.item_status, context.getColor(R.color.widget_live_indicator))
        } else {
            itemViews.setViewVisibility(R.id.item_live_indicator, View.GONE)
            val statusText = if (item.startsAt > 0) {
                val dateStr = DateUtils.formatDateTime(
                    context,
                    item.startsAt,
                    DateUtils.FORMAT_SHOW_DATE or DateUtils.FORMAT_SHOW_TIME or DateUtils.FORMAT_ABBREV_ALL
                )
                "${item.roundName} · $dateStr"
            } else {
                item.roundName
            }
            itemViews.setTextViewText(R.id.item_status, statusText)
            itemViews.setTextColor(R.id.item_status, context.getColor(R.color.widget_text_secondary))
        }

        if (showThumbnails) {
            itemViews.setViewVisibility(R.id.item_thumbnail_container, View.VISIBLE)
            if (bitmap != null) {
                itemViews.setImageViewBitmap(R.id.item_thumbnail, bitmap)
            } else {
                setFallbackThumbnail(itemViews)
            }
        } else {
            itemViews.setViewVisibility(R.id.item_thumbnail_container, View.GONE)
        }

        val scheme = if (lichessHost.startsWith("localhost")) "http" else "https"
        val clickUri = Uri.Builder()
            .scheme(scheme)
            .encodedAuthority(lichessHost)
            .appendPath("broadcast")
            .appendPath(item.tourSlug)
            .appendPath(item.roundSlug)
            .appendPath(item.id)
            .build()
        val intent = Intent(Intent.ACTION_VIEW, clickUri).apply {
            setClass(context, MainActivity::class.java)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        
        val requestCode = appWidgetId * 10 + index
        val pendingIntent = PendingIntent.getActivity(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        itemViews.setOnClickPendingIntent(R.id.item_container, pendingIntent)
    }

    private fun setFallbackThumbnail(itemViews: RemoteViews) {
        itemViews.setImageViewResource(R.id.item_thumbnail, R.drawable.ic_stat_lichess_notification)
        itemViews.setViewPadding(R.id.item_thumbnail, 12, 12, 12, 12)
    }

    private fun fetchBroadcasts(lichessHost: String): List<BroadcastItem> {
        try {
            val scheme = if (lichessHost.startsWith("localhost")) "http" else "https"
            val url = URL("$scheme://$lichessHost/api/broadcast/top")
            val connection = url.openConnection() as HttpURLConnection
            connection.connectTimeout = 10000
            connection.readTimeout = 10000
            connection.setRequestProperty("Accept", "application/json")
            
            try {
                return connection.inputStream.use { stream ->
                    val jsonString = stream.bufferedReader().use { it.readText() }
                    val active = JSONObject(jsonString).getJSONArray("active")
                    
                    (0 until active.length()).map { i ->
                        val item = active.getJSONObject(i)
                        val tour = item.getJSONObject("tour")
                        val round = item.getJSONObject("round")
                        val id = item.optJSONObject("roundToLink")?.optString("id") ?: round.getString("id")
                        val title = item.optString("group").takeIf { !it.isNullOrBlank() } ?: tour.getString("name")

                        BroadcastItem(
                            id = id,
                            title = title,
                            roundName = round.getString("name"),
                            tourSlug = tour.getString("slug"),
                            roundSlug = round.getString("slug"),
                            isLive = round.optBoolean("ongoing", false),
                            startsAt = round.optLong("startsAt", 0),
                            imageUrl = tour.optString("image").takeIf { !it.isNullOrBlank() }
                        )
                    }
                }
            } finally {
                connection.disconnect()
            }
        } catch (e: Exception) {
            Log.e("BroadcastWidget", "Error fetching broadcasts", e)
            return emptyList()
        }
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

    data class BroadcastItem(
        val id: String,
        val title: String,
        val roundName: String,
        val tourSlug: String,
        val roundSlug: String,
        val isLive: Boolean,
        val startsAt: Long,
        val imageUrl: String?
    )
}

