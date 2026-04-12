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
        VStack(spacing: 0) {
            boardView
                .roundedCornerWithBorder(lineWidth: 1, style: .tertiary, radius: 12)
                .padding(8)
        }
    }

    // MARK: - Large (.systemLarge)

    @ViewBuilder
    private var largeView: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Image("LichessLogo")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Daily Puzzle")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Spacer()

                    if entry.showRating, let rating = entry.rating {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                        Text("\(rating)")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }

                    Circle()
                        .fill(entry.isWhiteToMove ? Color.white : Color.black)
                        .overlay(Circle().stroke(Color.primary.opacity(0.4), lineWidth: 0.5))
                        .frame(width: 14, height: 14)

                    Text(entry.date.shortTime)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 5)

                boardView
                    .roundedCornerWithBorder(lineWidth: 1, style: .tertiary, radius: 6)
                    .frame(width: geo.size.width, height: geo.size.width)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 11)
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
        VStack(spacing: 6) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 20))
                .foregroundStyle(.secondary)
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
