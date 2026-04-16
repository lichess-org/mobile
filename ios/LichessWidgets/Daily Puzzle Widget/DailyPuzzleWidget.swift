import SwiftUI
import WidgetKit

private let displayName = "Daily Puzzle"
private let widgetDescription = "Today's chess puzzle from lichess.org."

struct DailyPuzzleWidget: Widget {
    let kind = "DailyPuzzleLargeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyPuzzleProvider()) { entry in
            DailyPuzzleWidgetView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .contentMarginsDisabled()
        .configurationDisplayName(displayName)
        .description(widgetDescription)
        .supportedFamilies([.systemLarge])
    }
}
