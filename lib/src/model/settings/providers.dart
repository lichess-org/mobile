import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chessground/chessground.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/shared_preferences.dart';

part 'providers.g.dart';

const kSettingsStorePrefix = 'settings';

final themeModePrefProvider = createPrefProvider(
  prefKey: '$kSettingsStorePrefix.themeMode',
  defaultValue: ThemeMode.system,
  mapFrom: (string) {
    switch (string) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  },
  mapTo: (ThemeMode theme) => theme.name,
);

@Riverpod(keepAlive: true)
Brightness currentBrightness(CurrentBrightnessRef ref) {
  final themeMode = ref.watch(themeModePrefProvider);

  switch (themeMode) {
    case ThemeMode.dark:
      return Brightness.dark;
    case ThemeMode.light:
      return Brightness.light;
    case ThemeMode.system:
      return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }
}

final muteSoundPrefProvider = createBoolPrefProvider(
  prefKey: '$kSettingsStorePrefix.muteSound',
  defaultValue: false,
);

final IMap<String, PieceSet> _pieceSetNameMap =
    IMap(PieceSet.values.asNameMap());

final pieceSetPrefProvider = createPrefProvider<PieceSet>(
  prefKey: '$kSettingsStorePrefix.pieceSet',
  defaultValue: PieceSet.cburnett,
  mapFrom: (string) {
    if (string != null) {
      return _pieceSetNameMap.get(string) ?? PieceSet.cburnett;
    } else {
      return PieceSet.cburnett;
    }
  },
  mapTo: (PieceSet pieceSet) => pieceSet.name,
);

final IMap<String, BoardTheme> _boardThemeNameMap =
    IMap(BoardTheme.values.asNameMap());

final boardThemePrefProvider = createPrefProvider<BoardTheme>(
  prefKey: '$kSettingsStorePrefix.boardTheme',
  defaultValue: BoardTheme.brown,
  mapFrom: (string) {
    if (string != null) {
      return _boardThemeNameMap.get(string) ?? BoardTheme.brown;
    } else {
      return BoardTheme.brown;
    }
  },
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
