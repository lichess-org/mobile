import Foundation
import AppIntents

enum BlogFeedChoice: String, AppEnum {
    case officialBlog
    case newsFeed
    case communityBlog
    case userBlog

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Feed"

    static var caseDisplayRepresentations: [BlogFeedChoice: DisplayRepresentation] = [
        .officialBlog: "Official Blog",
        .newsFeed: "News Feed",
        .communityBlog: "Community Blog",
        .userBlog: "User Blog",
    ]

    func feedURL(username: String?) -> String? {
        switch self {
        case .officialBlog: return "https://lichess.org/@/Lichess/blog.atom"
        case .newsFeed: return "https://lichess.org/feed.atom"
        case .communityBlog: return "https://lichess.org/blog/community.atom"
        case .userBlog:
            guard let username, !username.isEmpty else { return nil }
            return "https://lichess.org/@/\(username)/blog.atom"
        }
    }
}
