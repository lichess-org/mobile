import AppIntents
import FeedKit
import SwiftUI
import UIKit
import WidgetKit
internal import XMLKit

// MARK: - Feed Selection

enum FeedChoice: String, AppEnum {
    case officialBlog
    case newsFeed
    case communityBlog
    case userBlog

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Feed"

    static var caseDisplayRepresentations: [FeedChoice: DisplayRepresentation] = [
        .officialBlog: "Official Blog",
        .newsFeed: "News Feed",
        .communityBlog: "Community Blog",
        .userBlog: "User Blog",
    ]

    func feedURL(username: String?) -> String? {
        switch self {
        case .officialBlog: return "https://lichess.org/@/Lichess/blog.atom"
        case .newsFeed: return "https://lichess.org/feed.atom"
        case .communityBlog: return "https://lichess.org/blog/community.atom"
        case .userBlog:
            guard let username, !username.isEmpty else { return nil }
            return "https://lichess.org/@/\(username)/blog.atom"
        }
    }
}

// MARK: - Widget Intent

struct FeedIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Feed Selection"
    static var description = IntentDescription("Choose which Lichess feed to display.")

    @Parameter(title: "Feed", default: .officialBlog)
    var feed: FeedChoice

    @Parameter(title: "Username")
    var username: String?

    static var parameterSummary: some ParameterSummary {
        When(\FeedIntent.$feed, .equalTo, .userBlog) {
            Summary("Show \(\.$feed) for \(\.$username)")
        } otherwise: {
            Summary("Show \(\.$feed)")
        }
    }
}

// MARK: - Model

struct FeedItem: Identifiable {
    let id: String
    let title: String
    let url: String?
    let publishedDate: Date?
    let thumbnailData: Data?
    /// Asset catalog image name, used for static placeholder items only.
    var thumbnailImageName: String? = nil
}

struct FeedEntry: TimelineEntry {
    let date: Date
    let feed: FeedChoice
    let username: String?
    let items: [FeedItem]
    let error: String?

    /// Display name for the widget header.
    var headerTitle: String {
        if feed == .userBlog, let username, !username.isEmpty {
            return "@\(username)"
        }
        return FeedChoice.caseDisplayRepresentations[feed].map { String(localized: $0.title) } ?? feed.rawValue
    }
}

// MARK: - Feed Fetching

private struct ThumbnailSpec {
    let width: CGFloat
    let aspectRatio: CGFloat // height = width * aspectRatio

    var height: CGFloat { width * aspectRatio }
}

private func thumbnailSpec(for family: WidgetFamily) -> ThumbnailSpec? {
    switch family {
    case .systemSmall: return nil
    case .systemMedium: return ThumbnailSpec(width: 72, aspectRatio: 0.5625) // 16:9
    default: return ThumbnailSpec(width: 72, aspectRatio: 0.75)              // 4:3
    }
}

private func maxItems(for family: WidgetFamily) -> Int {
    switch family {
    case .systemSmall: return 1
    case .systemMedium: return 2
    default: return 4
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

private func fetchFeed(for configuration: FeedIntent, maxCount: Int, thumbSpec: ThumbnailSpec?) async -> (items: [FeedItem], error: String?) {
    guard let urlString = configuration.feed.feedURL(username: configuration.username) else {
        return ([], "Enter a username in widget settings")
    }
    do {
        guard case .atom(let atomFeed) = try await Feed(urlString: urlString) else {
            return ([], "Unexpected feed format")
        }
        let items = await withTaskGroup(of: (Int, FeedItem).self) { group in
            for (index, entry) in (atomFeed.entries ?? []).prefix(maxCount).enumerated() {
                group.addTask {
                    let thumbData: Data?
                    if let thumbSpec, let thumbURL = entry.media?.thumbnails?.first?.attributes?.url {
                        thumbData = await fetchThumbnail(urlString: thumbURL, spec: thumbSpec)
                    } else {
                        thumbData = nil
                    }
                    let entryURL = entry.links?
                        .first(where: { $0.attributes?.rel == "alternate" })?
                        .attributes?.href
                        ?? entry.links?.first?.attributes?.href
                    return (index, FeedItem(
                        id: entry.id ?? "\(index)",
                        title: entry.title ?? "Untitled",
                        url: entryURL,
                        publishedDate: entry.published,
                        thumbnailData: thumbData
                    ))
                }
            }
            var results: [(Int, FeedItem)] = []
            for await result in group { results.append(result) }
            return results.sorted { $0.0 < $1.0 }.map(\.1)
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
            feed: .officialBlog,
            username: nil,
            items: [
                FeedItem(
                    id: "1",
                    title: "Queens' Online Chess Festival",
                    url: "https://lichess.org/@/Lichess/blog/queens-online-chess-festival/YwpMPp8y",
                    publishedDate: Calendar.current.date(byAdding: .day, value: -27, to: .now),
                    thumbnailData: nil,
                    thumbnailImageName: "placeholder_thumb_1"
                ),
                FeedItem(
                    id: "2",
                    title: "ChessMood 20/20 Grand Prix 2026",
                    url: "https://lichess.org/@/Lichess/blog/announcing-the-chessmood-2020-grand-prix-2026/Y7sU143E",
                    publishedDate: Calendar.current.date(byAdding: .day, value: -31, to: .now),
                    thumbnailData: nil,
                    thumbnailImageName: "placeholder_thumb_2"
                ),
                FeedItem(
                    id: "3",
                    title: "Streamer Arenas Announcement",
                    url: "https://lichess.org/@/Lichess/blog/streamer-arenas-announcement--february-to-july-2026/WbNDIbKt",
                    publishedDate: Calendar.current.date(byAdding: .day, value: -35, to: .now),
                    thumbnailData: nil,
                    thumbnailImageName: "placeholder_thumb_3"
                ),
                FeedItem(
                    id: "4",
                    title: "Titled Arenas Announcement",
                    url: "https://lichess.org/@/Lichess/blog/titled-arenas-announcement--january-to-march-2026/BOzFDHHs",
                    publishedDate: Calendar.current.date(byAdding: .day, value: -68, to: .now),
                    thumbnailData: nil,
                    thumbnailImageName: "placeholder_thumb_4"
                ),
            ].prefix(maxItems(for: context.family)).map { $0 },
            error: nil
        )
    }

    func snapshot(for configuration: FeedIntent, in context: Context) async -> FeedEntry {
        if context.isPreview { return placeholder(in: context) }
        let spec = thumbnailSpec(for: context.family)
        let (items, error) = await fetchFeed(for: configuration, maxCount: maxItems(for: context.family), thumbSpec: spec)
        return FeedEntry(date: .now, feed: configuration.feed, username: configuration.username, items: items, error: error)
    }

    func timeline(for configuration: FeedIntent, in context: Context) async -> Timeline<FeedEntry> {
        let spec = thumbnailSpec(for: context.family)
        let (items, error) = await fetchFeed(for: configuration, maxCount: maxItems(for: context.family), thumbSpec: spec)
        let entry = FeedEntry(date: .now, feed: configuration.feed, username: configuration.username, items: items, error: error)
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
}

// MARK: - Deep Link

/// Encodes a feed item URL into the custom scheme the app listens for,
/// opening it in the in-app browser (LaunchMode.inAppBrowserView).
private func openWebURL(for urlString: String) -> URL? {
    guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
    return URL(string: "org.lichess.mobile://open-web?url=\(encoded)")
}

// MARK: - Views

private struct ItemThumbnail: View {
    let data: Data?
    let imageName: String?
    let spec: ThumbnailSpec

    var body: some View {
        Group {
            if let data, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if let imageName {
                Image(imageName)
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
    let spec: ThumbnailSpec?
    let lineLimit: Int
    let showDate: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 0) {
                Text(item.title)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(lineLimit)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(.primary)
                if showDate, let date = item.publishedDate {
                    Spacer(minLength: 4)
                    Text(date, style: .relative)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            if let spec {
                ItemThumbnail(data: item.thumbnailData, imageName: item.thumbnailImageName, spec: spec)
            }
        }
    }
}

struct FeedWidgetHeader: View {
    let feedName: String
    let updatedAt: Date
    var showTimestamp: Bool = true

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
            if showTimestamp {
                Spacer()
                Text("Updated at \(updatedAt.formatted(.dateTime.hour().minute()))")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct BlogFeedWidgetEntryView: View {
    var entry: FeedEntry
    @Environment(\.widgetFamily) var family

    private var showDate: Bool { family == .systemLarge }
    private var lineLimit: Int { family == .systemSmall ? 4 : family == .systemLarge ? 2 : 3 }

    /// Computes a thumbnail spec that makes items fill `availableHeight` without exceeding the static size.
    /// Each item row has 8pt top padding; dividers between items add ~9pt each.
    private func spec(for availableHeight: CGFloat) -> ThumbnailSpec? {
        guard let staticSpec = thumbnailSpec(for: family) else { return nil }
        let count = CGFloat(max(entry.items.count, 1))
        let overhead = count * 8 + (count - 1) * 9
        let thumbHeight = min(max((availableHeight - overhead) / count, 20), staticSpec.height)
        return ThumbnailSpec(width: thumbHeight / staticSpec.aspectRatio, aspectRatio: staticSpec.aspectRatio)
    }

    @ViewBuilder
    private func itemsContent(spec: ThumbnailSpec?) -> some View {
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
                    let row = FeedItemRow(item: item, spec: spec, lineLimit: lineLimit, showDate: showDate)
                        .padding(.top, 8)
                    if let dest = item.url.flatMap(openWebURL) {
                        Link(destination: dest) { row }
                    } else {
                        row
                    }
                    if index < entry.items.count - 1 {
                        Divider()
                            .padding(.top, 8)
                    }
                }
            }
        }
    }

    var body: some View {
        if family == .systemSmall {
            // Small: single item — use fixed spec, timestamp pinned at bottom.
            VStack(alignment: .leading, spacing: 0) {
                FeedWidgetHeader(feedName: entry.headerTitle, updatedAt: entry.date, showTimestamp: false)

                Divider()
                    .padding(.top, 8)

                itemsContent(spec: nil)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                Text("Updated at \(entry.date.formatted(.dateTime.hour().minute()))")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .padding(.top, 6)
            }
        } else {
            VStack(alignment: .leading, spacing: 0) {
                FeedWidgetHeader(feedName: entry.headerTitle, updatedAt: entry.date)

                Divider()
                    .padding(.top, 8)

                // GeometryReader fills remaining vertical space and provides its height
                // so thumbnails can be sized to make items exactly fill the available area.
                GeometryReader { geo in
                    itemsContent(spec: spec(for: geo.size.height))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

// MARK: - Widget

struct BlogFeedWidget: Widget {
    let kind: String = "BlogFeedWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: FeedIntent.self, provider: FeedProvider()) { entry in
            BlogFeedWidgetEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Lichess Feed")
        .description("Shows the latest posts from a Lichess feed.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Preview

#Preview(as: .systemLarge) {
    BlogFeedWidget()
} timeline: {
    FeedEntry(
        date: .now,
        feed: .officialBlog,
        username: nil,
        items: [
            FeedItem(id: "1", title: "Queens' Online Chess Festival", url: "https://lichess.org/@/Lichess/blog/queens-online-chess-festival/YwpMPp8y", publishedDate: Calendar.current.date(byAdding: .day, value: -27, to: .now), thumbnailData: nil, thumbnailImageName: "placeholder_thumb_1"),
            FeedItem(id: "2", title: "ChessMood 20/20 Grand Prix 2026", url: "https://lichess.org/@/Lichess/blog/announcing-the-chessmood-2020-grand-prix-2026/Y7sU143E", publishedDate: Calendar.current.date(byAdding: .day, value: -31, to: .now), thumbnailData: nil, thumbnailImageName: "placeholder_thumb_2"),
            FeedItem(id: "3", title: "Streamer Arenas Announcement", url: "https://lichess.org/@/Lichess/blog/streamer-arenas-announcement--february-to-july-2026/WbNDIbKt", publishedDate: Calendar.current.date(byAdding: .day, value: -35, to: .now), thumbnailData: nil, thumbnailImageName: "placeholder_thumb_3"),
            FeedItem(id: "4", title: "Titled Arenas Announcement", url: "https://lichess.org/@/Lichess/blog/titled-arenas-announcement--january-to-march-2026/BOzFDHHs", publishedDate: Calendar.current.date(byAdding: .day, value: -68, to: .now), thumbnailData: nil, thumbnailImageName: "placeholder_thumb_4"),
        ],
        error: nil
    )
}
