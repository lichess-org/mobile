import AppIntents
import FeedKit
import SwiftUI
import UIKit
import WidgetKit
internal import XMLKit

// MARK: - Feed Selection

enum FeedChoice: String, AppEnum {
    case officialBlog = "https://lichess.org/@/Lichess/blog.atom"
    case newsFeed = "https://lichess.org/feed.atom"
    case communityBlog = "https://lichess.org/blog/community.atom"

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Feed"

    static var caseDisplayRepresentations: [FeedChoice: DisplayRepresentation] = [
        .officialBlog: "Official Blog",
        .newsFeed: "News Feed",
        .communityBlog: "Community Blog",
    ]

    var displayName: String {
        switch self {
        case .officialBlog: return "Official Blog"
        case .newsFeed: return "News Feed"
        case .communityBlog: return "Community Blog"
        }
    }
}

// MARK: - Widget Intent

struct FeedIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Feed Selection"
    static var description = IntentDescription("Choose which Lichess feed to display.")

    @Parameter(title: "Feed", default: .officialBlog)
    var feed: FeedChoice
}

// MARK: - Model

struct FeedItem: Identifiable {
    let id: String
    let title: String
    let publishedDate: Date?
    let thumbnailData: Data?
}

struct FeedEntry: TimelineEntry {
    let date: Date
    let feed: FeedChoice
    let items: [FeedItem]
    let error: String?
}

// MARK: - Feed Fetching

func fetchThumbnail(urlString: String) async -> Data? {
    guard let url = URL(string: urlString) else { return nil }
    return try? await URLSession.shared.data(from: url).0
}

func fetchFeed(for choice: FeedChoice) async -> (items: [FeedItem], error: String?) {
    do {
        let feed = try await Feed(urlString: choice.rawValue)
        let itemCount = 10
        var items: [FeedItem] = []
        switch feed {
        case .atom(let atomFeed):
            items = await withTaskGroup(of: (Int, FeedItem).self) { group in
                for (index, entry) in (atomFeed.entries ?? []).prefix(itemCount).enumerated() {
                    group.addTask {
                        let thumbURL = entry.media?.thumbnails?.first?.attributes?.url
                        let thumbData = thumbURL != nil ? await fetchThumbnail(urlString: thumbURL!) : nil
                        return (index, FeedItem(
                            id: entry.id ?? "\(index)",
                            title: entry.title ?? "Untitled",
                            publishedDate: entry.published,
                            thumbnailData: thumbData
                        ))
                    }
                }
                var results: [(Int, FeedItem)] = []
                for await result in group { results.append(result) }
                return results.sorted { $0.0 < $1.0 }.map(\.1)
            }
        case .rss(let rssFeed):
            items = (rssFeed.channel?.items ?? []).prefix(itemCount).enumerated().map { index, item in
                FeedItem(
                    id: item.guid?.text ?? item.link ?? "\(index)",
                    title: item.title ?? "Untitled",
                    publishedDate: item.pubDate,
                    thumbnailData: nil
                )
            }
        case .json(let jsonFeed):
            items = (jsonFeed.items ?? []).prefix(itemCount).enumerated().map { index, item in
                FeedItem(
                    id: item.id ?? "\(index)",
                    title: item.title ?? "Untitled",
                    publishedDate: item.datePublished,
                    thumbnailData: nil
                )
            }
        }
        return (items, nil)
    } catch {
        return ([], error.localizedDescription)
    }
}

// MARK: - Provider

struct FeedProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> FeedEntry {
        FeedEntry(
            date: .now,
            feed: .communityBlog,
            items: [
                FeedItem(id: "1", title: "Lichess Update: New Features", publishedDate: .now, thumbnailData: nil),
                FeedItem(id: "2", title: "Titled Arena Results", publishedDate: .now, thumbnailData: nil),
                FeedItem(id: "3", title: "Community Spotlight", publishedDate: .now, thumbnailData: nil),
            ],
            error: nil
        )
    }

    func snapshot(for configuration: FeedIntent, in context: Context) async -> FeedEntry {
        if context.isPreview {
            return placeholder(in: context)
        }
        let (items, error) = await fetchFeed(for: configuration.feed)
        return FeedEntry(date: .now, feed: configuration.feed, items: items, error: error)
    }

    func timeline(for configuration: FeedIntent, in context: Context) async -> Timeline<FeedEntry> {
        let (items, error) = await fetchFeed(for: configuration.feed)
        let entry = FeedEntry(date: .now, feed: configuration.feed, items: items, error: error)
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
}

// MARK: - Views

struct ThumbnailImage: View {
    let data: Data
    let size: CGFloat

    var body: some View {
        if let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
}

struct FeedItemRow: View {
    let item: FeedItem
    let thumbnailSize: CGFloat

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            if let data = item.thumbnailData {
                ThumbnailImage(data: data, size: thumbnailSize)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(item.thumbnailData != nil ? 3 : 2)
                    .foregroundStyle(.primary)
                if let date = item.publishedDate {
                    Text(date, style: .relative)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

struct LichessWidgetsEntryView: View {
    var entry: FeedEntry
    @Environment(\.widgetFamily) var family

    var maxItems: Int {
        switch family {
        case .systemSmall: return 2
        case .systemMedium: return 2
        default: return 5
        }
    }

    var thumbnailSize: CGFloat {
        family == .systemSmall ? 44 : 52
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image("LichessLogo")
                    .resizable()
                    .frame(width: 18, height: 18)
                Text(entry.feed.displayName)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            if let error = entry.error {
                Spacer()
                Text("Could not load feed")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(error)
                    .font(.caption2)
                    .foregroundStyle(.red)
                    .lineLimit(2)
                Spacer()
            } else if entry.items.isEmpty {
                Spacer()
                Text("No items available")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                let visible = Array(entry.items.prefix(maxItems))
                ForEach(visible) { item in
                    FeedItemRow(item: item, thumbnailSize: thumbnailSize)
                    if item.id != visible.last?.id {
                        Divider()
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
}

// MARK: - Widget

struct LichessWidgets: Widget {
    let kind: String = "LichessWidgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: FeedIntent.self, provider: FeedProvider()) { entry in
            if #available(iOS 17.0, *) {
                LichessWidgetsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                LichessWidgetsEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Lichess Feed")
        .description("Shows the latest posts from a Lichess feed.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Preview

#Preview(as: .systemMedium) {
    LichessWidgets()
} timeline: {
    FeedEntry(
        date: .now,
        feed: .communityBlog,
        items: [
            FeedItem(
                id: "1",
                title: "Ståhlberg's Losing Streak in Zürich 1953",
                publishedDate: .now,
                thumbnailData: nil
            ),
            FeedItem(
                id: "2",
                title: "Titled Arena Results",
                publishedDate: Calendar.current.date(byAdding: .hour, value: -2, to: .now),
                thumbnailData: nil
            ),
            FeedItem(
                id: "3",
                title: "Community Spotlight: Great Contributions",
                publishedDate: Calendar.current.date(byAdding: .day, value: -1, to: .now),
                thumbnailData: nil
            ),
        ],
        error: nil
    )
}
