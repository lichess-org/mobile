import SwiftUI
import WidgetKit

struct BroadcastWidgetEntryView: View {
    var entry: BroadcastEntry
    @Environment(\.widgetFamily) var family

    private var lineLimit: Int {
        switch family {
        case .systemSmall: return 3
        case .systemMedium: return 1
        default: return 2
        }
    }

    /// Computes a thumbnail edge size that makes items fill `availableHeight` without exceeding the static max.
    private func thumbnailSize(for availableHeight: CGFloat) -> CGFloat? {
        guard family != .systemSmall else { return nil }
        let count = CGFloat(max(entry.items.count, 1))
        let overhead = count * BroadcastWidgetLayout.itemTopPadding
                     + (count - 1) * BroadcastWidgetLayout.dividerTotalHeight
        let size = min(max((availableHeight - overhead) / count, BroadcastWidgetLayout.minThumbnailSize),
                       BroadcastWidgetLayout.maxThumbnailSize)
        return size
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BroadcastWidgetHeader(
                title: entry.headerTitle,
                updatedAt: entry.date,
                showTimestamp: family != .systemSmall
            )
            Divider()
                .padding(.top, BroadcastWidgetLayout.itemTopPadding)

            if let error = entry.error {
                errorView(message: error)
            } else if entry.items.isEmpty {
                emptyView
            } else if family == .systemSmall {
                itemsContent(thumbnailSize: nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text("Updated at \(entry.date.shortTime)")
                    .font(.system(size: BroadcastWidgetLayout.secondaryFontSize))
                    .foregroundStyle(.secondary)
                    .padding(.top, BroadcastWidgetLayout.smallFooterTopPadding)
            } else {
                // GeometryReader measures remaining height so thumbnails fill the available area.
                GeometryReader { geo in
                    itemsContent(thumbnailSize: thumbnailSize(for: geo.size.height))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    @ViewBuilder
    private func itemsContent(thumbnailSize: CGFloat?) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(entry.items.enumerated()), id: \.element.id) { index, item in
                let row = BroadcastItemRow(item: item, thumbnailSize: thumbnailSize, lineLimit: lineLimit)
                    .padding(.top, BroadcastWidgetLayout.itemTopPadding)
                if let dest = item.broadcastURL() {
                    Link(destination: dest) { row }
                } else {
                    row
                }
                if index < entry.items.count - 1 {
                    Divider()
                        .padding(.top, BroadcastWidgetLayout.itemTopPadding)
                }
            }
        }
    }

    @ViewBuilder
    private func errorView(message: String) -> some View {
        VStack(spacing: BroadcastWidgetLayout.errorStackSpacing) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: BroadcastWidgetLayout.errorIconSize))
                .foregroundStyle(.secondary)
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyView: some View {
        Text("No broadcasts available")
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.top, BroadcastWidgetLayout.itemTopPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
