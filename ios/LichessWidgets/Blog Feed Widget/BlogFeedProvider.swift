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
                         url: nil,
                         publishedDate: Calendar.current.date(byAdding: .day, value: -1, to: .now),
                         author: nil,
                         thumbnailData: nil,
                         thumbnailImageName: "PlaceholderThumbnail1"),
            BlogFeedItem(id: "2",
                         title: "ChessMood 20/20 Grand Prix 2026",
                         url: nil,
                         publishedDate: Calendar.current.date(byAdding: .day, value: -3, to: .now),
                         author: nil,
                         thumbnailData: nil,
                         thumbnailImageName: "PlaceholderThumbnail2"),
            BlogFeedItem(id: "3",
                         title: "Streamer Arenas Announcement",
                         url: nil,
                         publishedDate: Calendar.current.date(byAdding: .day, value: -8, to: .now),
                         author: nil,
                         thumbnailData: nil,
                         thumbnailImageName: "PlaceholderThumbnail3"),
            BlogFeedItem(id: "4",
                         title: "Titled Arenas Announcement",
                         url: nil,
                         publishedDate: Calendar.current.date(byAdding: .day, value: -14, to: .now),
                         author: nil,
                         thumbnailData: nil,
                         thumbnailImageName: "PlaceholderThumbnail4"),
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
        // Request feed update in 1 hour intervals
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
}
