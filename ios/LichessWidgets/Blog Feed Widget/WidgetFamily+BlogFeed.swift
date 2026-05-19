import WidgetKit

extension WidgetFamily {
    var thumbnailSpec: BlogThumbnailSpec? {
        switch self {
        case .systemSmall: return nil
        case .systemMedium: return BlogThumbnailSpec(width: 72, aspectRatio: 0.5625) // 16:9
        default: return BlogThumbnailSpec(width: 72, aspectRatio: 0.75)              // 4:3
        }
    }

    var maxItems: Int {
        switch self {
        case .systemSmall: return 1
        case .systemMedium: return 2
        default: return 4
        }
    }
}
