import Foundation
import WidgetKit

/// Static placeholder data shown in the widget gallery and while a widget loads.
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
        BlogFeedItem(id: "1",
                     title: "Lichess Mobile App Update",
                     url: nil,
                     publishedDate: daysAgo(1),
                     author: nil,
                     thumbnailData: nil,
                     thumbnailImageName: "OfficialBlogPlaceholderImage1"),
        BlogFeedItem(id: "2",
                     title: "Queens' Online Chess Festival",
                     url: nil,
                     publishedDate: daysAgo(31),
                     author: nil,
                     thumbnailData: nil,
                     thumbnailImageName: "OfficialBlogPlaceholderImage2"),
        BlogFeedItem(id: "3",
                     title: "Announcing the ChessMood 20/20 Grand Prix 2026",
                     url: nil,
                     publishedDate: daysAgo(35),
                     author: nil,
                     thumbnailData: nil,
                     thumbnailImageName: "OfficialBlogPlaceholderImage3"),
        BlogFeedItem(id: "4",
                     title: "Streamer Arenas Announcement — February to July 2026",
                     url: nil,
                     publishedDate: daysAgo(39),
                     author: nil,
                     thumbnailData: nil,
                     thumbnailImageName: "OfficialBlogPlaceholderImage4"),
    ]

    // MARK: Community Blog

    private static let communityBlogItems: [BlogFeedItem] = [
        BlogFeedItem(id: "1",
                     title: "How To Analyse Your Game Like a 2000-Rated Player",
                     url: nil,
                     publishedDate: daysAgo(0),
                     author: "VihaanRathodBhuj",
                     thumbnailData: nil,
                     thumbnailImageName: "CommunityBlogPlaceholderImage1"),
        BlogFeedItem(id: "2",
                     title: "What a Figure Skater Can Teach You About Chess Improvement",
                     url: nil,
                     publishedDate: daysAgo(0),
                     author: "FM MattyDPerrine",
                     thumbnailData: nil,
                     thumbnailImageName: "CommunityBlogPlaceholderImage2"),
        BlogFeedItem(id: "3", title: "Slow Growth in Chess: The Truth Most People Don't Want to Hear",
                     url: nil, publishedDate: daysAgo(2),
                     author: "IM nikhildixit",
                     thumbnailData: nil,
                     thumbnailImageName: "CommunityBlogPlaceholderImage3"),
        BlogFeedItem(id: "4", title: "Everyone's favorite: A modern Kortchnoi seeking to change his history",
                     url: nil,
                     publishedDate: daysAgo(0),
                     author: "FM Reynold9402",
                     thumbnailData: nil,
                     thumbnailImageName: "CommunityBlogPlaceholderImage4"),
    ]

    // MARK: User Blog

    private static let userBlogItems: [BlogFeedItem] = [
        BlogFeedItem(id: "1",
                     title: "Did you know Lichess can do this? Opening Explorer and Tablebase",
                     url: nil,
                     publishedDate: daysAgo(2),
                     author: nil,
                     thumbnailData: nil,
                     thumbnailImageName: "UserBlogPlaceholderImage1"),
        BlogFeedItem(id: "2",
                     title: "Annotated: Sicilian Accelerated Dragon Deep Dive",
                     url: nil,
                     publishedDate: daysAgo(7),
                     author: nil,
                     thumbnailData: nil, thumbnailImageName: "UserBlogPlaceholderImage2"),
        BlogFeedItem(id: "3",
                     title: "Tournament Report: City Open 2026",
                     url: nil,
                     publishedDate: daysAgo(14),
                     author: nil,
                     thumbnailData: nil, thumbnailImageName: "UserBlogPlaceholderImage3"),
        BlogFeedItem(id: "4",
                     title: "Endgame Studies I Recommend",
                     url: nil,
                     publishedDate: daysAgo(21),
                     author: nil,
                     thumbnailData: nil,
                     thumbnailImageName: "UserBlogPlaceholderImage4"),
    ]

    private static func daysAgo(_ days: Int) -> Date? {
        Calendar.current.date(byAdding: .day, value: -days, to: .now)
    }
}
