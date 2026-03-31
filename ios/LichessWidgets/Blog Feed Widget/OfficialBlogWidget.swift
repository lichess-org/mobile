import SwiftUI
import WidgetKit

struct OfficialBlogWidget: Widget {
    let kind = "OfficialBlogWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: GenericBlogFeedProvider(feed: .officialBlog)) { entry in
            BlogFeedWidgetEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Official Blog")
        .description("Latest posts from the Lichess official blog.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
