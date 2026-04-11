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
            } else if family == .systemLarge {
                largeView
            } else {
                wideView
            }
        }
        .widgetURL(entry.puzzleURL)
    }

    // MARK: - Small (.systemSmall)

    /// Full-bleed board with a thin "● to move" footer.
    @ViewBuilder
    private var smallView: some View {
        VStack(spacing: 0) {
            boardView
            sideToMoveBar
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
        }
    }

    // MARK: - Wide (.systemMedium / .systemLarge)

    /// Board on the left, puzzle metadata on the right.
    @ViewBuilder
    private var wideView: some View {
        HStack(spacing: 0) {
            boardView
                .padding(8)

            VStack(alignment: .leading, spacing: 0) {
                header
                Divider()
                    .padding(.top, 6)

                VStack(alignment: .leading, spacing: 10) {
                    sideToMoveRow
                    if let rating = entry.rating {
                        ratingRow(rating)
                    }
                }
                .padding(.top, 10)

                Spacer(minLength: 0)

                Text("Updated at \(entry.date.shortTime)")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Large (.systemLarge)

    /// Full-bleed board with a single-line metadata strip below it.
    @ViewBuilder
    private var largeView: some View {
        VStack(spacing: 0) {
            boardView

            Divider()

            HStack(spacing: 8) {
                Image("LichessLogo")
                    .resizable()
                    .frame(width: 13, height: 13)
                Text("Daily Puzzle")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.primary)

                Spacer(minLength: 4)

                Circle()
                    .fill(entry.isWhiteToMove ? Color.white : Color.black)
                    .overlay(Circle().stroke(Color.secondary.opacity(0.4), lineWidth: 0.5))
                    .frame(width: 8, height: 8)
                Text(entry.isWhiteToMove ? "White to play" : "Black to play")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)

                if let rating = entry.rating {
                    Text("·")
                        .foregroundStyle(.secondary)
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                    Text("\(rating)")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }

                Text("·")
                    .foregroundStyle(.secondary)
                Text(entry.date.shortTime)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
        }
    }

    // MARK: - Reusable sub-views

    @ViewBuilder
    private var boardView: some View {
        if let fen = entry.fen {
            ChessBoardView(fen: fen, lastMove: entry.lastMove, flipped: !entry.isWhiteToMove)
        } else {
            Color.secondary.opacity(0.2)
        }
    }

    private var header: some View {
        HStack(spacing: 6) {
            Image("LichessLogo")
                .resizable()
                .frame(width: 18, height: 18)
            Text("Daily Puzzle")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
    }

    private var sideToMoveRow: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(entry.isWhiteToMove ? Color.white : Color.black)
                .overlay(Circle().stroke(Color.secondary.opacity(0.4), lineWidth: 0.5))
                .frame(width: 11, height: 11)
            Text(entry.isWhiteToMove ? "White to play" : "Black to play")
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
    }

    private func ratingRow(_ rating: Int) -> some View {
        Label("\(rating)", systemImage: "chart.line.uptrend.xyaxis")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }

    /// Compact one-line bar shown under the board in the small widget.
    private var sideToMoveBar: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(entry.isWhiteToMove ? Color.white : Color.black)
                .overlay(Circle().stroke(Color.secondary.opacity(0.4), lineWidth: 0.5))
                .frame(width: 8, height: 8)
            Text(entry.isWhiteToMove ? "White to play" : "Black to play")
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Error state

    @ViewBuilder
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 20))
                .foregroundStyle(.secondary)
            Text("Could not load puzzle")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
