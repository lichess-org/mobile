import WidgetKit

struct BlogFeedEntry: TimelineEntry {
    let date: Date
    let feed: BlogFeedChoice
    let username: String?
    let items: [BlogFeedItem]
    let error: String?
    let isKidMode: Bool

    static func kidMode(feed: BlogFeedChoice, username: String? = nil) -> BlogFeedEntry {
        BlogFeedEntry(date: .now, feed: feed, username: username, items: [], error: nil, isKidMode: true)
    }

    /// Display name for the widget header.
    var headerTitle: String {
        if feed == .userBlog, let username, !username.isEmpty {
            return "@\(username)"
        }
        return feed.displayName
    }
}
