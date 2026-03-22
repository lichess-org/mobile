import AppIntents
import FeedKit
import SwiftUI
import WidgetKit

struct BlogFeedWidget: Widget {
    let kind: String = "BlogFeedWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: BlogFeedIntent.self,
                               provider: BlogFeedProvider()) { entry in
            BlogFeedWidgetEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
                               .configurationDisplayName("Blog Feed")
                               .description("Shows the latest posts from a Lichess feed.")
                               .supportedFamilies([
                                .systemSmall,
                                .systemMedium,
                                .systemLarge
                               ])
    }
}

// MARK: - Widget Intent

struct BlogFeedIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Feed Selection"
    static var description = IntentDescription("Choose which Lichess feed to display.")

    @Parameter(title: "Feed", default: .officialBlog)
    var feed: BlogFeedChoice

    @Parameter(title: "Username")
    var username: String?

    static var parameterSummary: some ParameterSummary {
        When(\BlogFeedIntent.$feed, .equalTo, .userBlog) {
            Summary("Show \(\.$feed) for \(\.$username)")
        } otherwise: {
            Summary("Show \(\.$feed)")
        }
    }
}
