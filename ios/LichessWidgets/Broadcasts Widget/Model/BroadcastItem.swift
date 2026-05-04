import Foundation

struct BroadcastItem: Identifiable {
    let id: String
    /// Group name when the broadcast belongs to a grouped tournament, otherwise the tour name.
    let title: String
    let roundName: String
    let tourSlug: String
    let roundSlug: String
    let isLive: Bool
    let startsAt: Date?
    let imageData: Data?
    /// Bundled asset name used as a static fallback in the widget gallery when no network image is available.
    let thumbnailImageName: String?

    /// Slugs are SEO-only; the round id is what actually drives routing.
    func broadcastURL() -> URL? {
        LichessAppGroup.lichessURL(
            path: "/broadcast/\(tourSlug)/\(roundSlug)/\(id)"
        )
    }
}
