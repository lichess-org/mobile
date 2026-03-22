import SwiftUI

struct BlogFeedItemRow: View {
    let item: BlogFeedItem
    let spec: BlogThumbnailSpec?
    let lineLimit: Int
    let showDate: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 0) {
                Text(item.title)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(lineLimit)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(.primary)
                if showDate, let date = item.publishedDate {
                    Spacer(minLength: 4)
                    Text(date, style: .relative)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            if let spec {
                BlogItemThumbnail(data: item.thumbnailData,
                                  imageName: item.thumbnailImageName, spec: spec)
            }
        }
    }
}
