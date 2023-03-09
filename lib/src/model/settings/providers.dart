import 'package:chessground/chessground.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/shared_preferences.dart';

const kSettingsStorePrefix = 'settings';

final IMap<String, PieceSet> _pieceSetNameMap =
    IMap(PieceSet.values.asNameMap());

final pieceSetPrefProvider = createPrefProvider<PieceSet>(
  prefKey: '$kSettingsStorePrefix.pieceSet',
  defaultValue: PieceSet.cburnett,
  mapFrom: (string) => _pieceSetNameMap.get(string) ?? PieceSet.cburnett,
  mapTo: (PieceSet pieceSet) => pieceSet.name,
);

final IMap<String, BoardTheme> _boardThemeNameMap =
    IMap(BoardTheme.values.asNameMap());

final boardThemePrefProvider = createPrefProvider<BoardTheme>(
  prefKey: '$kSettingsStorePrefix.boardTheme',
  defaultValue: BoardTheme.brown,
  mapFrom: (string) => _boardThemeNameMap.get(string) ?? BoardTheme.brown,
  mapTo: (BoardTheme boardTheme) => boardTheme.name,
);

final boardHapticFeedbackPrefProvider = createBoolPrefProvider(
  prefKey: '$kSettingsStorePrefix.board.hapticFeedback',
  defaultValue: true,
);

final boardShowLegalMovesPrefProvider = createBoolPrefProvider(
  prefKey: '$kSettingsStorePrefix.board.showLegalMoves',
  defaultValue: true,
);
