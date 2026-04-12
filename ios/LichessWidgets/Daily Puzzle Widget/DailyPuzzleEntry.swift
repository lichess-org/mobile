import WidgetKit

struct DailyPuzzleEntry: TimelineEntry {
    let date: Date
    let puzzleId: String?
    let fen: String?
    let lastMove: String?
    let rating: Int?
    let showRating: Bool
    let boardStyle: BoardStyle
    let error: String?

    var isWhiteToMove: Bool {
        guard let fen else { return true }
        let parts = fen.split(separator: " ")
        guard parts.count >= 2 else { return true }
        return parts[1] == "w"
    }

    var puzzleURL: URL? {
        let host = LichessAppGroup.lichessHost
        let scheme = host.hasPrefix("localhost") ? "http" : "https"
        if let id = puzzleId {
            return URL(string: "\(scheme)://\(host)/training/\(id)")
        } else {
            return URL(string: "\(scheme)://\(host)/training/daily")
        }
    }

    /// A recognisable position (Italian game after initial moves)
    /// used as placeholder while the real puzzle loads.
    static var placeholder: DailyPuzzleEntry {
        DailyPuzzleEntry(
            date: .now,
            puzzleId: nil,
            fen: "r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 2 3",
            lastMove: "b8c6",
            rating: 1500,
            showRating: true,
            boardStyle: BoardStyle.fromAppGroup(),
            error: nil
        )
    }
}
