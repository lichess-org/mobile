import AppIntents
import SwiftUI
import WidgetKit

struct UserBlogFeedWidget: Widget {
    let kind = "UserBlogFeedWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: UserBlogFeedIntent.self,
                               provider: UserBlogFeedProvider()) { entry in
            BlogFeedWidgetEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("User Blog")
        .description("Shows the latest posts from a Lichess user blog.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct UserBlogFeedIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "User Blog"
    static var description = IntentDescription("Choose which Lichess user blog to display.")

    @Parameter(title: "Username", default: "Lichess")
    var username: String

    static var parameterSummary: some ParameterSummary {
        Summary("Show blog for \(\.$username)")
    }
}
