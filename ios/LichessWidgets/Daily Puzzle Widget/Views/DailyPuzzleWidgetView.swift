import SwiftUI
import WidgetKit

struct DailyPuzzleWidgetView: View {
    let entry: DailyPuzzleEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        Group {
            if let error = entry.error {
                errorView(error)
            } else if family == .systemSmall {
                smallView
            } else {
                largeView
            }
        }
        .widgetURL(entry.puzzleURL)
    }

    // MARK: - Small (.systemSmall)

    @ViewBuilder
    private var smallView: some View {
        boardView
            .roundedCornerWithBorder(
                lineWidth: DailyPuzzleWidgetLayout.smallBoardBorderWidth,
                style: .tertiary,
                radius: DailyPuzzleWidgetLayout.smallBoardCornerRadius
            )
            .padding(DailyPuzzleWidgetLayout.smallBoardPadding)
    }

    // MARK: - Large (.systemLarge)

    @ViewBuilder
    private var largeView: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack(spacing: DailyPuzzleWidgetLayout.headerSpacing) {
                    Image("LichessLogo")
                        .resizable()
                        .frame(
                            width: DailyPuzzleWidgetLayout.logoSize,
                            height: DailyPuzzleWidgetLayout.logoSize
                        )
                    Text("Daily Puzzle")
                        .font(.system(size: DailyPuzzleWidgetLayout.titleFontSize, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Spacer()

                    if entry.showRating, let rating = entry.rating {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: DailyPuzzleWidgetLayout.metaFontSize))
                            .foregroundStyle(.secondary)
                        Text("\(rating)")
                            .font(.system(size: DailyPuzzleWidgetLayout.metaFontSize))
                            .foregroundStyle(.secondary)
                    }

                    Circle()
                        .fill(entry.isWhiteToMove ? Color.white : Color.black)
                        .overlay(
                            Circle().stroke(
                                Color.primary.opacity(DailyPuzzleWidgetLayout.sideIndicatorBorderOpacity),
                                lineWidth: DailyPuzzleWidgetLayout.sideIndicatorBorderWidth
                            )
                        )
                        .frame(
                            width: DailyPuzzleWidgetLayout.sideIndicatorSize,
                            height: DailyPuzzleWidgetLayout.sideIndicatorSize
                        )

                    Text(entry.date.shortTime)
                        .font(.system(size: DailyPuzzleWidgetLayout.metaFontSize))
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, DailyPuzzleWidgetLayout.headerBottomPadding)

                boardView
                    .clipShape(ContainerRelativeShape())
                    .overlay(
                        ContainerRelativeShape()
                            .stroke(.tertiary, lineWidth: DailyPuzzleWidgetLayout.largeBoardBorderWidth)
                    )
                    .frame(width: geo.size.width, height: geo.size.width)
            }
        }
        .padding(.horizontal, DailyPuzzleWidgetLayout.largeHorizontalPadding)
        .padding(.top, DailyPuzzleWidgetLayout.largeTopPadding)
    }

    // MARK: - Reusable sub-views

    @ViewBuilder
    private var boardView: some View {
        if let fen = entry.fen {
            ChessBoardView(
                fen: fen,
                lastMove: entry.lastMove,
                flipped: !entry.isWhiteToMove,
                boardStyle: entry.boardStyle
            )
        } else {
            Color.secondary.opacity(0.2)
        }
    }

    // MARK: - Error state

    @ViewBuilder
    private func errorView(_ message: String) -> some View {
        VStack(spacing: DailyPuzzleWidgetLayout.errorStackSpacing) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: DailyPuzzleWidgetLayout.errorIconSize))
                .foregroundStyle(.secondary)
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DailyPuzzleWidgetLayout.errorMessageHorizontalPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
