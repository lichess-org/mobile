/// Validates whether a plain-text payload is structured as PGN chess data.
library;

/// Regular expression matching standard PGN header tags (e.g. `[Event "..."]`, `[Site "..."]`).
final _pgnHeaderRegex = RegExp(
  r'^\s*\[(Event|Site|Date|Round|White|Black|Result|FEN|SetUp|TimeControl|WhiteElo|BlackElo|Variant|ECO|Termination|Annotator|[A-Z][a-zA-Z0-9_]*)\s+"[^"]*"\]',
  multiLine: true,
  caseSensitive: false,
);

/// Regular expression matching the start of a standard chess game move list
/// (e.g. `1. e4`, `1. d4`, `1. Nf3`, or `1... e5`).
final _validFirstMoveRegex = RegExp(
  r'(?:^|\s)1\s*\.\s*(?:(?:\.\.\s*)?[a-hKQRBN][a-h1-8x+#=]?|(?:[a-h][34]|N[acfgh]3))\b',
  caseSensitive: false,
);

/// Returns true if [text] has the structural characteristics of a PGN game
/// (headers like `[Event "..."]` or move lists like `1. e4...`) rather than
/// arbitrary plain text (such as URLs, chat messages, or random notes).
bool isPgnText(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) {
    return false;
  }

  // Matches if the text contains standard PGN header tags.
  if (_pgnHeaderRegex.hasMatch(trimmed)) {
    return true;
  }

  // Matches if the text begins with or contains standard move list notation starting at move 1.
  if (_validFirstMoveRegex.hasMatch(trimmed)) {
    return true;
  }

  return false;
}
