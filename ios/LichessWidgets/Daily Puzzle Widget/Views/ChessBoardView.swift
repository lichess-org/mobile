import SwiftUI

/// Renders a chess position from a FEN string as an 8×8 grid.
///
/// The board background exactly matches the main Lichess app:
/// - Image-backed themes (wood, marble, …) draw the full board texture image and
///   lay highlights and pieces on top.
/// - Solid-colour themes (brown, blue, green, ic) draw individual light/dark squares.
///
/// Piece images are driven by `boardStyle.pieceSet`; all piece sets supported by
/// the app are bundled in the widget extension's `Assets.xcassets`.
struct ChessBoardView: View {
    let fen: String
    let lastMove: String?
    let flipped: Bool
    let boardStyle: BoardStyle

    // MARK: - FEN parsing

    private var board: [[Character?]] {
        let position = fen.split(separator: " ").first.map(String.init) ?? fen
        let ranks = position.split(separator: "/", omittingEmptySubsequences: false)
        guard ranks.count == 8 else { return [] }
        return ranks.map { rank in
            var row: [Character?] = []
            for ch in rank {
                if let n = ch.wholeNumberValue {
                    row.append(contentsOf: Array(repeating: nil, count: n))
                } else {
                    row.append(ch)
                }
            }
            return row
        }
    }

    private var highlightedSquares: Set<String> {
        guard let lm = lastMove, lm.count >= 4 else { return [] }
        return [String(lm.prefix(2)), String(lm.dropFirst(2).prefix(2))]
    }

    private func squareName(rankIndex: Int, fileIndex: Int) -> String {
        let files = "abcdefgh"
        let fileChar = files[files.index(files.startIndex, offsetBy: fileIndex)]
        return "\(fileChar)\(8 - rankIndex)"
    }

    // MARK: - Body

    var body: some View {
        let boardData = board
        let highlighted = highlightedSquares

        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let sq = side / 8

            ZStack {
                // ── Board background ──────────────────────────────────────────
                // Image-backed themes: one full-board texture scaled to fill.
                // Solid-colour themes: drawn square-by-square in the grid below.
                if let imageName = boardStyle.boardImageName {
                    Image(imageName)
                        .resizable()
                        .frame(width: side, height: side)
                }

                // ── Square grid: solid fill · highlights · pieces ─────────────
                VStack(spacing: 0) {
                    ForEach(0 ..< 8, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0 ..< 8, id: \.self) { col in
                                let ri = flipped ? 7 - row : row
                                let fi = flipped ? 7 - col : col
                                let isLight = (ri + fi) % 2 != 0
                                let name = squareName(rankIndex: ri, fileIndex: fi)
                                let piece: Character? =
                                    ri < boardData.count && fi < boardData[ri].count
                                    ? boardData[ri][fi] : nil

                                ZStack {
                                    // Solid fill only for non-image themes
                                    if boardStyle.boardImageName == nil {
                                        Rectangle()
                                            .fill(
                                                isLight
                                                    ? boardStyle.lightSquare
                                                    : boardStyle.darkSquare
                                            )
                                    }
                                    if highlighted.contains(name) {
                                        Rectangle().fill(boardStyle.lastMoveHighlight)
                                    }
                                    if let piece {
                                        ChessPieceView(
                                            piece: piece,
                                            squareSize: sq,
                                            pieceSet: boardStyle.pieceSet
                                        )
                                    }
                                }
                                .frame(width: sq, height: sq)
                            }
                        }
                    }
                }
                .frame(width: side, height: side)
            }
            .frame(width: side, height: side)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Piece view

private struct ChessPieceView: View {
    let piece: Character
    let squareSize: CGFloat
    /// The Dart `PieceSet` enum `.name` value (e.g. `"staunty"`, `"kiwenSuwi"`).
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
            .frame(width: squareSize * 0.9, height: squareSize * 0.9)
    }
}
