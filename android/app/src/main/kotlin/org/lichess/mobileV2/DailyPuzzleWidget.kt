package org.lichess.mobileV2

import android.content.Context
import android.graphics.BitmapFactory
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.action.actionStartActivity
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.provideContent
import androidx.glance.currentState
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.ContentScale
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.width
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition

class DailyPuzzleWidget : GlanceAppWidget() {

    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override val sizeMode = SizeMode.Single

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            GlanceTheme {
                DailyPuzzleContent(context)
            }
        }
    }

    @Composable
    private fun DailyPuzzleContent(context: Context) {
        val state = currentState<HomeWidgetGlanceState>()
        val prefs = state.preferences
        val puzzleId = prefs.getString("puzzle_id", null)
        val sideToMove = prefs.getString("puzzle_side_to_move", null)
        val plays = prefs.getInt("puzzle_plays", 0)
        val imagePath = prefs.getString("puzzle_board_image", null)

        val intent = android.content.Intent(
            android.content.Intent.ACTION_VIEW,
            android.net.Uri.parse(
                if (puzzleId != null) "https://lichess.org/training/$puzzleId"
                else "https://lichess.org/training/daily"
            )
        )

        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .padding(8.dp)
                .clickable(actionStartActivity<MainActivity>()),
            contentAlignment = Alignment.Center,
        ) {
            if (puzzleId != null) {
                Column(
                    modifier = GlanceModifier.fillMaxSize(),
                    horizontalAlignment = Alignment.CenterHorizontally,
                ) {
                    Text(
                        text = "Daily Puzzle",
                        style = TextStyle(fontWeight = FontWeight.Bold, fontSize = 12.sp),
                    )
                    Spacer(modifier = GlanceModifier.height(4.dp))

                    if (imagePath != null) {
                        val file = java.io.File(imagePath)
                        if (file.exists()) {
                            val bitmap = BitmapFactory.decodeFile(file.absolutePath)
                            if (bitmap != null) {
                                Image(
                                    provider = ImageProvider(bitmap),
                                    contentDescription = "Chess board",
                                    contentScale = ContentScale.Fit,
                                )
                            }
                        }
                    }

                    Spacer(modifier = GlanceModifier.height(4.dp))

                    if (sideToMove != null) {
                        Text(
                            text = if (sideToMove == "white") "White to play" else "Black to play",
                            style = TextStyle(fontSize = 10.sp),
                        )
                    }
                }
            } else {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                ) {
                    Text(
                        text = "Daily Puzzle",
                        style = TextStyle(fontWeight = FontWeight.Bold, fontSize = 14.sp),
                    )
                    Spacer(modifier = GlanceModifier.height(8.dp))
                    Text(
                        text = "Open Lichess to load",
                        style = TextStyle(fontSize = 12.sp),
                    )
                }
            }
        }
    }
}
