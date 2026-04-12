import UIKit
import WidgetKit

struct BroadcastFetcher {
    // Broadcasts change status frequently; refresh every 15 minutes.
    static var nextUpdateDate: Date {
        Calendar.current.date(byAdding: .minute, value: 15, to: .now)!
    }

    // Tier thresholds (mirrors lila: PRIVATE=-1, NORMAL=3, HIGH=4, BEST=5).
    private static let topTierThreshold = 4

    func fetchEntry(filter: BroadcastFilterOption, family: WidgetFamily) async -> BroadcastEntry {
        let (items, error) = await fetchBroadcasts(filter: filter, family: family)
        return BroadcastEntry(date: .now, items: items, filter: filter, error: error)
    }

    // MARK: - Private

    private func fetchBroadcasts(
        filter: BroadcastFilterOption,
        family: WidgetFamily
    ) async -> (items: [BroadcastItem], error: String?) {
        guard let url = LichessAppGroup.lichessURL(path: "/api/broadcast/top") else {
            return ([], "Could not build request URL")
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(APIResponse.self, from: data)

            var broadcasts = response.active
            if filter == .top {
                broadcasts = broadcasts.filter { ($0.tour.tier ?? 0) >= Self.topTierThreshold }
            }

            let maxCount = family.broadcastMaxItems
            let hasThumbnails = family.broadcastShowsThumbnails
            let items = await withTaskGroup(of: (Int, BroadcastItem).self) { group in
                for (index, broadcast) in broadcasts.prefix(maxCount).enumerated() {
                    group.addTask {
                        let imageData: Data? = if hasThumbnails, let imgURL = broadcast.tour.image {
                            await fetchThumbnail(urlString: imgURL, family: family)
                        } else {
                            nil
                        }
                        let roundId = broadcast.roundToLink?.id ?? broadcast.round.id
                        let isLive = broadcast.round.ongoing ?? false
                        let startsAt: Date? = broadcast.round.startsAt.map {
                            Date(timeIntervalSince1970: Double($0) / 1000)
                        }
                        return (index, BroadcastItem(
                            id: roundId,
                            title: broadcast.group ?? broadcast.tour.name,
                            roundName: broadcast.round.name,
                            tourSlug: broadcast.tour.slug,
                            roundSlug: broadcast.round.slug,
                            isLive: isLive,
                            startsAt: startsAt,
                            imageData: imageData,
                            tier: broadcast.tour.tier
                        ))
                    }
                }
                var results: [(Int, BroadcastItem)] = []
                for await result in group { results.append(result) }
                return results.sorted { $0.0 < $1.0 }.map(\.1)
            }
            return (items, nil)
        } catch {
            return ([], error.localizedDescription)
        }
    }

    private func fetchThumbnail(urlString: String, family: WidgetFamily) async -> Data? {
        guard let url = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let source = UIImage(data: data)
        else { return nil }
        let scale = UITraitCollection.current.displayScale
        let spec = family.broadcastThumbnailSpec
        let size = CGSize(width: spec.width * scale, height: spec.height * scale)
        return await source.byPreparingThumbnail(ofSize: size)?.jpegData(compressionQuality: 0.85)
    }
}

// MARK: - Widget family helpers

extension WidgetFamily {
    var broadcastMaxItems: Int {
        switch self {
        case .systemSmall: return 1
        case .systemMedium: return 2
        default: return 4
        }
    }

    var broadcastShowsThumbnails: Bool {
        switch self {
        case .systemSmall: return false
        default: return true
        }
    }

    /// Square thumbnail spec used for broadcast images.
    var broadcastThumbnailSpec: (width: CGFloat, height: CGFloat) {
        (width: 56, height: 56)
    }
}

// MARK: - Decodable API types

private struct APIResponse: Decodable {
    let active: [APIBroadcast]
}

private struct APIBroadcast: Decodable {
    let tour: APITour
    let round: APIRound
    let group: String?
    let roundToLink: APIRoundRef?

    struct APITour: Decodable {
        let id: String
        let name: String
        let slug: String
        let image: String?
        let tier: Int?
    }

    struct APIRound: Decodable {
        let id: String
        let name: String
        let slug: String
        let ongoing: Bool?
        let finished: Bool?
        let startsAt: Int64?
    }

    struct APIRoundRef: Decodable {
        let id: String
    }
}
