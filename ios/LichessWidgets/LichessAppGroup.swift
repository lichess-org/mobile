import Foundation

enum LichessAppGroup {
    static let id = "group.org.lichess.mobileV2"

    // Keys must match the strings passed to HomeWidget.saveWidgetData in lib/src/app.dart.
    static let kidModeKey = "isKidMode"
    static let boardThemeKey = "boardTheme"
    static let pieceSetKey = "pieceSet"

    static var isKidModeActive: Bool {
        UserDefaults(suiteName: id)?.bool(forKey: kidModeKey) ?? false
    }
}
