import SwiftUI

struct ChessPieceView: View {
    let piece: Character
    let squareSize: CGFloat
    let pieceSet: String

    private func assetName(for pieceSet: String) -> String {
        let color = piece.isUppercase ? "w" : "b"
        let kind = piece.uppercased()
        return "piece_\(pieceSet)_\(color)\(kind)"
    }

    /// Returns the asset name to use, falling back to the default piece set if the
    /// configured one is missing from the widget's asset catalog.
    private var resolvedAssetName: String {
        let name = assetName(for: pieceSet)
        if UIImage(named: name) != nil { return name }
        return assetName(for: BoardStyle.defaultPieceSet)
    }

    var body: some View {
        Image(resolvedAssetName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: squareSize * DailyPuzzleWidgetLayout.pieceSizeFactor,
                   height: squareSize * DailyPuzzleWidgetLayout.pieceSizeFactor)
    }
}
