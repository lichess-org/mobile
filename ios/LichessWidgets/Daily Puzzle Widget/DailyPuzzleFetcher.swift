import ChessgroundAssets
import Foundation

struct DailyPuzzleFetcher {
    /// Returns the date of the next update.
    ///
    /// On success: fetchTime + 6 h. Devices naturally stagger across the day
    /// based on when the widget was first added, so no explicit jitter is needed.
    /// On failure: 1 hour from the fetch time so a transient error is retried promptly.
    static func nextUpdate(for entry: DailyPuzzleEntry) -> Date {
        entry.error == nil
            ? entry.date.addingTimeInterval(6 * 3600)
            : entry.date.addingTimeInterval(3600)
    }

    static func fetchEntry(showRating: Bool) async -> DailyPuzzleEntry {
        let boardStyle = ChessboardTheme.fromAppGroup()
        guard let url = LichessAppGroup.lichessURL(path: "/api/puzzle/daily") else {
            return errorEntry(showRating: showRating, boardStyle: boardStyle)
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try parse(data, showRating: showRating, boardStyle: boardStyle)
        } catch {
            return errorEntry(showRating: showRating, boardStyle: boardStyle)
        }
    }

    // MARK: - Private

    private struct APIResponse: Decodable {
        struct Puzzle: Decodable {
            let id: String
            let rating: Int
            let fen: String
            let lastMove: String
        }
        let puzzle: Puzzle
    }

    private static func parse(_ data: Data,
                               showRating: Bool,
                               boardStyle: ChessboardTheme) throws -> DailyPuzzleEntry {
        let response = try JSONDecoder().decode(APIResponse.self, from: data)
        return DailyPuzzleEntry(date: .now,
                                puzzleId: response.puzzle.id,
                                fen: response.puzzle.fen,
                                lastMove: response.puzzle.lastMove,
                                rating: response.puzzle.rating,
                                showRating: showRating,
                                boardStyle: boardStyle,
                                error: nil)
    }

    private static func errorEntry(showRating: Bool, boardStyle: ChessboardTheme) -> DailyPuzzleEntry {
        DailyPuzzleEntry(date: .now,
                         puzzleId: nil,
                         fen: nil,
                         lastMove: nil,
                         rating: nil,
                         showRating: showRating,
                         boardStyle: boardStyle,
                         error: "Could not load puzzle")
    }
}
