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

    var displayName: String {
        switch self {
        case .officialBlog: return "Official Blog"
        case .newsFeed: return "News Feed"
        case .communityBlog: return "Community Blog"
        case .userBlog: return "User Blog"
        }
    }

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
        return feed.displayName
    }
}

// MARK: - Feed Fetching

private struct ThumbnailSpec {
    let width: CGFloat
    let aspectRatio: CGFloat // height = width * aspectRatio

    var height: CGFloat { width * aspectRatio }
}

private func thumbnailSpec(for family: WidgetFamily) -> ThumbnailSpec {
    switch family {
    case .systemSmall: return ThumbnailSpec(width: 28, aspectRatio: 1.0)     // square
    case .systemMedium: return ThumbnailSpec(width: 72, aspectRatio: 0.5625) // 16:9
    default: return ThumbnailSpec(width: 72, aspectRatio: 0.75)              // 4:3
    }
}

private func maxItems(for family: WidgetFamily) -> Int {
    switch family {
    case .systemSmall: return 1
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

private func fetchFeed(for configuration: FeedIntent, maxCount: Int, thumbSpec: ThumbnailSpec) async -> (items: [FeedItem], error: String?) {
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
                    if let thumbURL = entry.media?.thumbnails?.first?.attributes?.url {
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
            feed: .communityBlog,
            username: nil,
            items: [
                FeedItem(id: "1", title: "Ståhlberg's Losing Streak in Zürich 1953", url: nil, publishedDate: .now, thumbnailData: nil),
                FeedItem(id: "2", title: "The Immortal Game Revisited", url: nil, publishedDate: .now, thumbnailData: nil),
                FeedItem(id: "3", title: "Lichess Puzzle of the Month", url: nil, publishedDate: .now, thumbnailData: nil),
            ],
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
            // Small: single item, no overflow risk — timestamp pinned at bottom.
            VStack(alignment: .leading, spacing: 0) {
                FeedWidgetHeader(feedName: entry.headerTitle, updatedAt: entry.date, showTimestamp: false)

                Divider()
                    .padding(.top, 8)

                itemsContent
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
}

// MARK: - Widget

struct BlogFeedWidget: Widget {
    let kind: String = "BlogFeedWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: FeedIntent.self, provider: FeedProvider()) { entry in
            if #available(iOS 17.0, *) {
                BlogFeedWidgetEntryView(entry: entry)
                    .containerBackground(.background, for: .widget)
            } else {
                BlogFeedWidgetEntryView(entry: entry)
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
    BlogFeedWidget()
} timeline: {
    FeedEntry(
        date: .now,
        feed: .communityBlog,
        username: nil,
        items: [
            FeedItem(id: "1", title: "Ståhlberg's Losing Streak in Zürich 1953", url: nil, publishedDate: .now, thumbnailData: nil),
            FeedItem(id: "2", title: "The Immortal Game Revisited: What Anderssen Got Right", url: nil, publishedDate: Calendar.current.date(byAdding: .day, value: -1, to: .now), thumbnailData: nil),
            FeedItem(id: "3", title: "Lichess Puzzle of the Month: March 2026", url: nil, publishedDate: Calendar.current.date(byAdding: .day, value: -2, to: .now), thumbnailData: nil),
            FeedItem(id: "4", title: "Opening Traps Every Club Player Should Know", url: nil, publishedDate: Calendar.current.date(byAdding: .day, value: -3, to: .now), thumbnailData: nil),
            FeedItem(id: "5", title: "Fischer's 21 Brilliant Games Annotated", url: nil, publishedDate: Calendar.current.date(byAdding: .day, value: -5, to: .now), thumbnailData: nil),
        ],
        error: nil
    )
}
