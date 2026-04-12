import SwiftUI

struct ChessPieceView: View {
    let piece: Character
    let squareSize: CGFloat
    let pieceSet: String

    private var assetName: String {
        let color = piece.isUppercase ? "w" : "b"
        let kind = piece.uppercased()
        return "piece_\(pieceSet)_\(color)\(kind)"
    }

    var body: some View {
        Image(assetName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: squareSize * DailyPuzzleWidgetLayout.pieceSizeFactor,
                   height: squareSize * DailyPuzzleWidgetLayout.pieceSizeFactor)
    }
}
