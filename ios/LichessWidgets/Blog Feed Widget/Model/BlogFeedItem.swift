import Foundation

struct BlogFeedItem: Identifiable {
    let id: String
    let title: String
    let url: String?
    let publishedDate: Date?
    let thumbnailData: Data?
    /// Asset catalog image name, used for static placeholder items only.
    let thumbnailImageName: String?
}
