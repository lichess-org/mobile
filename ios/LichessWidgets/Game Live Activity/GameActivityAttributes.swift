import ActivityKit
import Foundation

// Shared by the Runner target (which starts and updates the activity) and the widget extension
// (which renders it), so both sides agree on the type ActivityKit matches them by.

@available(iOS 16.2, *)
struct GameActivityAttributes: ActivityAttributes {
    enum Side: String, Codable, Hashable {
        case white
        case black

        var opposite: Side { self == .white ? .black : .white }
    }

    struct Player: Codable, Hashable {
        let name: String
        let title: String?
        let rating: Int?
    }

    struct ContentState: Codable, Hashable {
        /// Board part of the FEN only (no pockets, no promoted-piece markers).
        let fen: String
        /// UCI of the last move, for the highlight.
        let lastMove: String?
        let lastSan: String?
        let turn: Side
        /// Remaining time in milliseconds, as of `clockAt`.
        let whiteClock: Int
        let blackClock: Int
        /// Epoch milliseconds of the clock snapshot.
        let clockAt: Double
        /// Whether the clock of `turn` is running.
        let clockRunning: Bool
        /// Whether lila's claim-victory rule can apply if the player leaves the game.
        let claimable: Bool
        /// Milliseconds after lila counts the player as gone to warn them that they left the game,
        /// or nil to warn as soon as the app stops running.
        let leftWarningDelay: Int?
        /// Whether the game socket is down while the app still runs, so the app is trying to
        /// reconnect. Set by the Runner plugin, absent from the state sent by Dart.
        var reconnecting: Bool?
    }

    let gameFullId: String
    let myColor: Side
    let white: Player
    let black: Player
}

@available(iOS 16.2, *)
extension GameActivityAttributes {
    var opponent: Player { myColor == .white ? black : white }
}

@available(iOS 16.2, *)
extension GameActivityAttributes.ContentState {
    func clock(of side: GameActivityAttributes.Side) -> Int {
        side == .white ? whiteClock : blackClock
    }

    var isReconnecting: Bool { reconnecting ?? false }

    var clockAtDate: Date { Date(timeIntervalSince1970: clockAt / 1000) }

    /// Whether the clock of `side` is ticking.
    func isClockRunning(for side: GameActivityAttributes.Side) -> Bool {
        clockRunning && turn == side
    }

    /// When the clock of `side` reaches zero, assuming it keeps running.
    func flagDate(of side: GameActivityAttributes.Side) -> Date {
        clockAtDate.addingTimeInterval(Double(clock(of: side)) / 1000)
    }
}
