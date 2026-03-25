import SwiftUI
import WidgetKit

struct OfficialBlogWidget: Widget {
    let kind = "OfficialBlogWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: GenericBlogFeedProvider(feed: .officialBlog)) { entry in
            BlogFeedWidgetEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Official Blog")
        .description("Latest posts from the Lichess official blog.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct CommunityBlogWidget: Widget {
    let kind = "CommunityBlogWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: GenericBlogFeedProvider(feed: .communityBlog)) { entry in
            BlogFeedWidgetEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Community Blog")
        .description("Latest posts from the Lichess community blog.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Provider

private struct GenericBlogFeedProvider: TimelineProvider {
    let feed: BlogFeedChoice
    private let fetcher = BlogFeedFetcher()

    func placeholder(in context: Context) -> BlogFeedEntry {
        fetcher.placeholder(feed: feed, family: context.family)
    }

    func getSnapshot(in context: Context, completion: @escaping (BlogFeedEntry) -> Void) {
        if context.isPreview { completion(placeholder(in: context)); return }
        Task { completion(await fetcher.fetchEntry(feed: feed, username: nil, family: context.family)) }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BlogFeedEntry>) -> Void) {
        Task {
            let entry = await fetcher.fetchEntry(feed: feed, username: nil, family: context.family)
            let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
            completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
        }
    }
}
