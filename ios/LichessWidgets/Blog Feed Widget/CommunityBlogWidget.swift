import SwiftUI
import WidgetKit

struct CommunityBlogWidget: Widget {
    let kind = "CommunityBlogWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: GenericBlogFeedProvider(feed: .communityBlog)) { entry in
            BlogFeedWidgetEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Community Blog")
        .description("Latest posts from the Lichess community blog.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
