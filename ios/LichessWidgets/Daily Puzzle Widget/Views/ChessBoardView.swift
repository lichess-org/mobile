import SwiftUI

/// Renders a chess position from a FEN string as an 8×8 grid.
///
/// Square colours and piece images are driven by a ``BoardStyle`` that mirrors
/// the board theme and piece set the user has selected in the main Lichess app.
/// All piece sets supported by the app are bundled in the widget extension and
/// selected at render time from the piece-set name stored in the App Group.
struct ChessBoardView: View {
    /// The FEN string for the position to display.
    let fen: String
    /// The last move in UCI notation (e.g. `"a4c5"`), used to highlight squares.
    let lastMove: String?
    /// When `true` the board is shown from Black's perspective (Black at the bottom).
    let flipped: Bool
    /// Board colours and piece-set name matching the main app's current settings.
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
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Piece view

/// Draws a single chess piece using the PNG asset bundled for the given piece set.
///
/// Asset names follow the pattern `piece_{pieceSet}_{color}{kind}`, e.g.
/// `piece_cburnett_wK`.  Every piece set supported by the Lichess app is
/// bundled in the widget extension's `Assets.xcassets`, so the lookup always
/// succeeds for a valid piece-set name.
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
