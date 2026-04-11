import SwiftUI

/// Board colours and piece-set name matching what the main Lichess app is currently using.
struct BoardStyle {
    let lightSquare: Color
    let darkSquare: Color
    let lastMoveHighlight: Color
    /// The Dart `PieceSet` enum `.name` value (e.g. `"staunty"`, `"kiwenSuwi"`).
    let pieceSet: String

    /// Reads the saved board theme and piece set from the shared App Group.
    static func fromAppGroup() -> BoardStyle {
        let defaults = UserDefaults(suiteName: LichessAppGroup.id)
        let themeName = defaults?.string(forKey: LichessAppGroup.boardThemeKey) ?? "brown"
        let pieceSetName = defaults?.string(forKey: LichessAppGroup.pieceSetKey) ?? "staunty"
        return BoardStyle.from(themeName: themeName, pieceSet: pieceSetName)
    }

    // MARK: - Theme → colour mapping
    //
    // Colours are taken from the Dart `ChessboardColorScheme` constants in the
    // chessground package (board_color_scheme.dart).  Image-backed themes reuse
    // the light/dark square hex values from those constants.

    // swiftlint:disable:next function_body_length
    static func from(themeName: String, pieceSet: String = "staunty") -> BoardStyle {
        switch themeName {
        case "system":
            // The "system" theme uses Android's Material You dynamic colours via
            // CorePalette — a feature that returns nil on iOS, causing the app to
            // fall back to the brown scheme.  We replicate that fallback here.
            return .init(light: 0xF0D9B6, dark: 0xB58863, pieceSet: pieceSet)
        case "blue":
            return .init(light: 0xDEE3E6, dark: 0x8CA2AD, pieceSet: pieceSet)
        case "blue2":
            return .init(light: 0x97B2C7, dark: 0x546F82, pieceSet: pieceSet)
        case "blue3":
            return .init(light: 0xD9E0E6, dark: 0x315991, pieceSet: pieceSet)
        case "blueMarble":
            return .init(light: 0xEAE6DD, dark: 0x7C7F87, pieceSet: pieceSet)
        case "canvas":
            return .init(light: 0xD7DAEB, dark: 0x547388, pieceSet: pieceSet)
        case "green":
            return .init(light: 0xFFFFDD, dark: 0x86A666, lastMove: tealLastMove, pieceSet: pieceSet)
        case "greenPlastic":
            return .init(light: 0xF2F9BB, dark: 0x59935D, lastMove: tealLastMove, pieceSet: pieceSet)
        case "grey":
            return .init(light: 0xB8B8B8, dark: 0x7D7D7D, pieceSet: pieceSet)
        case "horsey":
            return .init(light: 0xF0D9B5, dark: 0x946F51, pieceSet: pieceSet)
        case "ic":
            return .init(light: 0xECECEC, dark: 0xC1C18E, pieceSet: pieceSet)
        case "leather":
            return .init(light: 0xD1D1C9, dark: 0xC28E16, pieceSet: pieceSet)
        case "maple":
            return .init(light: 0xE8CEAB, dark: 0xBC7944, pieceSet: pieceSet)
        case "maple2":
            return .init(light: 0xE2C89F, dark: 0x996633, pieceSet: pieceSet)
        case "marble":
            return .init(light: 0x93AB91, dark: 0x4F644E, lastMove: tealLastMove, pieceSet: pieceSet)
        case "metal":
            return .init(light: 0xC9C9C9, dark: 0x727272, pieceSet: pieceSet)
        case "newspaper":
            return .init(light: 0xFFFFFF, dark: 0x8D8D8D, pieceSet: pieceSet)
        case "olive":
            return .init(light: 0xB8B19F, dark: 0x6D6655, pieceSet: pieceSet)
        case "pinkPyramid":
            return .init(light: 0xE8E9B7, dark: 0xED7272, pieceSet: pieceSet)
        case "purple":
            return .init(light: 0x9F90B0, dark: 0x7D4A8D, pieceSet: pieceSet)
        case "purpleDiag":
            return .init(light: 0xE5DAF0, dark: 0x957AB0, pieceSet: pieceSet)
        case "wood":
            return .init(light: 0xD8A45B, dark: 0x9B4D0F, pieceSet: pieceSet)
        case "wood2":
            return .init(light: 0xA38B5D, dark: 0x6C5017, pieceSet: pieceSet)
        case "wood3":
            return .init(light: 0xD0CECA, dark: 0x755839, pieceSet: pieceSet)
        case "wood4":
            return .init(light: 0xCAAF7D, dark: 0x7B5330, pieceSet: pieceSet)
        default:  // "brown" and any unknown value
            return .init(light: 0xF0D9B6, dark: 0xB58863, pieceSet: pieceSet)
        }
    }

    // MARK: - Private

    /// Teal last-move highlight used by the green, greenPlastic, and marble themes.
    /// Declared as a static constant so it is only ever constructed once.
    private static let tealLastMove =
        Color(red: 0, green: 155 / 255, blue: 199 / 255).opacity(0.41)

    private static let defaultLastMove =
        Color(red: 156 / 255, green: 199 / 255, blue: 0).opacity(0.502)

    private init(light: UInt, dark: UInt, lastMove: Color? = nil, pieceSet: String) {
        lightSquare = Color(rgb: light)
        darkSquare = Color(rgb: dark)
        lastMoveHighlight = lastMove ?? BoardStyle.defaultLastMove
        self.pieceSet = pieceSet
    }
}

// MARK: - Colour helper

extension Color {
    /// Initialises a colour from a 24-bit `0xRRGGBB` integer.
    init(rgb: UInt) {
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255,
            green: Double((rgb >> 8) & 0xFF) / 255,
            blue: Double(rgb & 0xFF) / 255
        )
    }
}
