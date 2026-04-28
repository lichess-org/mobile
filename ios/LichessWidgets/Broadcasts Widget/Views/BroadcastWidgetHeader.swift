import SwiftUI

struct BroadcastWidgetHeader: View {
    let title: String
    let updatedAt: Date
    var showTimestamp: Bool = true

    var body: some View {
        HStack(spacing: BroadcastWidgetLayout.headerSpacing) {
            Image("LichessLogo")
                .resizable()
                .frame(
                    width: BroadcastWidgetLayout.logoSize,
                    height: BroadcastWidgetLayout.logoSize
                )
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Text(title)
                    .font(.system(size: BroadcastWidgetLayout.titleFontSize, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                if showTimestamp {
                    Spacer()
                    Text(updatedAt.shortTime)
                        .font(.system(size: BroadcastWidgetLayout.secondaryFontSize))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
