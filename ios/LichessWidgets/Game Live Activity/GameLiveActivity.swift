import ActivityKit
import ChessgroundAssets
import SwiftUI
import WidgetKit

/// Live Activity for an ongoing real-time game.
///
/// The app updates it while it runs. Once the app is suspended nothing updates it any more: the
/// Runner plugin sets the `staleDate` to the predicted suspension time, and when `isStale` flips the
/// view replaces the clocks with a "You left the game" warning. While the app runs but its game
/// socket is down, the status shows "Reconnecting" instead.
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
                // The board takes the full height of the island, beside the camera. The info column
                // gets all the width that is left (the trailing region has priority over the
                // leading one), and moves below the camera, which it is too wide to sit beside.
                DynamicIslandExpandedRegion(.leading) {
                    // The leading region is wider than the board: the inset moves it towards its centre.
                    GameBoard(context: context, size: GameActivityLayout.boardSize)
                        .padding(.leading, GameActivityLayout.expandedBoardLeadingInset)
                }
                DynamicIslandExpandedRegion(.trailing, priority: 1) {
                    // Trailing inset, so that the island's rounded corner doesn't cut into the clocks.
                    GameInfoColumn(context: context)
                        .padding(.leading, GameActivityLayout.columnSpacing)
                        .padding(.trailing, GameActivityLayout.expandedTrailingInset)
                        .dynamicIsland(verticalPlacement: .belowIfTooWide)
                }
            } compactLeading: {
                GameBoard(context: context, size: GameActivityLayout.compactBoardSize)
            } compactTrailing: {
                CompactTrailingView(context: context)
            } minimal: {
                if context.isStale {
                    LeftGameIcon()
                } else if context.state.isReconnecting {
                    ReconnectingIcon()
                } else {
                    GameBoard(context: context, size: GameActivityLayout.compactBoardSize)
                }
            }
            .keylineTint(
                context.isStale ? lichessOrange : context.state.isReconnecting ? lichessRed : nil
            )
        }
    }
}

private let lichessGreen = Color(red: 0x62 / 255, green: 0x99 / 255, blue: 0x24 / 255)
private let lichessOrange = Color(red: 0xD6 / 255, green: 0x4F / 255, blue: 0x00 / 255)
private let lichessRed = Color(red: 0xCC / 255, green: 0x33 / 255, blue: 0x33 / 255)
private let lichessGold = Color(red: 0xBF / 255, green: 0x81 / 255, blue: 0x1D / 255)

private enum GameActivityLayout {
    static let lockScreenPadding: CGFloat = 14
    /// Both on the Lock Screen and in the expanded island (a larger board gets cut off there).
    static let boardSize: CGFloat = 100
    static let expandedTrailingInset: CGFloat = 8
    static let expandedBoardLeadingInset: CGFloat = 8
    static let boardCornerRadius: CGFloat = 4
    static let columnSpacing: CGFloat = 12
    static let rowSpacing: CGFloat = 6
    /// In the compact and minimal island: its height (about 37 pt) less the system margins around
    /// the regions.
    static let compactBoardSize: CGFloat = 22
}

// MARK: - Lock Screen / expanded

/// The board and the info column next to it.
private struct GameActivityLockScreenView: View {
    let context: ActivityViewContext<GameActivityAttributes>

    var body: some View {
        HStack(spacing: GameActivityLayout.columnSpacing) {
            GameBoard(context: context, size: GameActivityLayout.boardSize)
            GameInfoColumn(context: context)
        }
        .frame(height: GameActivityLayout.boardSize)
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
        } else if state.isReconnecting {
            Label {
                Text("Reconnecting")
            } icon: {
                Image(systemName: ReconnectingIcon.systemName)
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(lichessRed)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
        } else {
            Text(headline)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isMyTurn ? AnyShapeStyle(lichessGreen) : AnyShapeStyle(.primary))
        }
    }

    private var isMyTurn: Bool { state.turn == myColor }

    private var headline: LocalizedStringKey { isMyTurn ? "Your turn" : "Waiting for opponent" }
}

// MARK: - Dynamic Island

/// The user's clock: in green while it runs, greyed out while it waits for the opponent. Once the
/// user left the game, or while reconnecting, a warning icon instead.
private struct CompactTrailingView: View {
    let context: ActivityViewContext<GameActivityAttributes>

    var body: some View {
        if context.isStale {
            LeftGameIcon()
        } else if context.state.isReconnecting {
            ReconnectingIcon()
        } else {
            let side = context.attributes.myColor
            let isRunning = context.state.isClockRunning(for: side)
            // A running timer text takes all the width it is offered, which would widen the island
            // while the user's clock runs. The clock is sized by its non-running text instead,
            // which is as wide as the widest value the timer can show.
            Text(GameClockText.format(milliseconds: context.state.clock(of: side)))
                .hidden()
                .overlay(alignment: .trailing) {
                    GameClockText(state: context.state, side: side, alignment: .trailing)
                }
                .font(.caption.monospacedDigit().weight(isRunning ? .bold : .semibold))
                .foregroundStyle(isRunning ? AnyShapeStyle(lichessGreen) : AnyShapeStyle(.secondary))
        }
    }
}

private struct LeftGameIcon: View {
    var body: some View {
        Image(systemName: "exclamationmark.triangle.fill")
            .foregroundStyle(lichessOrange)
    }
}

private struct ReconnectingIcon: View {
    static let systemName = "wifi.exclamationmark"

    var body: some View {
        Image(systemName: Self.systemName)
            .foregroundStyle(lichessRed)
    }
}

// MARK: - Shared pieces

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

// MARK: - Previews

private extension GameActivityAttributes {
    static let preview = GameActivityAttributes(
        gameFullId: "abcdefgh1234",
        myColor: .white,
        white: Player(name: "veloce", title: nil, rating: 1850),
        black: Player(name: "DrNykterstein", title: "GM", rating: 2850)
    )
}

private extension GameActivityAttributes.ContentState {
    static func preview(turn: GameActivityAttributes.Side, reconnecting: Bool = false) -> Self {
        Self(
            fen: "r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R",
            lastMove: "b8c6",
            lastSan: "Nc6",
            turn: turn,
            whiteClock: 184_000,
            blackClock: 251_000,
            clockAt: Date.now.timeIntervalSince1970 * 1000,
            clockRunning: true,
            claimable: true,
            leftWarningDelay: 30_000,
            reconnecting: reconnecting
        )
    }
}

#Preview("Expanded", as: .dynamicIsland(.expanded), using: GameActivityAttributes.preview) {
    GameLiveActivity()
} contentStates: {
    GameActivityAttributes.ContentState.preview(turn: .white)
    GameActivityAttributes.ContentState.preview(turn: .black)
    GameActivityAttributes.ContentState.preview(turn: .white, reconnecting: true)
}

#Preview("Compact", as: .dynamicIsland(.compact), using: GameActivityAttributes.preview) {
    GameLiveActivity()
} contentStates: {
    GameActivityAttributes.ContentState.preview(turn: .white)
    GameActivityAttributes.ContentState.preview(turn: .black)
    GameActivityAttributes.ContentState.preview(turn: .white, reconnecting: true)
}

#Preview("Minimal", as: .dynamicIsland(.minimal), using: GameActivityAttributes.preview) {
    GameLiveActivity()
} contentStates: {
    GameActivityAttributes.ContentState.preview(turn: .white)
    GameActivityAttributes.ContentState.preview(turn: .black)
    GameActivityAttributes.ContentState.preview(turn: .white, reconnecting: true)
}
