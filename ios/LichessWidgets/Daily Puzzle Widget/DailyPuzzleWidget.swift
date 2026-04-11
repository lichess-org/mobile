import SwiftUI
import WidgetKit

struct DailyPuzzleWidget: Widget {
    let kind = "DailyPuzzleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyPuzzleProvider()) { entry in
            DailyPuzzleWidgetView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Daily Puzzle")
        .description("Today's chess puzzle from lichess.org.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
