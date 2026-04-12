import AppIntents
import SwiftUI
import WidgetKit

private let displayName = "Daily Puzzle"
private let widgetDescription = "Today's chess puzzle from lichess.org."

struct DailyPuzzleSmallWidget: Widget {
    let kind = "DailyPuzzleSmallWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyPuzzleStaticProvider()) { entry in
            DailyPuzzleWidgetView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .contentMarginsDisabled()
        .configurationDisplayName(displayName)
        .description(widgetDescription)
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
        .configurationDisplayName(displayName)
        .description(widgetDescription)
        .supportedFamilies([.systemLarge])
    }
}
