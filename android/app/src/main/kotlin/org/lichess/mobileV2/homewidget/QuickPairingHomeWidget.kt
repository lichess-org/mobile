package org.lichess.mobileV2.homewidget

import android.content.Context
import android.net.Uri
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.color.ColorProvider
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import es.antonborri.home_widget.actionStartActivity
import org.lichess.mobileV2.MainActivity

private const val TITLE_KEY = "widget_title"
private const val PRIMARY_TEXT_KEY = "widget_primary_text"
private const val SECONDARY_TEXT_KEY = "widget_secondary_text"
private const val LAUNCH_URI_KEY = "widget_launch_uri"
private const val DEFAULT_TITLE = "Quick pairing"
private const val DEFAULT_PRIMARY_TEXT = "5+0"
private const val DEFAULT_SECONDARY_TEXT = "Casual"
private const val DEFAULT_LAUNCH_URI =
    "org.lichess.mobile://home-widget/start-last-pairing?homeWidget=1"

class QuickPairingHomeWidget : GlanceAppWidget() {
  override val stateDefinition = HomeWidgetGlanceStateDefinition()

  override suspend fun provideGlance(context: Context, id: GlanceId) {
    provideContent {
      QuickPairingHomeWidgetContent(context = context, currentState = currentState())
    }
  }
}

@Composable
private fun QuickPairingHomeWidgetContent(
    context: Context,
    currentState: HomeWidgetGlanceState,
) {
  val data = currentState.preferences
  val title = data.getString(TITLE_KEY, DEFAULT_TITLE)!!
  val primaryText = data.getString(PRIMARY_TEXT_KEY, DEFAULT_PRIMARY_TEXT)!!
  val secondaryText = data.getString(SECONDARY_TEXT_KEY, DEFAULT_SECONDARY_TEXT)!!
  val launchUri = data.getString(LAUNCH_URI_KEY, DEFAULT_LAUNCH_URI)!!

  Box(
      modifier =
          GlanceModifier.fillMaxSize()
              .background(Color(0xFFF7F3E8))
              .padding(16.dp)
              .clickable(onClick = actionStartActivity<MainActivity>(context, Uri.parse(launchUri))),
      contentAlignment = Alignment.CenterStart,
  ) {
    Column(modifier = GlanceModifier.fillMaxSize(), verticalAlignment = Alignment.Vertical.CenterVertically) {
      Text(
          text = "lichess.org",
          style =
              TextStyle(
                  color = ColorProvider(day = Color(0xFF6B5C3E), night = Color(0xFF6B5C3E)),
                  fontSize = 12.sp,
              ),
      )
      Spacer(modifier = GlanceModifier.height(6.dp))
      Text(
          text = title,
          style =
              TextStyle(
                  color = ColorProvider(day = Color(0xFF15120D), night = Color(0xFF15120D)),
                  fontSize = 18.sp,
                  fontWeight = FontWeight.Medium,
              ),
      )
      Spacer(modifier = GlanceModifier.height(8.dp))
      Text(
          text = primaryText,
          style =
              TextStyle(
                  color = ColorProvider(day = Color(0xFF15120D), night = Color(0xFF15120D)),
                  fontSize = 28.sp,
                  fontWeight = FontWeight.Bold,
              ),
      )
      Spacer(modifier = GlanceModifier.height(4.dp))
      Text(
          text = secondaryText,
          style =
              TextStyle(
                  color = ColorProvider(day = Color(0xFF514733), night = Color(0xFF514733)),
                  fontSize = 14.sp,
              ),
      )
    }
  }
}
