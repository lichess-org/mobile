import ChessgroundAssets
import SwiftUI
import WidgetKit

struct DailyPuzzleWidgetView: View {
    let entry: DailyPuzzleEntry

    var body: some View {
        Group {
            if let error = entry.error {
                errorView(error)
            } else {
                contentView
            }
        }
        .widgetURL(entry.puzzleURL)
    }

    @ViewBuilder
    private var contentView: some View {
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

#Preview("Puzzle – Brown", as: .systemLarge) {
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
