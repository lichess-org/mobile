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

    func fetchEntry() async -> DailyPuzzleEntry {
        guard let url = URL(string: "https://lichess.org/api/puzzle/daily") else {
            return errorEntry("Invalid URL")
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try parse(data)
        } catch {
            return errorEntry(error.localizedDescription)
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

    private func parse(_ data: Data) throws -> DailyPuzzleEntry {
        let response = try JSONDecoder().decode(APIResponse.self, from: data)
        return DailyPuzzleEntry(
            date: .now,
            puzzleId: response.puzzle.id,
            fen: response.puzzle.fen,
            lastMove: response.puzzle.lastMove,
            rating: response.puzzle.rating,
            error: nil
        )
    }

    private func errorEntry(_ message: String) -> DailyPuzzleEntry {
        DailyPuzzleEntry(date: .now, puzzleId: nil, fen: nil, lastMove: nil, rating: nil, error: message)
    }
}
