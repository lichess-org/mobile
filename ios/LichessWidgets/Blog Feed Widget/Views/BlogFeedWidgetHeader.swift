import SwiftUI

struct BlogFeedWidgetHeader: View {
    let feed: BlogFeedChoice
    let username: String?
    let updatedAt: Date
    var showTimestamp: Bool = true

    var body: some View {
        HStack(spacing: BlogFeedWidgetLayout.headerSpacing) {
            Image("LichessLogo")
                .resizable()
                .frame(width: BlogFeedWidgetLayout.logoSize, height: BlogFeedWidgetLayout.logoSize)
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                headerTitle
                    .font(.system(size: BlogFeedWidgetLayout.titleFontSize, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                if showTimestamp {
                    Spacer()
                    Text(updatedAt.shortTime)
                        .font(.system(size: BlogFeedWidgetLayout.secondaryFontSize))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    @ViewBuilder
    private var headerTitle: some View {
        switch feed {
        case .communityBlog:
            Text("Community")
        case .officialBlog:
            // Resolves via "xBlog %@" key → e.g. "Lichess's Blog" / "Blogue de Lichess"
            Text("xBlog \(String("Lichess"))")
        case .userBlog:
            // Resolves via "xBlog %@" key → e.g. "johndoe's Blog" / "Blogue de johndoe"
            Text("xBlog \(username ?? "")")
        }
    }
}
