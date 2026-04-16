import ChessgroundAssets
import SwiftUI
import WidgetKit

struct DailyPuzzleWidgetView: View {
    @Environment(\.widgetFamily) private var widgetFamily

    let entry: DailyPuzzleEntry

    var body: some View {
        Group {
            if let error = entry.error {
                errorView(error)
            } else if widgetFamily == .systemSmall {
                smallContentView
            } else {
                largeContentView
            }
        }
        .widgetURL(entry.puzzleURL)
    }

    // MARK: - Small layout (board fills widget, header as semi-transparent overlay)

    @ViewBuilder
    private var smallContentView: some View {
        ZStack {
            boardView
                .clipShape(ContainerRelativeShape())

            // Top scrim
            VStack {
                LinearGradient(
                    colors: [.black.opacity(DailyPuzzleWidgetLayout.smallScrimOpacity), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: DailyPuzzleWidgetLayout.smallScrimHeight)
                Spacer()
            }

            // Top-left: logo + title
            VStack {
                HStack(spacing: DailyPuzzleWidgetLayout.smallHeaderSpacing) {
                    Image("LichessLogo")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                        .frame(
                            width: DailyPuzzleWidgetLayout.smallLogoSize,
                            height: DailyPuzzleWidgetLayout.smallLogoSize
                        )
                        .shadow(color: .black.opacity(0.8), radius: 3, x: 0, y: 1)
                        .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 2)
                    Text("Daily Puzzle")
                        .font(
                            .system(
                                size: DailyPuzzleWidgetLayout.smallTitleFontSize,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.8), radius: 3, x: 0, y: 1)
                        .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 2)
                        .lineLimit(2)
                    Spacer()
                }
                Spacer()
            }
            .padding(.horizontal, DailyPuzzleWidgetLayout.smallHeaderHorizontalPadding)
            .padding(.vertical, DailyPuzzleWidgetLayout.smallHeaderVerticalPadding)
        }
    }

    // MARK: - Large layout

    @ViewBuilder
    private var largeContentView: some View {
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

                Text(entry.date, format: entry.date.widgetDateFormat)
                    .font(.system(size: DailyPuzzleWidgetLayout.metaFontSize))
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, DailyPuzzleWidgetLayout.headerBottomPadding)

            boardView
                .clipShape(ContainerRelativeShape())
                .overlay(
                    ContainerRelativeShape()
                        .stroke(.tertiary, lineWidth: DailyPuzzleWidgetLayout.boardBorderWidth)
                )
        }
        .padding(.horizontal, DailyPuzzleWidgetLayout.horizontalPadding)
        .padding(.vertical, DailyPuzzleWidgetLayout.verticalPadding)
    }

    // MARK: - Shared board view

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

#Preview("Puzzle – Brown (large)", as: .systemLarge) {
    DailyPuzzleWidget()
} timeline: {
    DailyPuzzleEntry(
        date: .now,
        puzzleId: "abcd1",
        fen: "1n3rk1/4ppbp/rq1p2p1/3P4/2p1P3/2N2P1n/PPN3PP/R1BQ1R1K b - - 1 1",
        lastMove: "g1h1",
        boardStyle: .from(themeName: "brown"),
        error: nil
    )
}

#Preview("Puzzle – Brown (small)", as: .systemSmall) {
    DailyPuzzleWidget()
} timeline: {
    DailyPuzzleEntry(
        date: .now,
        puzzleId: "abcd1",
        fen: "1n3rk1/4ppbp/rq1p2p1/3P4/2p1P3/2N2P1n/PPN3PP/R1BQ1R1K b - - 1 1",
        lastMove: "g1h1",
        boardStyle: .from(themeName: "brown"),
        error: nil
    )
}
