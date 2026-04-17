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
    static let statusSpacerMinLength: CGFloat = 4
    static let liveIndicatorSize: CGFloat = 8
    static let statusIconSize: CGFloat = 12

    // Item list — these constants are used both in `thumbnailSize(for:)` and the actual view layout,
    // keeping the geometry calculation in sync with what's rendered.
    static let itemTopPadding: CGFloat = 6
    /// Divider (~1pt) plus its `itemTopPadding`-top padding — total vertical space consumed between items.
    static let dividerTotalHeight: CGFloat = 7

    // Thumbnail
    static let maxThumbnailSize: CGFloat = 56
    static let minThumbnailSize: CGFloat = 24
    static let thumbnailCornerRadius: CGFloat = 6
    /// Lichess logo rendered inside the thumbnail when no artwork is available.
    /// Sized relative to the thumbnail so it scales with adaptive layouts.
    static let thumbnailFallbackLogoRatio: CGFloat = 0.5

    // Small widget footer
    static let smallFooterTopPadding: CGFloat = 6

    // Error state
    static let errorIconSize: CGFloat = 20
    static let errorStackSpacing: CGFloat = 6
}
