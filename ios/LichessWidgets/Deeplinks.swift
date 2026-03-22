import Foundation

extension String {
    /// Encodes the string into the custom scheme the app listens for to open it in the in-app browser.
    var lichessWebURL: URL? {
        guard let encoded = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        return URL(string: "org.lichess.mobile://open-web?url=\(encoded)")
    }
}
