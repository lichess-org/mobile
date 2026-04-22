import ChessgroundAssets
import Foundation

extension ChessboardTheme {
    /// Reads the saved board theme and piece set from the shared App Group.
    static func fromAppGroup() -> ChessboardTheme {
        let defaults = UserDefaults(suiteName: LichessAppGroup.id)
        let themeName = defaults?.string(forKey: LichessAppGroup.boardThemeKey) ?? defaultThemeName
        let pieceSet = defaults?.string(forKey: LichessAppGroup.pieceSetKey) ?? defaultPieceSet
        return .from(themeName: themeName, pieceSet: pieceSet)
    }
}
