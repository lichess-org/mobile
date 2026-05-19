import ChessgroundAssets
import SwiftUI
import WidgetKit

/// Renders a chess position from a FEN string as an 8×8 grid.
///
/// The board background exactly matches the main Lichess app:
/// - Image-backed themes (wood, marble, …) draw the full board texture image and
///   lay highlights and pieces on top.
/// - Solid-colour themes (brown, blue, green, ic) draw individual light/dark squares.
///
/// In `.accented` (Tinted) and `.vibrant` (Clear) widget rendering modes the themed
/// board is replaced by a transparent checkerboard: dark squares use a subtle neutral
/// fill marked `.widgetAccentable(false)` so the system puts them in the background
/// layer, while pieces remain in the default (accented) layer and are tinted with the
/// system accent colour — keeping them clearly visible.
///
/// Piece images are driven by `boardStyle.pieceSet`; all piece sets supported by
/// the app are bundled in the widget extension's `Assets.xcassets`.
struct ChessBoardView: View {
    let fen: String
    let lastMove: String?
    let flipped: Bool
    let boardStyle: ChessboardTheme

    @Environment(\.widgetRenderingMode) private var renderingMode

    private var isTransparentMode: Bool {
        renderingMode == .accented || renderingMode == .vibrant
    }

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
        let isSolidTheme = boardStyle.boardImageName == nil

        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let squareSize = side / 8

            ZStack {
                // Board background
                // Image-backed themes: one full-board texture scaled to fill.
                // Solid-colour themes: drawn square-by-square in the grid below.
                // In accented/vibrant rendering modes the image is skipped so the
                // widget container background shows through.
                if !isTransparentMode, let imageName = boardStyle.boardImageName {
                    Image(imageName, bundle: ChessgroundAssets.bundle)
                        .resizable()
                        .frame(width: side, height: side)
                }

                // Square grid: solid fill, highlights, pieces
                VStack(spacing: 0) {
                    ForEach(0 ..< 8, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0 ..< 8, id: \.self) { col in
                                let rankIndex = flipped ? 7 - row : row
                                let fileIndex = flipped ? 7 - col : col
                                // Light squares are where (rankIndex + fileIndex) is even:
                                // a8=(0,0) is light, b8=(0,1) is dark, a7=(1,0) is dark, etc.
                                let isLight = (rankIndex + fileIndex) % 2 == 0
                                let name = squareName(rankIndex: rankIndex, fileIndex: fileIndex)
                                let piece: Character? =
                                    rankIndex < boardData.count && fileIndex < boardData[rankIndex].count
                                    ? boardData[rankIndex][fileIndex] : nil

                                ZStack {
                                    if isTransparentMode {
                                        // Transparent board: dark squares get a subtle neutral
                                        // fill in the background (non-accented) layer so pieces
                                        // in the accented layer remain clearly visible.
                                        if !isLight {
                                            Rectangle()
                                                .fill(Color(white: 0, opacity: 0.18))
                                                .widgetAccentable(false)
                                        }
                                    } else if isSolidTheme {
                                        Rectangle()
                                            .fill(
                                                isLight
                                                    ? boardStyle.lightSquare
                                                    : boardStyle.darkSquare
                                            )
                                    }
                                    if highlighted.contains(name) {
                                        Rectangle()
                                            .fill(
                                                isTransparentMode
                                                    ? Color(white: 1, opacity: 0.35)
                                                    : boardStyle.lastMoveHighlight
                                            )
                                            .widgetAccentable(false)
                                    }
                                    if let piece {
                                        ChessPieceView(
                                            piece: piece,
                                            squareSize: squareSize,
                                            pieceSet: boardStyle.pieceSet
                                        )
                                    }
                                }
                                .frame(width: squareSize, height: squareSize)
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
