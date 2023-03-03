import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/common/sound_theme.dart';
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

final IMap<String, SoundTheme> _soundThemeNameMap =
    IMap(SoundTheme.values.asNameMap());

final soundThemePrefProvider = createPrefProvider<SoundTheme>(
  prefKey: '$kSettingsStorePrefix.soundTheme',
  defaultValue: SoundTheme.piano,
  mapFrom: (string) {
    if (string != null) {
      return _soundThemeNameMap.get(string) ?? SoundTheme.standard;
    } else {
      return SoundTheme.standard;
    }
  },
  mapTo: (SoundTheme soundTheme) => soundTheme.name,
);

@Riverpod(keepAlive: true)
SoundTheme currentSelectedSoundTheme(CurrentSelectedSoundThemeRef ref) {
  final soundTheme = ref.watch(soundThemePrefProvider);

  //switch required because ref returns dynamic
  switch (soundTheme) {
    case SoundTheme.futuristic:
      return SoundTheme.futuristic;
    case SoundTheme.lisp:
      return SoundTheme.lisp;
    case SoundTheme.standard:
      return SoundTheme.standard;
    case SoundTheme.nes:
      return SoundTheme.nes;
    case SoundTheme.piano:
      return SoundTheme.piano;
    case SoundTheme.robot:
      return SoundTheme.robot;
    case SoundTheme.sfx:
      return SoundTheme.sfx;
    default:
      return SoundTheme.standard;
  }
}
