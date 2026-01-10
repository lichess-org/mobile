import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/game/over_the_board_game.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

part 'over_the_board_game_storage.freezed.dart';
part 'over_the_board_game_storage.g.dart';

final _logger = Logger('OverTheBoardGameStorage');

@Freezed(fromJson: true, toJson: true)
sealed class SavedOtbGame with _$SavedOtbGame {
  const SavedOtbGame._();

  factory SavedOtbGame({
    required OverTheBoardGame game,
    required TimeIncrement timeIncrement,
    Duration? whiteTimeLeft,
    Duration? blackTimeLeft,
  }) = _SavedOtbGame;

  factory SavedOtbGame.fromJson(Map<String, dynamic> json) => _$SavedOtbGameFromJson(json);
}

/// A provider for [OverTheBoardGameStorage].
final overTheBoardGameStorageProvider = Provider<OverTheBoardGameStorage>((Ref ref) {
  return OverTheBoardGameStorage(ref);
}, name: 'OverTheBoardGameStorageProvider');

const kOtbGameFileName = 'otb_game.json';

class OverTheBoardGameStorage {
  const OverTheBoardGameStorage(this.ref);
  final Ref ref;

  Future<File> _getFile() async {
    final dir = await getApplicationCacheDirectory();
    return File('${dir.path}/$kOtbGameFileName');
  }

  /// Loads an ongoing OTB game from storage. Returns null if there's no ongoing game or if an error occurs.
  Future<SavedOtbGame?> fetchOngoingGame() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        return null;
      }

      final contents = await file.readAsString();
      final json = jsonDecode(contents);

      if (json is! Map<String, dynamic>) {
        throw const FormatException('[OtbGameStorage] cannot fetch game: expected an object');
      }

      return SavedOtbGame.fromJson(json);
    } catch (e) {
      _logger.warning('[OtbGameStorage] failed to fetch game: $e');
      return null;
    }
  }

  /// Persist the ongoing OTB game to storage. Use [fetchOngoingGame] to retrieve it later.
  Future<void> save(
    OverTheBoardGame game, {
    required TimeIncrement timeIncrement,
    required Duration? whiteTimeLeft,
    required Duration? blackTimeLeft,
  }) async {
    try {
      final file = await _getFile();
      await file.writeAsString(
        jsonEncode(
          SavedOtbGame(
            game: game,
            timeIncrement: timeIncrement,
            whiteTimeLeft: whiteTimeLeft,
            blackTimeLeft: blackTimeLeft,
          ).toJson(),
        ),
      );
    } catch (e) {
      _logger.warning('[OtbGameStorage] failed to save game: $e');
    }
  }
}
