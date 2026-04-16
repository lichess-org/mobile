import CoreGraphics

/// Layout constants shared across daily puzzle widget views.
enum DailyPuzzleWidgetLayout {
    // Typography
    static let titleFontSize: CGFloat = 17
    static let metaFontSize: CGFloat = 14

    // Header
    static let headerSpacing: CGFloat = 8
    static let headerBottomPadding: CGFloat = 5
    static let logoSize: CGFloat = 20

    // Board
    static let boardBorderWidth: CGFloat = 1
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 10

    // Piece
    static let pieceSizeFactor: CGFloat = 0.9

    // Error state
    static let errorIconSize: CGFloat = 20
    static let errorStackSpacing: CGFloat = 6
    static let errorMessageHorizontalPadding: CGFloat = 16

    // Small widget overlay
    static let smallLogoSize: CGFloat = 17
    static let smallTitleFontSize: CGFloat = 14
    static let smallHeaderSpacing: CGFloat = 5
    static let smallHeaderHorizontalPadding: CGFloat = 14
    static let smallHeaderVerticalPadding: CGFloat = 8
    static let smallScrimHeight: CGFloat = 72
    static let smallScrimOpacity: CGFloat = 0.5
}
