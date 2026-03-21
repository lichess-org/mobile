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

private struct ThumbnailSpec {
    let width: CGFloat
    let aspectRatio: CGFloat // height = width * aspectRatio

    var height: CGFloat { width * aspectRatio }
}

private func thumbnailSpec(for family: WidgetFamily) -> ThumbnailSpec {
    switch family {
    case .systemSmall: return ThumbnailSpec(width: 55, aspectRatio: 1.0)     // square
    case .systemMedium: return ThumbnailSpec(width: 72, aspectRatio: 0.5625) // 16:9
    default: return ThumbnailSpec(width: 72, aspectRatio: 0.75)              // 4:3
    }
}

private func maxItems(for family: WidgetFamily) -> Int {
    switch family {
    case .systemSmall: return 2
    case .systemMedium: return 2
    default: return 5
    }
}

private func fetchThumbnail(urlString: String, spec: ThumbnailSpec) async -> Data? {
    guard let url = URL(string: urlString),
          let (data, _) = try? await URLSession.shared.data(from: url),
          let source = UIImage(data: data)
    else { return nil }

    let size = CGSize(width: spec.width * 3, height: spec.height * 3)
    let renderer = UIGraphicsImageRenderer(size: size)
    let downsampled = renderer.image { _ in
        source.draw(in: CGRect(origin: .zero, size: size))
    }
    return downsampled.jpegData(compressionQuality: 0.85)
}

private func fetchFeed(for choice: FeedChoice, maxCount: Int, thumbSpec: ThumbnailSpec) async -> (items: [FeedItem], error: String?) {
    do {
        let feed = try await Feed(urlString: choice.rawValue)
        var items: [FeedItem] = []
        switch feed {
        case .atom(let atomFeed):
            items = await withTaskGroup(of: (Int, FeedItem).self) { group in
                for (index, entry) in (atomFeed.entries ?? []).prefix(maxCount).enumerated() {
                    group.addTask {
                        let thumbData: Data?
                        if let thumbURL = entry.media?.thumbnails?.first?.attributes?.url {
                            thumbData = await fetchThumbnail(urlString: thumbURL, spec: thumbSpec)
                        } else {
                            thumbData = nil
                        }
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
            items = (rssFeed.channel?.items ?? []).prefix(maxCount).enumerated().map { index, item in
                FeedItem(
                    id: item.guid?.text ?? item.link ?? "\(index)",
                    title: item.title ?? "Untitled",
                    publishedDate: item.pubDate,
                    thumbnailData: nil
                )
            }
        case .json(let jsonFeed):
            items = (jsonFeed.items ?? []).prefix(maxCount).enumerated().map { index, item in
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
                FeedItem(id: "1", title: "Ståhlberg's Losing Streak in Zürich 1953", publishedDate: .now, thumbnailData: nil),
                FeedItem(id: "2", title: "The Immortal Game Revisited", publishedDate: .now, thumbnailData: nil),
                FeedItem(id: "3", title: "Lichess Puzzle of the Month", publishedDate: .now, thumbnailData: nil),
            ],
            error: nil
        )
    }

    func snapshot(for configuration: FeedIntent, in context: Context) async -> FeedEntry {
        if context.isPreview { return placeholder(in: context) }
        let spec = thumbnailSpec(for: context.family)
        let (items, error) = await fetchFeed(
            for: configuration.feed,
            maxCount: maxItems(for: context.family),
            thumbSpec: spec
        )
        return FeedEntry(date: .now, feed: configuration.feed, items: items, error: error)
    }

    func timeline(for configuration: FeedIntent, in context: Context) async -> Timeline<FeedEntry> {
        let spec = thumbnailSpec(for: context.family)
        let (items, error) = await fetchFeed(
            for: configuration.feed,
            maxCount: maxItems(for: context.family),
            thumbSpec: spec
        )
        let entry = FeedEntry(date: .now, feed: configuration.feed, items: items, error: error)
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
}

// MARK: - Views

private struct ItemThumbnail: View {
    let data: Data
    let spec: ThumbnailSpec

    var body: some View {
        Group {
            if let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.secondary.opacity(0.15)
            }
        }
        .frame(width: spec.width, height: spec.height)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

private struct FeedItemRow: View {
    let item: FeedItem
    let spec: ThumbnailSpec
    let lineLimit: Int
    let showDate: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .font(.system(size: 13, weight: .semibold))
                    .lineLimit(lineLimit)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(.primary)
                if showDate, let date = item.publishedDate {
                    Text(date, style: .relative)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if let data = item.thumbnailData {
                ItemThumbnail(data: data, spec: spec)
            }
        }
    }
}

struct FeedWidgetHeader: View {
    let feedName: String
    let updatedAt: Date

    var body: some View {
        HStack(alignment: .center) {
            HStack(spacing: 6) {
                Image("LichessLogo")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(feedName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
            Spacer()
            Text("Updated at \(updatedAt.formatted(.dateTime.hour().minute()))")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
    }
}

struct LichessWidgetsEntryView: View {
    var entry: FeedEntry
    @Environment(\.widgetFamily) var family

    private var spec: ThumbnailSpec { thumbnailSpec(for: family) }
    private var showDate: Bool { family == .systemLarge }
    private var lineLimit: Int { family == .systemLarge ? 2 : 3 }

    @ViewBuilder
    private var itemsContent: some View {
        if let error = entry.error {
            VStack(alignment: .leading, spacing: 4) {
                Text("Could not load feed")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(error)
                    .font(.caption2)
                    .foregroundStyle(.red)
                    .lineLimit(2)
            }
            .padding(.top, 8)
        } else if entry.items.isEmpty {
            Text("No items available")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 8)
        } else {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(entry.items.enumerated()), id: \.element.id) { index, item in
                    FeedItemRow(item: item, spec: spec, lineLimit: lineLimit, showDate: showDate)
                        .padding(.top, 8)
                    if index < entry.items.count - 1 {
                        Divider()
                            .padding(.top, 8)
                    }
                }
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            FeedWidgetHeader(feedName: entry.feed.displayName, updatedAt: entry.date)

            Divider()
                .padding(.top, 8)

            // Color.clear claims all remaining vertical space in the VStack.
            // The overlay pins itemsContent to the top of that space and clips
            // anything that overflows below — the header above is never affected.
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(alignment: .topLeading) {
                    itemsContent
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .clipped()
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
                    .containerBackground(.background, for: .widget)
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

#Preview(as: .systemLarge) {
    LichessWidgets()
} timeline: {
    FeedEntry(
        date: .now,
        feed: .communityBlog,
        items: [
            FeedItem(id: "1", title: "Ståhlberg's Losing Streak in Zürich 1953", publishedDate: .now, thumbnailData: nil),
            FeedItem(id: "2", title: "The Immortal Game Revisited: What Anderssen Got Right", publishedDate: Calendar.current.date(byAdding: .day, value: -1, to: .now), thumbnailData: nil),
            FeedItem(id: "3", title: "Lichess Puzzle of the Month: March 2026", publishedDate: Calendar.current.date(byAdding: .day, value: -2, to: .now), thumbnailData: nil),
            FeedItem(id: "4", title: "Opening Traps Every Club Player Should Know", publishedDate: Calendar.current.date(byAdding: .day, value: -3, to: .now), thumbnailData: nil),
            FeedItem(id: "5", title: "Fischer's 21 Brilliant Games Annotated", publishedDate: Calendar.current.date(byAdding: .day, value: -5, to: .now), thumbnailData: nil),
        ],
        error: nil
    )
}
