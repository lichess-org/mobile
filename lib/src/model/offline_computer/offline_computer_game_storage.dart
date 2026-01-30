import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/game/offline_computer_game.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

part 'offline_computer_game_storage.freezed.dart';
part 'offline_computer_game_storage.g.dart';

final _logger = Logger('OfflineComputerGameStorage');

@Freezed(fromJson: true, toJson: true)
sealed class SavedOfflineComputerGame with _$SavedOfflineComputerGame {
  const SavedOfflineComputerGame._();

  factory SavedOfflineComputerGame({required OfflineComputerGame game}) = _SavedOfflineComputerGame;

  factory SavedOfflineComputerGame.fromJson(Map<String, dynamic> json) =>
      _$SavedOfflineComputerGameFromJson(json);
}

/// A provider for [OfflineComputerGameStorage].
final offlineComputerGameStorageProvider = Provider<OfflineComputerGameStorage>((Ref ref) {
  return OfflineComputerGameStorage(ref);
}, name: 'OfflineComputerGameStorageProvider');

const kOfflineComputerGameFileName = 'offline_computer_game.json';

class OfflineComputerGameStorage {
  const OfflineComputerGameStorage(this.ref);
  final Ref ref;

  Future<File> _getFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$kOfflineComputerGameFileName');
  }

  /// Loads an ongoing offline computer game from storage. Returns null if there's no ongoing game or if an error occurs.
  Future<SavedOfflineComputerGame?> fetchOngoingGame() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        return null;
      }

      final contents = await file.readAsString();
      final json = jsonDecode(contents);

      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          '[OfflineComputerGameStorage] cannot fetch game: expected an object',
        );
      }

      return SavedOfflineComputerGame.fromJson(json);
    } catch (e) {
      _logger.warning('[OfflineComputerGameStorage] failed to fetch game: $e');
      return null;
    }
  }

  /// Persist the ongoing offline computer game to storage. Use [fetchOngoingGame] to retrieve it later.
  Future<void> save(OfflineComputerGame game) async {
    try {
      final file = await _getFile();
      await file.writeAsString(jsonEncode(SavedOfflineComputerGame(game: game).toJson()));
    } catch (e) {
      _logger.warning('[OfflineComputerGameStorage] failed to save game: $e');
    }
  }
}
