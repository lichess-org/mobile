import Foundation

enum LichessAppGroup {
    static let id = "group.org.lichess.mobileV2"

    // Key must match the string passed to HomeWidget.saveWidgetData in lib/src/app.dart.
    static let kidModeKey = "isKidMode"

    static var isKidModeActive: Bool {
        UserDefaults(suiteName: id)?.bool(forKey: kidModeKey) ?? false
    }
}
