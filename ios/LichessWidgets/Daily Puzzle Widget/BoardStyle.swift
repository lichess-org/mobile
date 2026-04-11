import SwiftUI

/// Board colours matching the theme the main Lichess app is currently using.
struct BoardStyle {
    let lightSquare: Color
    let darkSquare: Color
    let lastMoveHighlight: Color

    /// Reads the saved board theme from the shared App Group and returns matching colours.
    static func fromAppGroup() -> BoardStyle {
        let themeName =
            UserDefaults(suiteName: LichessAppGroup.id)?
            .string(forKey: LichessAppGroup.boardThemeKey) ?? "brown"
        return BoardStyle.from(themeName: themeName)
    }

    // MARK: - Theme → colour mapping
    //
    // Colours are taken from the Dart `ChessboardColorScheme` constants in the
    // chessground package (board_color_scheme.dart).  Image-backed themes reuse
    // the light/dark square hex values from those constants.

    // swiftlint:disable:next function_body_length
    static func from(themeName: String) -> BoardStyle {
        let teal = Color(red: 0, green: 155 / 255, blue: 199 / 255).opacity(0.41)
        switch themeName {
        case "blue":
            return .init(light: 0xDEE3E6, dark: 0x8CA2AD)
        case "blue2":
            return .init(light: 0x97B2C7, dark: 0x546F82)
        case "blue3":
            return .init(light: 0xD9E0E6, dark: 0x315991)
        case "blueMarble":
            return .init(light: 0xEAE6DD, dark: 0x7C7F87)
        case "canvas":
            return .init(light: 0xD7DAEB, dark: 0x547388)
        case "green":
            return .init(light: 0xFFFFDD, dark: 0x86A666, lastMove: teal)
        case "greenPlastic":
            return .init(light: 0xF2F9BB, dark: 0x59935D, lastMove: teal)
        case "grey":
            return .init(light: 0xB8B8B8, dark: 0x7D7D7D)
        case "horsey":
            return .init(light: 0xF0D9B5, dark: 0x946F51)
        case "ic":
            return .init(light: 0xECECEC, dark: 0xC1C18E)
        case "leather":
            return .init(light: 0xD1D1C9, dark: 0xC28E16)
        case "maple":
            return .init(light: 0xE8CEAB, dark: 0xBC7944)
        case "maple2":
            return .init(light: 0xE2C89F, dark: 0x996633)
        case "marble":
            return .init(light: 0x93AB91, dark: 0x4F644E, lastMove: teal)
        case "metal":
            return .init(light: 0xC9C9C9, dark: 0x727272)
        case "newspaper":
            return .init(light: 0xFFFFFF, dark: 0x8D8D8D)
        case "olive":
            return .init(light: 0xB8B19F, dark: 0x6D6655)
        case "pinkPyramid":
            return .init(light: 0xE8E9B7, dark: 0xED7272)
        case "purple":
            return .init(light: 0x9F90B0, dark: 0x7D4A8D)
        case "purpleDiag":
            return .init(light: 0xE5DAF0, dark: 0x957AB0)
        case "wood":
            return .init(light: 0xD8A45B, dark: 0x9B4D0F)
        case "wood2":
            return .init(light: 0xA38B5D, dark: 0x6C5017)
        case "wood3":
            return .init(light: 0xD0CECA, dark: 0x755839)
        case "wood4":
            return .init(light: 0xCAAF7D, dark: 0x7B5330)
        default:  // "brown", "system", and any unknown value
            return .init(light: 0xF0D9B6, dark: 0xB58863)
        }
    }

    // MARK: - Private init

    private static let defaultLastMove =
        Color(red: 156 / 255, green: 199 / 255, blue: 0).opacity(0.502)

    private init(light: UInt, dark: UInt, lastMove: Color? = nil) {
        lightSquare = Color(rgb: light)
        darkSquare = Color(rgb: dark)
        lastMoveHighlight = lastMove ?? BoardStyle.defaultLastMove
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
