import SwiftUI

/// Renders a chess position from a FEN string as an 8×8 grid.
///
/// Square colours come from a ``BoardStyle`` that mirrors the board theme the
/// user has selected in the main Lichess app.  Piece images are the staunty
/// PNG set (the app default), bundled directly in the widget extension.
struct ChessBoardView: View {
    /// The FEN string for the position to display.
    let fen: String
    /// The last move in UCI notation (e.g. `"a4c5"`), used to highlight squares.
    let lastMove: String?
    /// When `true` the board is shown from Black's perspective (Black at the bottom).
    let flipped: Bool
    /// Board colours matching the main app's current theme.
    let boardStyle: BoardStyle

    // MARK: - FEN parsing

    /// Returns an 8×8 grid where `board[rankIndex][fileIndex]`:
    ///  - `rankIndex 0` = rank 8 (Black's back rank)
    ///  - `fileIndex 0` = file a
    ///  - `nil` = empty square
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

    /// The set of algebraic square names covered by `lastMove` (e.g. `{"a4","c5"}`).
    private var highlightedSquares: Set<String> {
        guard let lm = lastMove, lm.count >= 4 else { return [] }
        return [String(lm.prefix(2)), String(lm.dropFirst(2).prefix(2))]
    }

    // MARK: - Coordinate helpers

    /// Converts a board-array coordinate to algebraic notation ("a8", "h1", …).
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
                                Rectangle()
                                    .fill(isLight ? boardStyle.lightSquare : boardStyle.darkSquare)
                                if highlighted.contains(name) {
                                    Rectangle().fill(boardStyle.lastMoveHighlight)
                                }
                                if let piece {
                                    ChessPieceView(piece: piece, squareSize: sq)
                                }
                            }
                            .frame(width: sq, height: sq)
                        }
                    }
                }
            }
            .frame(width: side, height: side)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Piece view

/// Draws a single chess piece using the bundled staunty PNG asset set.
private struct ChessPieceView: View {
    let piece: Character
    let squareSize: CGFloat

    /// Returns the xcassets name for this piece, e.g. `"piece_staunty_wK"`.
    private var assetName: String {
        let color = piece.isUppercase ? "w" : "b"
        let kind = piece.uppercased()
        return "piece_staunty_\(color)\(kind)"
    }

    var body: some View {
        Image(assetName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: squareSize * 0.9, height: squareSize * 0.9)
    }
}
