import SwiftUI

struct BlogFeedWidgetHeader: View {
    let feedName: String
    let updatedAt: Date
    var showTimestamp: Bool = true

    var body: some View {
        HStack(spacing: 6) {
            Image("LichessLogo")
                .resizable()
                .frame(width: 20, height: 20)
            Text(feedName)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
            if showTimestamp {
                Spacer()
                Text("Updated at \(updatedAt.shortTime)")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
        }
    }
}
