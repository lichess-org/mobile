import WidgetKit
import UIKit
import FeedKit
internal import XMLKit

struct BlogFeedProvider: AppIntentTimelineProvider {
    private func fetchThumbnail(urlString: String,
                                spec: BlogThumbnailSpec) async -> Data? {
        guard let url = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let source = UIImage(data: data)
        else { return nil }
        let size = CGSize(width: spec.width * 3, height: spec.height * 3) // (x3 for Retina Display)
        return await source.byPreparingThumbnail(ofSize: size)?.jpegData(compressionQuality: 0.85)
    }

    private func fetchFeed(for configuration: BlogFeedIntent,
                           family: WidgetFamily) async -> (items: [BlogFeedItem], error: String?) {
        guard let urlString = configuration.feed.feedURL(username: configuration.username) else {
            return ([], "Enter a username in widget settings")
        }
        do {
            guard case .atom(let atomFeed) = try await Feed(urlString: urlString) else {
                return ([], "Unexpected feed format")
            }
            let thumbSpec = family.thumbnailSpec
            let items = await withTaskGroup(of: (Int, BlogFeedItem).self) { group in
                for (index, entry) in (atomFeed.entries ?? [])
                    .prefix(family.maxItems)
                    .enumerated() {
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

    private func fetchEntry(for configuration: BlogFeedIntent,
                            family: WidgetFamily) async -> BlogFeedEntry {
        let (items, error) = await fetchFeed(for: configuration, family: family)
        return BlogFeedEntry(date: .now,
                             feed: configuration.feed,
                             username: configuration.username,
                             items: items,
                             error: error)
    }

    func placeholder(in context: Context) -> BlogFeedEntry {
        let allItems: [BlogFeedItem] = [
            BlogFeedItem(id: "1",
                         title: "Queens' Online Chess Festival",
                         url: "https://lichess.org/@/Lichess/blog/queens-online-chess-festival/YwpMPp8y",
                         publishedDate: Calendar.current.date(byAdding: .day, value: -27, to: .now),
                         thumbnailData: nil,
                         thumbnailImageName: "placeholder_thumb_1"),
            BlogFeedItem(id: "2",
                         title: "ChessMood 20/20 Grand Prix 2026",
                         url: "https://lichess.org/@/Lichess/blog/announcing-the-chessmood-2020-grand-prix-2026/Y7sU143E",
                         publishedDate: Calendar.current.date(byAdding: .day, value: -31, to: .now),
                         thumbnailData: nil,
                         thumbnailImageName: "placeholder_thumb_2"),
            BlogFeedItem(id: "3",
                         title: "Streamer Arenas Announcement",
                         url: "https://lichess.org/@/Lichess/blog/streamer-arenas-announcement--february-to-july-2026/WbNDIbKt",
                         publishedDate: Calendar.current.date(byAdding: .day, value: -35, to: .now),
                         thumbnailData: nil, thumbnailImageName: "placeholder_thumb_3"),
            BlogFeedItem(id: "4",
                         title: "Titled Arenas Announcement",
                         url: "https://lichess.org/@/Lichess/blog/titled-arenas-announcement--january-to-march-2026/BOzFDHHs",
                         publishedDate: Calendar.current.date(byAdding: .day, value: -68, to: .now),
                         thumbnailData: nil,
                         thumbnailImageName: "placeholder_thumb_4"),
        ]
        return BlogFeedEntry(date: .now,
                             feed: .officialBlog,
                             username: nil,
                             items: Array(allItems.prefix(context.family.maxItems)),
                             error: nil)
    }

    func snapshot(for configuration: BlogFeedIntent,
                  in context: Context) async -> BlogFeedEntry {
        if context.isPreview { return placeholder(in: context) }
        return await fetchEntry(for: configuration, family: context.family)
    }

    func timeline(for configuration: BlogFeedIntent,
                  in context: Context) async -> Timeline<BlogFeedEntry> {
        let entry = await fetchEntry(for: configuration, family: context.family)
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
}
