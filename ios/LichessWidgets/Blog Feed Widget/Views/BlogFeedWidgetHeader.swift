import SwiftUI

struct BlogFeedWidgetHeader: View {
    let feedName: String
    let updatedAt: Date
    var showTimestamp: Bool = true

    var body: some View {
        HStack(spacing: BlogFeedWidgetLayout.headerSpacing) {
            Image("LichessLogo")
                .resizable()
                .frame(width: BlogFeedWidgetLayout.logoSize, height: BlogFeedWidgetLayout.logoSize)
            Text(feedName)
                .font(.system(size: BlogFeedWidgetLayout.titleFontSize, weight: .semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
            if showTimestamp {
                Spacer()
                Text("Updated at \(updatedAt.shortTime)")
                    .font(.system(size: BlogFeedWidgetLayout.secondaryFontSize))
                    .foregroundStyle(.secondary)
            }
        }
    }
}
