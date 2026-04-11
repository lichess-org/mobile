import Foundation

struct DailyPuzzleFetcher {
    /// The next update is scheduled for 00:05 the following day, giving the server
    /// a few minutes to publish the new puzzle after midnight.
    static var nextUpdateDate: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        components.day = (components.day ?? 0) + 1
        components.hour = 0
        components.minute = 5
        components.second = 0
        return Calendar.current.date(from: components)
            ?? Calendar.current.date(byAdding: .hour, value: 24, to: .now)!
    }

    func fetchEntry(showRating: Bool) async -> DailyPuzzleEntry {
        guard let url = URL(string: "https://lichess.org/api/puzzle/daily") else {
            return errorEntry(showRating: showRating)
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try parse(data, showRating: showRating)
        } catch {
            return errorEntry(showRating: showRating)
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

    private func parse(_ data: Data, showRating: Bool) throws -> DailyPuzzleEntry {
        let response = try JSONDecoder().decode(APIResponse.self, from: data)
        return DailyPuzzleEntry(
            date: .now,
            puzzleId: response.puzzle.id,
            fen: response.puzzle.fen,
            lastMove: response.puzzle.lastMove,
            rating: response.puzzle.rating,
            showRating: showRating,
            error: nil
        )
    }

    private func errorEntry(showRating: Bool) -> DailyPuzzleEntry {
        DailyPuzzleEntry(
            date: .now,
            puzzleId: nil,
            fen: nil,
            lastMove: nil,
            rating: nil,
            showRating: showRating,
            error: "Could not load puzzle"
        )
    }
}
