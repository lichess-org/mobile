import Foundation

struct DailyPuzzleFetcher {
    /// The next update is scheduled for 00:05 UTC the following day.
    ///
    /// The daily puzzle is published at midnight UTC, so we use a UTC calendar to
    /// compute the next trigger time rather than the device's local calendar — a
    /// device in UTC+12 would otherwise schedule the reload 12 hours too late.
    static var nextUpdateDate: Date {
        var utc = Calendar(identifier: .gregorian)
        utc.timeZone = TimeZone(identifier: "UTC")!
        var components = utc.dateComponents([.year, .month, .day], from: .now)
        components.day = (components.day ?? 0) + 1
        components.hour = 0
        components.minute = 5
        components.second = 0
        return utc.date(from: components)
            ?? Calendar.current.date(byAdding: .hour, value: 24, to: .now)!
    }

    func fetchEntry(showRating: Bool) async -> DailyPuzzleEntry {
        let boardStyle = BoardStyle.fromAppGroup()
        guard let url = URL(string: "https://lichess.org/api/puzzle/daily") else {
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

    private func parse(_ data: Data, showRating: Bool, boardStyle: BoardStyle) throws
        -> DailyPuzzleEntry
    {
        let response = try JSONDecoder().decode(APIResponse.self, from: data)
        return DailyPuzzleEntry(
            date: .now,
            puzzleId: response.puzzle.id,
            fen: response.puzzle.fen,
            lastMove: response.puzzle.lastMove,
            rating: response.puzzle.rating,
            showRating: showRating,
            boardStyle: boardStyle,
            error: nil
        )
    }

    private func errorEntry(showRating: Bool, boardStyle: BoardStyle) -> DailyPuzzleEntry {
        DailyPuzzleEntry(
            date: .now,
            puzzleId: nil,
            fen: nil,
            lastMove: nil,
            rating: nil,
            showRating: showRating,
            boardStyle: boardStyle,
            error: "Could not load puzzle"
        )
    }
}
