import WidgetKit
import AppIntents

struct BlogFeedEntry: TimelineEntry {
    let date: Date
    let feed: BlogFeedChoice
    let username: String?
    let items: [BlogFeedItem]
    let error: String?
    
    /// Display name for the widget header.
    var headerTitle: String {
        if feed == .userBlog, let username, !username.isEmpty {
            return "@\(username)"
        }
        return BlogFeedChoice.caseDisplayRepresentations[feed].map {
            String(localized: $0.title)
        } ?? feed.rawValue
    }
}
