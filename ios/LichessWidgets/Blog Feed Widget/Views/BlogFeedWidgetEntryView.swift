import SwiftUI
import WidgetKit

struct BlogFeedWidgetEntryView: View {
    var entry: BlogFeedEntry
    @Environment(\.widgetFamily) var family

    private var showDate: Bool { family == .systemLarge }
    private var lineLimit: Int {
        switch family {
        case .systemSmall: 4
        case .systemLarge: 2
        default: 3
        }
    }

    /// Computes a thumbnail spec that makes items fill `availableHeight` without exceeding the static size.
    /// Each item row has 8pt top padding; dividers between items add ~9pt each.
    private func spec(for availableHeight: CGFloat) -> BlogThumbnailSpec? {
        guard let staticSpec = family.thumbnailSpec else { return nil }
        let count = CGFloat(max(entry.items.count, 1))
        let overhead = count * 8 + (count - 1) * 9
        let thumbHeight = min(max((availableHeight - overhead) / count, 20), staticSpec.height)
        return BlogThumbnailSpec(width: thumbHeight / staticSpec.aspectRatio, aspectRatio: staticSpec.aspectRatio)
    }

    @ViewBuilder
    private func itemsContent(spec: BlogThumbnailSpec?) -> some View {
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
                    let showAuthor = showDate && entry.feed == .communityBlog
                    let row = BlogFeedItemRow(item: item,
                                              spec: spec,
                                              lineLimit: lineLimit,
                                              showDate: showDate,
                                              showAuthor: showAuthor)
                        .padding(.top, 8)
                    if let dest = item.url?.lichessWebURL {
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
        VStack(alignment: .leading, spacing: 0) {
            FeedWidgetHeader(feedName: entry.headerTitle, updatedAt: entry.date, showTimestamp: family != .systemSmall)

            Divider()
                .padding(.top, 8)

            if family == .systemSmall {
                itemsContent(spec: nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text("Updated at \(entry.date.shortTime)")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .padding(.top, 6)
            } else {
                // GeometryReader measures remaining height so thumbnails fill the available area.
                GeometryReader { geo in
                    itemsContent(spec: spec(for: geo.size.height))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}
