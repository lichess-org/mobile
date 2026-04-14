import Foundation

// Note: the daily-puzzle widget uses the `org.lichess.mobile://training/daily`
// custom scheme (optionally suffixed with `/{puzzleId}`) so the Flutter app
// always opens the native "Daily Puzzle" screen for the tapped puzzle.

private let kScheme = "org.lichess.mobile"

/// Builds `org.lichess.mobile://training/daily[/{puzzleId}]` deeplinks handled
/// by the Flutter app to open the native daily-puzzle screen. See `AppLinksService`.
func dailyPuzzleDeeplink(puzzleId: String?) -> URL? {
    if let puzzleId {
        return URL(string: "\(kScheme)://training/daily/\(puzzleId)")
    }
    return URL(string: "\(kScheme)://training/daily")
}

extension String {
    /// Encodes the string into the custom scheme the app listens for to open it in the in-app browser.
    var lichessWebURL: URL? {
        guard let encoded = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        return URL(string: "\(kScheme)://open-web?url=\(encoded)")
    }
}
