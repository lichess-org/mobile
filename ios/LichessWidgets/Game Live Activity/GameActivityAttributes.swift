import ActivityKit
import Foundation

// Shared by the Runner target (which starts and updates the activity) and the widget extension
// (which renders it), so both sides agree on the type ActivityKit matches them by.
//
// The JSON shape of `GameActivityAttributes` and `ContentState` is the contract with Dart: the
// Runner plugin decodes the maps sent over the `mobile.lichess.org/live_activity` channel with
// `JSONDecoder`. Times are epoch milliseconds rather than `Date`, so the contract stays plain JSON.

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

    enum Status: String, Codable, Hashable {
        case started
        case over
    }

    enum Offer: String, Codable, Hashable {
        case draw
        case takeback
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
        /// A pending offer from the opponent.
        let offer: Offer?
        let status: Status
        /// "1-0", "0-1" or "½-½" once the game is over.
        let result: String?
        /// Whether lila's claim-victory rule can apply if the player leaves the game.
        let claimable: Bool
    }

    let gameFullId: String
    let myColor: Side
    let white: Player
    let black: Player
}

@available(iOS 16.2, *)
extension GameActivityAttributes {
    var me: Player { myColor == .white ? white : black }
    var opponent: Player { myColor == .white ? black : white }
}

@available(iOS 16.2, *)
extension GameActivityAttributes.ContentState {
    func clock(of side: GameActivityAttributes.Side) -> Int {
        side == .white ? whiteClock : blackClock
    }

    var clockAtDate: Date { Date(timeIntervalSince1970: clockAt / 1000) }

    /// Whether the clock of `side` is ticking.
    func isClockRunning(for side: GameActivityAttributes.Side) -> Bool {
        status == .started && clockRunning && turn == side
    }

    /// When the clock of `side` reaches zero, assuming it keeps running.
    func flagDate(of side: GameActivityAttributes.Side) -> Date {
        clockAtDate.addingTimeInterval(Double(clock(of: side)) / 1000)
    }
}
