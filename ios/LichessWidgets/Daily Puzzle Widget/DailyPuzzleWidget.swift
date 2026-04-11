import AppIntents
import SwiftUI
import WidgetKit

struct DailyPuzzleWidget: Widget {
    let kind = "DailyPuzzleWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: DailyPuzzleIntent.self,
                               provider: DailyPuzzleProvider()) { entry in
            DailyPuzzleWidgetView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Daily Puzzle")
        .description("Today's chess puzzle from lichess.org.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
