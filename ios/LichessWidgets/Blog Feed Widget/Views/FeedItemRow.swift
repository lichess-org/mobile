import SwiftUI

struct BlogFeedItemRow: View {
    let item: BlogFeedItem
    let spec: BlogThumbnailSpec?
    let lineLimit: Int
    let showDate: Bool
    var showAuthor: Bool = false

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
                    let sameYear = Calendar.current.component(.year, from: date) == Calendar.current.component(.year, from: .now)
                    let dateFormat: Date.FormatStyle = sameYear ? .dateTime.month(.abbreviated).day() : .dateTime.month(.abbreviated).day().year()
                    Group {
                        if showAuthor, let author = item.author {
                            Text(date, format: dateFormat) + Text(" · \(author)")
                        } else {
                            Text(date, format: dateFormat)
                        }
                    }
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
