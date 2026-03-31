import Foundation

enum BlogFeedChoice: String {
    case officialBlog
    case communityBlog
    case userBlog

    var displayName: String {
        switch self {
        case .officialBlog: return "Official Blog"
        case .communityBlog: return "Community Blog"
        case .userBlog: return "User Blog"
        }
    }

    func feedURL(username: String?) -> String? {
        switch self {
        case .officialBlog: return "https://lichess.org/@/Lichess/blog.atom"
        case .communityBlog: return "https://lichess.org/blog/community.atom"
        case .userBlog:
            guard let username, !username.isEmpty else { return nil }
            return "https://lichess.org/@/\(username)/blog.atom"
        }
    }
}
