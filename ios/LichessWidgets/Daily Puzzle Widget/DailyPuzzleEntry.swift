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
        if let id = puzzleId {
            URL(string: "https://lichess.org/training/\(id)")
        } else {
            URL(string: "https://lichess.org/training/daily")
        }
    }

    /// A recognisable starting position (Italian game after 1.e4 e5 2.Nf3 Nc6 3.Bc4)
    /// used as placeholder while the real puzzle loads.
    static var placeholder: DailyPuzzleEntry {
        DailyPuzzleEntry(
            date: .now,
            puzzleId: nil,
            fen: "r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3",
            lastMove: "f1c4",
            rating: 1500,
            showRating: true,
            boardStyle: BoardStyle.fromAppGroup(),
            error: nil
        )
    }
}
