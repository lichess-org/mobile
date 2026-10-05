import ActivityKit
import ChessgroundAssets
import SwiftUI
import WidgetKit

/// Live Activity for an ongoing real-time game.
///
/// The app updates it while it runs. Once the app is suspended nothing updates it any more: the
/// Runner plugin sets the `staleDate` to the predicted suspension time, and when `isStale` flips the
/// view replaces the clocks with a "You left the game" warning.
///
/// No `widgetURL`: tapping the activity just brings the app back, where the game screen is already
/// open.
struct GameLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GameActivityAttributes.self) { context in
            GameActivityLockScreenView(context: context)
                .padding(GameActivityLayout.lockScreenPadding)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    // Inset, so that the island's rounded corners don't cut into the board.
                    GameActivityLockScreenView(context: context, boardSize: GameActivityLayout.expandedBoardSize)
                        .padding([.horizontal, .bottom], GameActivityLayout.expandedInset)
                }
            } compactLeading: {
                if context.isStale {
                    LeftGameIcon()
                } else {
                    TurnPawn(side: context.state.turn, isMyTurn: context.isMyTurn)
                }
            } compactTrailing: {
                CompactTrailingView(context: context)
            } minimal: {
                if context.isStale {
                    LeftGameIcon()
                } else {
                    TurnPawn(side: context.state.turn, isMyTurn: context.isMyTurn)
                }
            }
            .keylineTint(context.isStale ? lichessOrange : nil)
        }
    }
}

/// Lichess green (`LichessColors.secondary` in the app), marking the user's turn.
private let lichessGreen = Color(red: 0x62 / 255, green: 0x99 / 255, blue: 0x24 / 255)

/// Lichess orange (`LichessColors.accent` in the app), for the "You left the game" warning.
private let lichessOrange = Color(red: 0xD6 / 255, green: 0x4F / 255, blue: 0x00 / 255)

/// Lichess gold (`LichessColors.brag` in the app, `--c-brag` on the website), for titles.
private let lichessGold = Color(red: 0xBF / 255, green: 0x81 / 255, blue: 0x1D / 255)

private extension ActivityViewContext<GameActivityAttributes> {
    var isMyTurn: Bool { state.turn == attributes.myColor }
}

private enum GameActivityLayout {
    static let lockScreenPadding: CGFloat = 14
    static let lockScreenBoardSize: CGFloat = 100
    static let expandedBoardSize: CGFloat = 76
    static let expandedInset: CGFloat = 12
    static let boardCornerRadius: CGFloat = 4
    static let columnSpacing: CGFloat = 12
    static let rowSpacing: CGFloat = 6
    static let pawnSize: CGFloat = 20
    static let pawnOutlineWidth: CGFloat = 1.5
    static let compactClockWidth: CGFloat = 52
}

// MARK: - Lock Screen / expanded

/// The board and the info column next to it.
private struct GameActivityLockScreenView: View {
    let context: ActivityViewContext<GameActivityAttributes>
    var boardSize: CGFloat = GameActivityLayout.lockScreenBoardSize

    var body: some View {
        HStack(spacing: GameActivityLayout.columnSpacing) {
            GameBoard(context: context, size: boardSize)
            GameInfoColumn(context: context)
        }
        .frame(height: boardSize)
    }
}

private struct GameBoard: View {
    let context: ActivityViewContext<GameActivityAttributes>
    let size: CGFloat

    var body: some View {
        ChessBoardView(
            fen: context.state.fen,
            lastMove: context.state.lastMove,
            flipped: context.attributes.myColor == .black,
            boardStyle: .fromAppGroup()
        )
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: GameActivityLayout.boardCornerRadius))
    }
}

/// The opponent and their clock at the top, next to the board's top edge; the status and the
/// user's clock at the bottom, next to the board's bottom edge, where the user's pieces are.
private struct GameInfoColumn: View {
    let context: ActivityViewContext<GameActivityAttributes>

    private var attributes: GameActivityAttributes { context.attributes }
    private var state: GameActivityAttributes.ContentState { context.state }

    var body: some View {
        VStack(alignment: .leading, spacing: GameActivityLayout.rowSpacing) {
            // Pinned to the top by its own frame rather than by a spacer: a running timer text is
            // greedy and would take the spacer's room, pushing the opponent's clock down.
            VStack(alignment: .leading, spacing: GameActivityLayout.rowSpacing) {
                OpponentLine(player: attributes.opponent)
                if !context.isStale {
                    PlayerClock(
                        state: state, side: attributes.myColor.opposite, isMe: false, alignment: .leading
                    )
                    .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            HStack(alignment: .lastTextBaseline) {
                StatusLine(myColor: attributes.myColor, state: state, isStale: context.isStale)
                if !context.isStale {
                    Spacer(minLength: 4)
                    PlayerClock(state: state, side: attributes.myColor, isMe: true, alignment: .trailing)
                        .font(.title3)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

/// The opponent's title (in gold, as on the website), name and rating.
private struct OpponentLine: View {
    let player: GameActivityAttributes.Player

    var body: some View {
        HStack(spacing: 6) {
            Group {
                if let title = player.title {
                    Text("\(Text(title).bold().foregroundStyle(lichessGold)) \(player.name)")
                } else {
                    Text(player.name)
                }
            }
            .lineLimit(1)
            if let rating = player.rating {
                Text("\(rating)")
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .font(.subheadline)
    }
}

/// A player's clock: bold while running, in green if it's the user's; greyed out otherwise.
private struct PlayerClock: View {
    let state: GameActivityAttributes.ContentState
    let side: GameActivityAttributes.Side
    let isMe: Bool
    /// A running clock takes all the width it is given, so its text must be aligned explicitly.
    let alignment: TextAlignment

    var body: some View {
        let isRunning = state.isClockRunning(for: side)
        GameClockText(state: state, side: side, alignment: alignment)
            .fixedSize(horizontal: false, vertical: true)
            .monospacedDigit()
            .fontWeight(isRunning ? .bold : .regular)
            .foregroundStyle(
                isRunning
                    ? (isMe ? AnyShapeStyle(lichessGreen) : AnyShapeStyle(.primary))
                    : AnyShapeStyle(.secondary)
            )
    }
}

private struct StatusLine: View {
    let myColor: GameActivityAttributes.Side
    let state: GameActivityAttributes.ContentState
    let isStale: Bool

    var body: some View {
        if isStale {
            Label {
                Text(
                    state.claimable
                        ? "You left the game. Return or the opponent can claim victory soon."
                        : "You left the game."
                )
            } icon: {
                Image(systemName: "exclamationmark.triangle.fill")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(lichessOrange)
            .lineLimit(3)
            .minimumScaleFactor(0.8)
        } else {
            Text(headline)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isMyTurn ? AnyShapeStyle(lichessGreen) : AnyShapeStyle(.primary))
        }
    }

    private var isMyTurn: Bool { state.offer == nil && state.turn == myColor }

    private var headline: String {
        switch state.offer {
        case .draw: return "Your opponent offers a draw"
        case .takeback: return "Your opponent proposes a takeback"
        case nil: return state.turn == myColor ? "Your turn" : "Waiting for opponent"
        }
    }
}

// MARK: - Dynamic Island

/// The clock of the side to move: in green on the user's turn, greyed out on the opponent's.
private struct CompactTrailingView: View {
    let context: ActivityViewContext<GameActivityAttributes>

    var body: some View {
        if context.isStale {
            Text("Return")
                .font(.caption.weight(.semibold))
                .foregroundStyle(lichessOrange)
        } else {
            GameClockText(state: context.state, side: context.state.turn, alignment: .trailing)
                .font(.caption.monospacedDigit().weight(context.isMyTurn ? .bold : .semibold))
                .foregroundStyle(context.isMyTurn ? AnyShapeStyle(lichessGreen) : AnyShapeStyle(.secondary))
                .frame(maxWidth: GameActivityLayout.compactClockWidth)
        }
    }
}

private struct LeftGameIcon: View {
    var body: some View {
        Image(systemName: "exclamationmark.triangle.fill")
            .foregroundStyle(lichessOrange)
    }
}

// MARK: - Shared pieces

/// A pawn of the side to move, in the user's piece set, dimmed on the opponent's turn.
///
/// The Dynamic Island is always black, so the black pawn gets a white outline to stay visible: a
/// white silhouette of the pawn drawn underneath, shifted in eight directions.
private struct TurnPawn: View {
    let side: GameActivityAttributes.Side
    let isMyTurn: Bool

    private var assetName: String {
        let color = side == .white ? "w" : "b"
        let name = "piece_\(ChessboardTheme.fromAppGroup().pieceSet)_\(color)P"
        if UIImage(named: name, in: ChessgroundAssets.bundle, compatibleWith: nil) != nil { return name }
        return "piece_\(ChessboardTheme.defaultPieceSet)_\(color)P"
    }

    private static let outlineOffsets: [CGSize] = (0..<8).map { i in
        let angle = Double(i) * .pi / 4
        return CGSize(
            width: cos(angle) * GameActivityLayout.pawnOutlineWidth,
            height: sin(angle) * GameActivityLayout.pawnOutlineWidth
        )
    }

    var body: some View {
        ZStack {
            if side == .black {
                ForEach(Self.outlineOffsets.indices, id: \.self) { i in
                    Image(assetName, bundle: ChessgroundAssets.bundle)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white)
                        .offset(Self.outlineOffsets[i])
                }
            }
            Image(assetName, bundle: ChessgroundAssets.bundle)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(width: GameActivityLayout.pawnSize, height: GameActivityLayout.pawnSize)
        .opacity(isMyTurn ? 1 : 0.5)
    }
}

/// A clock that the system counts down by itself while it runs, so it keeps ticking with no
/// updates from the app.
private struct GameClockText: View {
    let state: GameActivityAttributes.ContentState
    let side: GameActivityAttributes.Side
    let alignment: TextAlignment

    var body: some View {
        if state.isClockRunning(for: side) {
            // The system countdown rounds the remaining seconds up (it shows 0:01 during the last
            // second), while lichess clocks round down. Ending it one second early makes it show
            // the same value as the lichess clock, and the non-running format below.
            let start = state.clockAtDate
            let end = state.flagDate(of: side).addingTimeInterval(-1)
            Text(timerInterval: start...max(start, end), countsDown: true)
                .multilineTextAlignment(alignment)
        } else {
            Text(Self.format(milliseconds: state.clock(of: side)))
        }
    }

    static func format(milliseconds: Int) -> String {
        let totalSeconds = max(0, milliseconds) / 1000
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return hours > 0
            ? String(format: "%d:%02d:%02d", hours, minutes, seconds)
            : String(format: "%d:%02d", minutes, seconds)
    }
}
