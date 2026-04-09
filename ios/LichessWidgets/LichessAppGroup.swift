import Foundation

enum LichessAppGroup {
    static let id = "group.org.lichess.mobileV2"

    static var isKidModeActive: Bool {
        UserDefaults(suiteName: id)?.bool(forKey: "isKidMode") ?? false
    }
}
