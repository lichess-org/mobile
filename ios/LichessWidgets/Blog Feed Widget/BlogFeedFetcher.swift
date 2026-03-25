import FeedKit
import UIKit
import WidgetKit
internal import XMLKit

struct BlogFeedFetcher {
    static var nextUpdateDate: Date {
        Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
    }

    private func fetchThumbnail(urlString: String, spec: BlogThumbnailSpec) async -> Data? {
        guard let url = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let source = UIImage(data: data)
        else { return nil }
        let scale = UITraitCollection.current.displayScale
        let size = CGSize(width: spec.width * scale, height: spec.height * scale)
        return await source.byPreparingThumbnail(ofSize: size)?.jpegData(compressionQuality: 0.85)
    }

    func fetchEntry(feed: BlogFeedChoice, username: String?, family: WidgetFamily) async -> BlogFeedEntry {
        let (items, error) = await fetchFeed(feed: feed, username: username, family: family)
        return BlogFeedEntry(date: .now, feed: feed, username: username, items: items, error: error)
    }

    private func fetchFeed(feed: BlogFeedChoice,
                           username: String?,
                           family: WidgetFamily) async -> (items: [BlogFeedItem], error: String?) {
        guard let urlString = feed.feedURL(username: username) else {
            return ([], "Enter a username in widget settings")
        }
        do {
            guard case .atom(let atomFeed) = try await Feed(urlString: urlString) else {
                return ([], "Unexpected feed format")
            }
            let thumbSpec = family.thumbnailSpec
            let items = await withTaskGroup(of: (Int, BlogFeedItem).self) { group in
                for (index, entry) in (atomFeed.entries ?? []).prefix(family.maxItems).enumerated() {
                    group.addTask {
                        let thumbData: Data? = if let thumbSpec,
                                                  let thumbURL = entry.media?.thumbnails?.first?.attributes?.url {
                            await fetchThumbnail(urlString: thumbURL, spec: thumbSpec)
                        } else {
                            nil
                        }
                        let entryURL = entry.links?
                            .first(where: { $0.attributes?.rel == "alternate" })?
                            .attributes?.href
                            ?? entry.links?.first?.attributes?.href
                        return (index, BlogFeedItem(
                            id: entry.id ?? "\(index)",
                            title: entry.title ?? "Untitled",
                            url: entryURL,
                            publishedDate: entry.published,
                            author: entry.authors?.first?.name,
                            thumbnailData: thumbData,
                            thumbnailImageName: nil
                        ))
                    }
                }
                var results: [(Int, BlogFeedItem)] = []
                for await result in group { results.append(result) }
                return results.sorted { $0.0 < $1.0 }.map(\.1)
            }
            return (items, nil)
        } catch {
            return ([], error.localizedDescription)
        }
    }
}
