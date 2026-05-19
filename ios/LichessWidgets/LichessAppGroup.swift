import Foundation

enum LichessAppGroup {
    static let id = "group.org.lichess.mobileV2.LichessWidgets"

    // Keys must match the strings passed to HomeWidget.saveWidgetData in lib/src/app.dart.
    static let kidModeKey = "isKidMode"
    static let boardThemeKey = "boardTheme"
    static let pieceSetKey = "pieceSet"
    static let lichessHostKey = "lichessHost"

    static var isKidModeActive: Bool {
        UserDefaults(suiteName: id)?.bool(forKey: kidModeKey) ?? false
    }

    /// The lichess host configured in the main app (e.g. "lichess.org" or "localhost:8080").
    /// Falls back to "lichess.org" when the main app has never been launched.
    static var lichessHost: String {
        UserDefaults(suiteName: id)?.string(forKey: lichessHostKey) ?? "lichess.org"
    }

    /// Builds a lichess URL for the given path, using http for localhost and https otherwise.
    static func lichessURL(path: String) -> URL? {
        let host = lichessHost
        let scheme = host.hasPrefix("localhost") ? "http" : "https"
        return URL(string: "\(scheme)://\(host)\(path)")
    }
}
