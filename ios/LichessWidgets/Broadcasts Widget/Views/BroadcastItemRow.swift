import SwiftUI

struct BroadcastItemRow: View {
    let item: BroadcastItem
    /// Square thumbnail edge size, or `nil` to hide the thumbnail (e.g. small widget).
    let thumbnailSize: CGFloat?
    let lineLimit: Int

    var body: some View {
        HStack(alignment: .top, spacing: BroadcastWidgetLayout.itemHSpacing) {
            VStack(alignment: .leading, spacing: 0) {
                Text(item.title)
                    .font(.system(size: BroadcastWidgetLayout.titleFontSize, weight: .semibold))
                    .lineLimit(lineLimit)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(.primary)
                Spacer(minLength: BroadcastWidgetLayout.statusSpacerMinLength)
                HStack(spacing: 4) {
                    statusIndicator
                    Text(statusText)
                        .font(.system(size: BroadcastWidgetLayout.metaFontSize))
                        .foregroundStyle(item.isLive ? .red : .secondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            if let thumbnailSize {
                thumbnailView(size: thumbnailSize)
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
    private func thumbnailView(size: CGFloat) -> some View {
        Group {
            if let data = item.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if let imageName = item.thumbnailImageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ZStack {
                    Color.secondary.opacity(0.15)
                    Image("LichessLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: size * BroadcastWidgetLayout.thumbnailFallbackLogoRatio,
                            height: size * BroadcastWidgetLayout.thumbnailFallbackLogoRatio
                        )
                        .opacity(0.5)
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: BroadcastWidgetLayout.thumbnailCornerRadius))
    }
}
