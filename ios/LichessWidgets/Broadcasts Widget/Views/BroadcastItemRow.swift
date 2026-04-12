import SwiftUI

struct BroadcastItemRow: View {
    let item: BroadcastItem
    let showThumbnail: Bool
    let lineLimit: Int

    var body: some View {
        HStack(alignment: .top, spacing: BroadcastWidgetLayout.itemHSpacing) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: BroadcastWidgetLayout.titleFontSize, weight: .semibold))
                    .lineLimit(lineLimit)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(.primary)
                HStack(spacing: 4) {
                    statusIndicator
                    Text(statusText)
                        .font(.system(size: BroadcastWidgetLayout.metaFontSize))
                        .foregroundStyle(item.isLive ? .red : .secondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            if showThumbnail {
                thumbnailView
            }
        }
    }

    @ViewBuilder
    private var statusIndicator: some View {
        if item.isLive {
            Circle()
                .fill(.red)
                .frame(
                    width: BroadcastWidgetLayout.liveIndicatorSize,
                    height: BroadcastWidgetLayout.liveIndicatorSize
                )
        } else {
            Image(systemName: "clock")
                .font(.system(size: BroadcastWidgetLayout.statusIconSize))
                .foregroundStyle(.secondary)
        }
    }

    private var statusText: String {
        if item.isLive {
            return "LIVE · \(item.roundName)"
        } else if let startsAt = item.startsAt {
            return "\(item.roundName) · \(startsAt.formatted(startsAt.widgetDateFormat))"
        } else {
            return item.roundName
        }
    }

    @ViewBuilder
    private var thumbnailView: some View {
        let size = BroadcastWidgetLayout.thumbnailSize
        Group {
            if let data = item.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image("BroadcastPlaceholderImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: BroadcastWidgetLayout.thumbnailCornerRadius))
    }
}
