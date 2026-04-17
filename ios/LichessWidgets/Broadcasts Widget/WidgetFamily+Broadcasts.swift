import CoreGraphics
import WidgetKit

extension WidgetFamily {
    var broadcastMaxItems: Int {
        switch self {
        case .systemSmall: return 1
        case .systemMedium: return 2
        default: return 4
        }
    }

    var broadcastShowsThumbnails: Bool {
        switch self {
        case .systemSmall: return false
        default: return true
        }
    }

    /// Square thumbnail spec used for broadcast images.
    var broadcastThumbnailSpec: (width: CGFloat, height: CGFloat) {
        (width: 56, height: 56)
    }
}
