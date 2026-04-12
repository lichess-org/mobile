import CoreGraphics

/// Layout constants shared across broadcast widget views.
enum BroadcastWidgetLayout {
    // Typography
    static let titleFontSize: CGFloat = 17
    static let metaFontSize: CGFloat = 14
    static let secondaryFontSize: CGFloat = 14

    // Header
    static let headerSpacing: CGFloat = 6
    static let logoSize: CGFloat = 20

    // Item row
    static let itemHSpacing: CGFloat = 10
    static let liveIndicatorSize: CGFloat = 8
    static let statusIconSize: CGFloat = 12

    // Item list
    static let itemTopPadding: CGFloat = 6
    static let dividerTotalHeight: CGFloat = 9

    // Thumbnail
    static let thumbnailSize: CGFloat = 56
    static let thumbnailCornerRadius: CGFloat = 6

    // Small widget footer
    static let smallFooterTopPadding: CGFloat = 6

    // Error state
    static let errorIconSize: CGFloat = 20
    static let errorStackSpacing: CGFloat = 6
}
