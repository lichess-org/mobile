import Foundation

struct BroadcastItem: Identifiable {
    let id: String          // round ID used for linking
    let title: String       // group name or tour name
    let roundName: String
    let tourSlug: String
    let roundSlug: String
    let isLive: Bool
    let startsAt: Date?
    let imageData: Data?    // tournament thumbnail fetched from the API
    let thumbnailImageName: String? // bundled asset name used as static fallback (widget gallery)

    /// Builds the lichess.org broadcast URL for this item.
    /// Slugs are SEO-only so the actual round id drives routing.
    func broadcastURL() -> URL? {
        LichessAppGroup.lichessURL(
            path: "/broadcast/\(tourSlug)/\(roundSlug)/\(id)"
        )
    }
}
