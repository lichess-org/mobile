import Foundation
import WidgetKit

/// Static placeholder data shown in the widget gallery and while a widget loads.
/// Images reuse PlaceholderThumbnail1–4 from the asset catalog; swap them per feed when ready.
enum BlogFeedPlaceholder {
    static func entry(feed: BlogFeedChoice, username: String? = nil, family: WidgetFamily) -> BlogFeedEntry {
        BlogFeedEntry(
            date: .now,
            feed: feed,
            username: username,
            items: Array(items(for: feed).prefix(family.maxItems)),
            error: nil
        )
    }

    private static func items(for feed: BlogFeedChoice) -> [BlogFeedItem] {
        switch feed {
        case .officialBlog: return officialBlogItems
        case .communityBlog: return communityBlogItems
        case .userBlog: return userBlogItems
        }
    }

    // MARK: Official Blog

    private static let officialBlogItems: [BlogFeedItem] = [
        BlogFeedItem(id: "1", title: "Queens' Online Chess Festival",
                     url: nil, publishedDate: daysAgo(1), author: nil,
                     thumbnailData: nil, thumbnailImageName: "OfficialBlogPlaceholderImage1"),
        BlogFeedItem(id: "2", title: "ChessMood 20/20 Grand Prix 2026",
                     url: nil, publishedDate: daysAgo(5), author: nil,
                     thumbnailData: nil, thumbnailImageName: "OfficialBlogPlaceholderImage2"),
        BlogFeedItem(id: "3", title: "Streamer Arenas Announcement",
                     url: nil, publishedDate: daysAgo(9), author: nil,
                     thumbnailData: nil, thumbnailImageName: "OfficialBlogPlaceholderImage3"),
        BlogFeedItem(id: "4", title: "Titled Arenas Announcement",
                     url: nil, publishedDate: daysAgo(23), author: nil,
                     thumbnailData: nil, thumbnailImageName: "OfficialBlogPlaceholderImage4"),
    ]

    // MARK: Community Blog

    private static let communityBlogItems: [BlogFeedItem] = [
        BlogFeedItem(id: "1", title: "How I Climbed from 1200 to 1800 in One Year",
                     url: nil, publishedDate: daysAgo(1), author: "MindfulPawn",
                     thumbnailData: nil, thumbnailImageName: "CommunityBlogPlaceholderImage1"),
        BlogFeedItem(id: "2", title: "The Most Instructive Endgame I Ever Played",
                     url: nil, publishedDate: daysAgo(3), author: "EndgameEnthusiast",
                     thumbnailData: nil, thumbnailImageName: "CommunityBlogPlaceholderImage2"),
        BlogFeedItem(id: "3", title: "Opening Preparation for Club Players",
                     url: nil, publishedDate: daysAgo(6), author: "TheoryBuilder",
                     thumbnailData: nil, thumbnailImageName: "CommunityBlogPlaceholderImage3"),
        BlogFeedItem(id: "4", title: "My First Over-the-Board Tournament",
                     url: nil, publishedDate: daysAgo(10), author: "ChessNewcomer",
                     thumbnailData: nil, thumbnailImageName: "CommunityBlogPlaceholderImage4"),
    ]

    // MARK: User Blog

    private static let userBlogItems: [BlogFeedItem] = [
        BlogFeedItem(id: "1", title: "My Best Games of the Month",
                     url: nil, publishedDate: daysAgo(2), author: nil,
                     thumbnailData: nil, thumbnailImageName: "UserBlogPlaceholderImage1"),
        BlogFeedItem(id: "2", title: "Annotated: Sicilian Dragon Deep Dive",
                     url: nil, publishedDate: daysAgo(7), author: nil,
                     thumbnailData: nil, thumbnailImageName: "UserBlogPlaceholderImage2"),
        BlogFeedItem(id: "3", title: "Tournament Report: City Open 2026",
                     url: nil, publishedDate: daysAgo(14), author: nil,
                     thumbnailData: nil, thumbnailImageName: "UserBlogPlaceholderImage3"),
        BlogFeedItem(id: "4", title: "Endgame Studies I Recommend",
                     url: nil, publishedDate: daysAgo(21), author: nil,
                     thumbnailData: nil, thumbnailImageName: "UserBlogPlaceholderImage4"),
    ]

    private static func daysAgo(_ days: Int) -> Date? {
        Calendar.current.date(byAdding: .day, value: -days, to: .now)
    }
}
