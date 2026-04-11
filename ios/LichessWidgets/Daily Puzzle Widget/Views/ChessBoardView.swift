import SwiftUI

/// Renders a chess position from a FEN string as an 8×8 grid.
///
/// Pieces are drawn using Unicode chess symbols, coloured and shadowed so they
/// remain legible on both light and dark squares.  The last-move squares are
/// highlighted in yellow, matching the lichess default theme.
struct ChessBoardView: View {
    /// The FEN string for the position to display.
    let fen: String
    /// The last move in UCI notation (e.g. `"a4c5"`), used to highlight squares.
    let lastMove: String?
    /// When `true` the board is shown from Black's perspective (Black at the bottom).
    let flipped: Bool

    // MARK: - Board colours (lichess "brown" theme)
    private let lightSquare = Color(red: 0.941, green: 0.851, blue: 0.710)  // #F0D9B5
    private let darkSquare  = Color(red: 0.710, green: 0.533, blue: 0.388)  // #B58863
    private let highlight   = Color(red: 0.961, green: 0.957, blue: 0.286).opacity(0.6)  // #F5F449

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
                            let piece: Character? = ri < boardData.count && fi < boardData[ri].count
                                ? boardData[ri][fi] : nil

                            ZStack {
                                Rectangle().fill(isLight ? lightSquare : darkSquare)
                                if highlighted.contains(name) {
                                    Rectangle().fill(highlight)
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

/// Draws a single chess piece using a Unicode chess symbol.
///
/// All pieces use the "filled" (Black) Unicode variant so that colouring via
/// `.foregroundStyle` produces consistent results.  White pieces are drawn in
/// white with a dark shadow for contrast on light squares; Black pieces are
/// drawn in a near-black colour with a faint white shadow.
private struct ChessPieceView: View {
    let piece: Character
    let squareSize: CGFloat

    private var isWhite: Bool { piece.isUppercase }

    private var symbol: String {
        switch piece.lowercased().first {
        case "k": "♚"
        case "q": "♛"
        case "r": "♜"
        case "b": "♝"
        case "n": "♞"
        case "p": "♟"
        default: ""
        }
    }

    var body: some View {
        Text(symbol)
            .font(.system(size: squareSize * 0.82))
            .foregroundStyle(
                isWhite
                    ? Color.white
                    : Color(red: 0.10, green: 0.10, blue: 0.10)
            )
            .shadow(
                color: isWhite ? .black.opacity(0.75) : .white.opacity(0.55),
                radius: 0.6,
                x: 0.4,
                y: 0.4
            )
    }
}
