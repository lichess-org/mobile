import Foundation

// Note: puzzle widgets use plain HTTPS URLs (e.g. lichess.org/training/{id})
// so the app can handle them as universal links and open the native puzzle screen directly.

extension String {
    /// Encodes the string into the custom scheme the app listens for to open it in the in-app browser.
    var lichessWebURL: URL? {
        guard let encoded = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        return URL(string: "org.lichess.mobile://open-web?url=\(encoded)")
    }
}
