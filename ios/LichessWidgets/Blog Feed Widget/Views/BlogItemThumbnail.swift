import SwiftUI

struct BlogItemThumbnail: View {
    let data: Data?
    let imageName: String?
    let spec: BlogThumbnailSpec

    var body: some View {
        Group {
            if let data, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if let imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.secondary.opacity(0.15)
            }
        }
        .frame(width: spec.width, height: spec.height)
        .clipShape(RoundedRectangle(cornerRadius: BlogFeedWidgetLayout.thumbnailCornerRadius))
    }
}
