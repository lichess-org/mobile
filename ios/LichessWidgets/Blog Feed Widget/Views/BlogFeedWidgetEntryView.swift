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
    private func spec(for availableHeight: CGFloat) -> BlogThumbnailSpec? {
        guard let staticSpec = family.thumbnailSpec else { return nil }
        let count = CGFloat(max(entry.items.count, 1))
        let overhead = count * BlogFeedWidgetLayout.itemTopPadding
                     + (count - 1) * BlogFeedWidgetLayout.dividerTotalHeight
        let thumbHeight = min(max((availableHeight - overhead) / count, BlogFeedWidgetLayout.minThumbHeight),
                              staticSpec.height)
        return BlogThumbnailSpec(width: thumbHeight / staticSpec.aspectRatio,
                                 aspectRatio: staticSpec.aspectRatio)
    }

    @ViewBuilder
    private func itemsContent(spec: BlogThumbnailSpec?) -> some View {
        if let error = entry.error {
            VStack(spacing: BlogFeedWidgetLayout.errorStackSpacing) {
                Image(systemName: "exclamationmark.circle")
                    .font(.system(size: BlogFeedWidgetLayout.errorIconSize))
                    .foregroundStyle(.secondary)
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if entry.items.isEmpty {
            Text("No items available")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, BlogFeedWidgetLayout.itemTopPadding)
        } else {
            VStack(alignment: .leading, spacing: 0) {
                let showAuthor = showDate && entry.feed == .communityBlog
                ForEach(Array(entry.items.enumerated()), id: \.element.id) { index, item in
                    let row = BlogFeedItemRow(item: item,
                                              spec: spec,
                                              lineLimit: lineLimit,
                                              showDate: showDate,
                                              showAuthor: showAuthor)
                        .padding(.top, BlogFeedWidgetLayout.itemTopPadding)
                    if let dest = item.url?.lichessWebURL {
                        Link(destination: dest) { row }
                    } else {
                        row
                    }
                    if index < entry.items.count - 1 {
                        Divider()
                            .padding(.top, BlogFeedWidgetLayout.itemTopPadding)
                    }
                }
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BlogFeedWidgetHeader(feedName: entry.headerTitle,
                                 updatedAt: entry.date,
                                 showTimestamp: family != .systemSmall)
            Divider()
                .padding(.top, BlogFeedWidgetLayout.itemTopPadding)

            if family == .systemSmall {
                itemsContent(spec: nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text("Updated at \(entry.date.shortTime)")
                    .font(.system(size: BlogFeedWidgetLayout.secondaryFontSize))
                    .foregroundStyle(.secondary)
                    .padding(.top, BlogFeedWidgetLayout.smallFooterTopPadding)
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
