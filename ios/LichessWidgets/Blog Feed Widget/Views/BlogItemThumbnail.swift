import SwiftUI
import WidgetKit

struct BlogItemThumbnail: View {
    let data: Data?
    let imageName: String?
    let spec: BlogThumbnailSpec

    @Environment(\.widgetRenderingMode) private var renderingMode

    var body: some View {
        // In .accented (Tinted) and .vibrant (Clear) rendering modes WidgetKit converts
        // all views to flat monochrome, so photos become solid-coloured boxes.
        // Hiding thumbnails in those modes avoids the white-box artefact; the text
        // column expands to fill the space naturally.
        if renderingMode == .fullColor {
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
}
