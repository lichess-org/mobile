import ChessgroundAssets
import WidgetKit

struct DailyPuzzleEntry: TimelineEntry {
    let date: Date
    let puzzleId: String?
    let fen: String?
    let lastMove: String?
    let boardStyle: ChessboardTheme
    let error: String?

    var isWhiteToMove: Bool {
        guard let fen else { return true }
        let parts = fen.split(separator: " ")
        guard parts.count >= 2 else { return true }
        return parts[1] == "w"
    }

    /// Custom-scheme deeplink handled by the Flutter app to open the native
    /// daily-puzzle screen (titled "Daily Puzzle"). See `AppLinksService`.
    ///
    /// Includes the specific puzzle id when known so the app opens the same
    /// puzzle the widget is showing (the widget caches the daily puzzle for up
    /// to 6 hours, so a plain `/training/daily` deeplink could otherwise open
    /// a different puzzle than the one tapped).
    var puzzleURL: URL? { dailyPuzzleDeeplink(puzzleId: puzzleId) }

    /// A recognisable position (Italian game after initial moves)
    /// used as placeholder while the real puzzle loads.
    static var placeholder: DailyPuzzleEntry {
        DailyPuzzleEntry(
            date: .now,
            puzzleId: nil,
            fen: "1n3rk1/4ppbp/rq1p2p1/3P4/2p1P3/2N2P1n/PPN3PP/R1BQ1R1K b - - 1 1",
            lastMove: "g1h1",
            boardStyle: ChessboardTheme.fromAppGroup(),
            error: nil
        )
    }
}
