import WidgetKit

struct UserBlogFeedProvider: AppIntentTimelineProvider {
    private let fetcher = BlogFeedFetcher()

    func placeholder(in context: Context) -> BlogFeedEntry {
        BlogFeedPlaceholder.entry(feed: .userBlog, username: "ChessNoob2009", family: context.family)
    }

    func snapshot(for configuration: UserBlogFeedIntent, in context: Context) async -> BlogFeedEntry {
        if context.isPreview { return placeholder(in: context) }
        if LichessAppGroup.isKidModeActive {
            return .kidMode(feed: .userBlog, username: configuration.username)
        }
        return await fetcher.fetchEntry(feed: .userBlog,
                                        username: configuration.username,
                                        family: context.family)
    }

    func timeline(for configuration: UserBlogFeedIntent, in context: Context) async -> Timeline<BlogFeedEntry> {
        if LichessAppGroup.isKidModeActive {
            return Timeline(entries: [.kidMode(feed: .userBlog, username: configuration.username)], policy: .never)
        }
        let entry = await fetcher.fetchEntry(feed: .userBlog,
                                             username: configuration.username,
                                             family: context.family)
        let nextUpdate = BlogFeedFetcher.nextUpdateDate
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }

}
