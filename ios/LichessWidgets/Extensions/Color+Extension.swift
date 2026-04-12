import SwiftUI

extension Color {
    /// Initialises a colour from a 24-bit `0xRRGGBB` integer.
    init(rgb: UInt) {
        self.init(red: Double((rgb >> 16) & 0xFF) / 255,
                  green: Double((rgb >> 8) & 0xFF) / 255,
                  blue: Double(rgb & 0xFF) / 255)
    }
}
