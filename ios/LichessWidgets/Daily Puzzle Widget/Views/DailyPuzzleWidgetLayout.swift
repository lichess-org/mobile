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

    // Side-to-move indicator
    static let sideIndicatorSize: CGFloat = 14
    static let sideIndicatorBorderOpacity: CGFloat = 0.4
    static let sideIndicatorBorderWidth: CGFloat = 0.5

    // Board — small
    static let smallBoardPadding: CGFloat = 8
    static let smallBoardCornerRadius: CGFloat = 12
    static let smallBoardBorderWidth: CGFloat = 1

    // Board — large
    static let largeBoardCornerRadius: CGFloat = 6
    static let largeBoardBorderWidth: CGFloat = 1
    static let largeHorizontalPadding: CGFloat = 16
    static let largeTopPadding: CGFloat = 11

    // Piece
    static let pieceSizeFactor: CGFloat = 0.9

    // Error state
    static let errorIconSize: CGFloat = 20
    static let errorStackSpacing: CGFloat = 6
}
