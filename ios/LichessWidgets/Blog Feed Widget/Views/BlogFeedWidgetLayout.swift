import CoreGraphics

/// Layout constants shared across blog feed widget views.
enum BlogFeedWidgetLayout {
    // Typography
    static let titleFontSize: CGFloat = 17
    static let metaFontSize: CGFloat = 14
    static let secondaryFontSize: CGFloat = 14

    // Header
    static let headerSpacing: CGFloat = 6
    static let logoSize: CGFloat = 20

    // Item row
    static let itemHSpacing: CGFloat = 10
    static let dateSpacerMinLength: CGFloat = 4

    // Item list — these constants are used both in `spec(for:)` and the actual view layout,
    // keeping the geometry calculation in sync with what's rendered.
    static let itemTopPadding: CGFloat = 6
    /// Divider (~1pt) plus its 8pt top padding — total vertical space consumed between items.
    static let dividerTotalHeight: CGFloat = 9

    // Thumbnail
    static let minThumbHeight: CGFloat = 20
    static let thumbnailCornerRadius: CGFloat = 6

    // Small widget footer
    static let smallFooterTopPadding: CGFloat = 6

    // Error state
    static let errorIconSize: CGFloat = 20
    static let errorStackSpacing: CGFloat = 6
}
