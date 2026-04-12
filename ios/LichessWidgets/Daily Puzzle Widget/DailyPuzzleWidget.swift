import AppIntents
import SwiftUI
import WidgetKit

struct DailyPuzzleSmallWidget: Widget {
    let kind = "DailyPuzzleSmallWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyPuzzleStaticProvider()) { entry in
            DailyPuzzleWidgetView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("Daily Puzzle")
        .description("Today's chess puzzle from lichess.org.")
        .supportedFamilies([.systemSmall])
    }
}

struct DailyPuzzleLargeWidget: Widget {
    let kind = "DailyPuzzleLargeWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: DailyPuzzleIntent.self,
            provider: DailyPuzzleProvider()
        ) { entry in
            DailyPuzzleWidgetView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("Daily Puzzle")
        .description("Today's chess puzzle from lichess.org.")
        .supportedFamilies([.systemLarge])
    }
}
