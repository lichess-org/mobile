import SwiftUI
import WidgetKit

struct BroadcastWidgetEntryView: View {
    var entry: BroadcastEntry
    @Environment(\.widgetFamily) var family

    private var showThumbnail: Bool { family != .systemSmall }
    private var lineLimit: Int {
        switch family {
        case .systemSmall: return 3
        default: return 2
        }
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
                itemsContent
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text("Updated at \(entry.date.shortTime)")
                    .font(.system(size: BroadcastWidgetLayout.secondaryFontSize))
                    .foregroundStyle(.secondary)
                    .padding(.top, BroadcastWidgetLayout.smallFooterTopPadding)
            } else {
                itemsContent
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    @ViewBuilder
    private var itemsContent: some View {
        VStack(alignment: .leading, spacing: 0) {
          ForEach(Array(entry.items.enumerated()), id: \.element.id) { index, item in
                let row = BroadcastItemRow(item: item, showThumbnail: showThumbnail, lineLimit: lineLimit)
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
