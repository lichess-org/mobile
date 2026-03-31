package org.lichess.mobileV2.homewidget

import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver

class QuickPairingHomeWidgetReceiver : HomeWidgetGlanceWidgetReceiver<QuickPairingHomeWidget>() {
  override val glanceAppWidget = QuickPairingHomeWidget()
}
