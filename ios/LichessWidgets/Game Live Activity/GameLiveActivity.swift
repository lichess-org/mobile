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
                    GameActivityLockScreenView(context: context, boardSize: GameActivityLayout.expandedBoardSize)
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
            .keylineTint(context.isStale ? .red : nil)
        }
    }
}

/// Lichess orange (`LichessColors.accent` in the app), marking the user's turn in the Dynamic
/// Island.
private let lichessOrange = Color(red: 0xD6 / 255, green: 0x4F / 255, blue: 0x00 / 255)

private extension ActivityViewContext<GameActivityAttributes> {
    var isMyTurn: Bool { state.status == .started && state.turn == attributes.myColor }
}

private enum GameActivityLayout {
    static let lockScreenPadding: CGFloat = 14
    static let lockScreenBoardSize: CGFloat = 100
    static let expandedBoardSize: CGFloat = 84
    static let boardCornerRadius: CGFloat = 4
    static let columnSpacing: CGFloat = 12
    static let rowSpacing: CGFloat = 6
    static let pawnSize: CGFloat = 18
    static let turnBadgeSize: CGFloat = 24
    static let pawnOutlineWidth: CGFloat = 1.5
    static let compactClockWidth: CGFloat = 52
}

// MARK: - Lock Screen / expanded

private struct GameActivityLockScreenView: View {
    let context: ActivityViewContext<GameActivityAttributes>
    var boardSize: CGFloat = GameActivityLayout.lockScreenBoardSize

    private var attributes: GameActivityAttributes { context.attributes }
    private var state: GameActivityAttributes.ContentState { context.state }

    var body: some View {
        HStack(spacing: GameActivityLayout.columnSpacing) {
            ChessBoardView(
                fen: state.fen,
                lastMove: state.lastMove,
                flipped: attributes.myColor == .black,
                boardStyle: .fromAppGroup()
            )
            .frame(width: boardSize, height: boardSize)
            .clipShape(RoundedRectangle(cornerRadius: GameActivityLayout.boardCornerRadius))

            VStack(alignment: .leading, spacing: GameActivityLayout.rowSpacing) {
                PlayerRow(
                    player: attributes.opponent,
                    side: attributes.myColor.opposite,
                    state: state,
                    showsClock: !context.isStale
                )
                Spacer(minLength: 0)
                StatusLine(myColor: attributes.myColor, state: state, isStale: context.isStale)
                Spacer(minLength: 0)
                PlayerRow(
                    player: attributes.me,
                    side: attributes.myColor,
                    state: state,
                    showsClock: !context.isStale
                )
            }
            .frame(height: boardSize)
        }
    }
}

private struct PlayerRow: View {
    let player: GameActivityAttributes.Player
    let side: GameActivityAttributes.Side
    let state: GameActivityAttributes.ContentState
    let showsClock: Bool

    var body: some View {
        HStack(spacing: 6) {
            Group {
                if let title = player.title {
                    Text("\(Text(title).bold().foregroundStyle(.orange)) \(player.name)")
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
            Spacer(minLength: 4)
            if showsClock {
                GameClockText(state: state, side: side)
                    .font(.body.monospacedDigit().weight(state.isClockRunning(for: side) ? .bold : .regular))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(state.isClockRunning(for: side) ? Color.accentColor.opacity(0.25) : .clear)
                    )
            }
        }
        .font(.subheadline)
    }
}

private struct StatusLine: View {
    let myColor: GameActivityAttributes.Side
    let state: GameActivityAttributes.ContentState
    let isStale: Bool

    var body: some View {
        if state.status == .over {
            Text("Game over\(state.result.map { " · \($0)" } ?? "")")
                .font(.subheadline.weight(.semibold))
        } else if isStale {
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
            .foregroundStyle(.red)
            .lineLimit(3)
            .minimumScaleFactor(0.8)
        } else {
            VStack(alignment: .leading, spacing: 0) {
                Text(headline)
                    .font(.subheadline.weight(.semibold))
                if let lastSan = state.lastSan {
                    Text(lastSan)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var headline: String {
        switch state.offer {
        case .draw: return "Your opponent offers a draw"
        case .takeback: return "Your opponent proposes a takeback"
        case nil: return state.turn == myColor ? "Your turn" : "Waiting for opponent"
        }
    }
}

// MARK: - Dynamic Island

/// The clock of the side to move: in orange on the user's turn, greyed out on the opponent's.
private struct CompactTrailingView: View {
    let context: ActivityViewContext<GameActivityAttributes>

    var body: some View {
        if context.state.status == .over {
            Text(context.state.result ?? "")
                .font(.caption.weight(.semibold))
        } else if context.isStale {
            Text("Return")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.red)
        } else {
            GameClockText(state: context.state, side: context.state.turn)
                .font(.caption.monospacedDigit().weight(context.isMyTurn ? .bold : .semibold))
                .foregroundStyle(context.isMyTurn ? AnyShapeStyle(lichessOrange) : AnyShapeStyle(.secondary))
                .frame(maxWidth: GameActivityLayout.compactClockWidth)
        }
    }
}

private struct LeftGameIcon: View {
    var body: some View {
        Image(systemName: "exclamationmark.triangle.fill")
            .foregroundStyle(.red)
    }
}

// MARK: - Shared pieces

/// A pawn of the side to move, in the user's piece set: on an orange disc on the user's turn,
/// dimmed on the opponent's.
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
        .frame(width: GameActivityLayout.turnBadgeSize, height: GameActivityLayout.turnBadgeSize)
        .background(Circle().fill(isMyTurn ? lichessOrange : .clear))
    }
}

/// A clock that the system counts down by itself while it runs, so it keeps ticking with no
/// updates from the app.
private struct GameClockText: View {
    let state: GameActivityAttributes.ContentState
    let side: GameActivityAttributes.Side

    var body: some View {
        if state.isClockRunning(for: side) {
            // The system countdown rounds the remaining seconds up (it shows 0:01 during the last
            // second), while lichess clocks round down. Ending it one second early makes it show
            // the same value as the lichess clock, and the non-running format below.
            let start = state.clockAtDate
            let end = state.flagDate(of: side).addingTimeInterval(-1)
            Text(timerInterval: start...max(start, end), countsDown: true)
                .multilineTextAlignment(.trailing)
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
