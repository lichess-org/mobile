import WidgetKit

struct BlogFeedProvider: AppIntentTimelineProvider {
    private let fetcher = BlogFeedFetcher()

    func placeholder(in context: Context) -> BlogFeedEntry {
        BlogFeedPlaceholder.entry(feed: .userBlog, username: "ChessNoob2009", family: context.family)
    }

    func snapshot(for configuration: UserBlogFeedIntent, in context: Context) async -> BlogFeedEntry {
        if context.isPreview { return placeholder(in: context) }
        return await fetcher.fetchEntry(feed: .userBlog,
                                        username: configuration.username,
                                        family: context.family)
    }

    func timeline(for configuration: UserBlogFeedIntent, in context: Context) async -> Timeline<BlogFeedEntry> {
        let entry = await fetcher.fetchEntry(feed: .userBlog,
                                             username: configuration.username,
                                             family: context.family)
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
}
