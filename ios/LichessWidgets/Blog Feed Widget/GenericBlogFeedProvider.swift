import SwiftUI
import WidgetKit

struct GenericBlogFeedProvider: TimelineProvider {
    let feed: BlogFeedChoice
    private let fetcher = BlogFeedFetcher()

    func placeholder(in context: Context) -> BlogFeedEntry {
        BlogFeedPlaceholder.entry(feed: feed, family: context.family)
    }

    func getSnapshot(in context: Context, completion: @escaping (BlogFeedEntry) -> Void) {
        if context.isPreview { completion(placeholder(in: context)); return }
        Task {
            completion(await fetcher.fetchEntry(feed: feed,
                                                username: nil,
                                                family: context.family))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BlogFeedEntry>) -> Void) {
        Task {
            let entry = await fetcher.fetchEntry(feed: feed,
                                                 username: nil,
                                                 family: context.family)
            let nextUpdate = BlogFeedFetcher.nextUpdateDate
            completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
        }
    }
}
