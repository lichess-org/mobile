import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/game/offline_computer_game.dart';

/// A saved game as it was serialised before there was more than one engine to play against.
final legacyGameJson = {
  'id': 'ocg_deadbeef',
  'meta': {
    'createdAt': '2026-08-01T12:00:00.000',
    'rated': false,
    'variant': 'standard',
    'speed': 'classical',
    'perf': 'classical',
  },
  'initialFen': null,
  'status': 'started',
  'steps': '[{"fen":"$kInitialFEN","rule":"chess","uci":null,"san":null}]',
  'playerSide': 'white',
  'stockfishLevel': 'level7',
  'casual': true,
  'practiceMode': false,
};

void main() {
  group('OfflineComputerGame', () {
    test('reads the opponent of a game saved before Maia existed', () {
      final game = OfflineComputerGame.fromJson({...legacyGameJson});

      // The level the game was being played at is worth more than a clean schema.
      expect(game.opponentSpec, const StockfishOpponentSpec(StockfishLevel.level7));
    });

    test('round-trips a Maia opponent', () {
      final game = OfflineComputerGame.fromJson({
        ...legacyGameJson,
        'opponentSpec': const {'type': 'maia', 'rating': 'maia1900'},
      });

      expect(game.opponentSpec, const MaiaOpponentSpec(MaiaRating.maia1900));
      final saved = jsonDecode(jsonEncode(game.toJson())) as Map<String, dynamic>;
      expect(
        OfflineComputerGame.fromJson(saved).opponentSpec,
        const MaiaOpponentSpec(MaiaRating.maia1900),
      );
    });

    test('names the engine player after the engine it is', () {
      expect(
        enginePlayerFor(const StockfishOpponentSpec(StockfishLevel.level1)).user?.name,
        'Stockfish',
      );
      expect(enginePlayerFor(const MaiaOpponentSpec(MaiaRating.maia1100)).user?.name, 'Maia');
    });
  });
}
