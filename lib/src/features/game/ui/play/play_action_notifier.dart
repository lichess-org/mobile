import 'dart:async';
import 'package:dartchess/dartchess.dart' hide Tuple2;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/features/user/domain/user.dart';
import '../../data/challenge_repository.dart';
import '../../data/game_repository.dart';
import '../../domain/game.dart';
import './form_providers.dart';

class PlayActionNotifier extends AutoDisposeNotifier<AsyncValue<Game?>> {
  @override
  AsyncValue<Game?> build() {
    return const AsyncData(null);
  }

  Future<void> createGame({
    required User account,
    required ComputerOpponent opponent,
    required TimeInc timeControl,
    required int level,
  }) async {
    final challengeRepo = ref.read(challengeRepositoryProvider);
    final task = opponent == ComputerOpponent.stockfish
        ? challengeRepo.challengeAI(AiChallengeRequest(
            time: Duration(minutes: timeControl.time),
            increment: Duration(seconds: timeControl.increment),
            level: level))
        : challengeRepo.createChallenge(
            opponent.name,
            ChallengeRequest(
                time: Duration(minutes: timeControl.time),
                increment: Duration(seconds: timeControl.increment)));

    state = const AsyncLoading();
    state = (await (task.run())).match(
        (error) => AsyncValue.error(error.message, error.stackTrace),
        (_) => const AsyncLoading());

    ref.onDispose(() {
      ref.read(gameRepositoryProvider).dispose();
    });

    await for (Map<String, dynamic> event
        in ref.read(gameRepositoryProvider).events()) {
      switch (event['type']) {
        case 'gameStart':
          if (state is AsyncLoading) {
            final game = event['game'];
            if (game['compat']['board']) {
              final perf = Perf.values.firstWhere((v) => v.name == game['perf'],
                  orElse: () => Perf.blitz);
              final player = Player(
                id: account.id,
                name: account.username,
                rating: account.perfs[perf]!.rating,
              );
              final opponent = Player(
                  id: game['opponent']['id'],
                  name: game['opponent']['username'],
                  rating: game['opponent']['rating']);
              state = AsyncValue.data(Game(
                id: GameId(value: game['gameId'] as String),
                initialFen: game['fen'],
                speed: Speed.values.firstWhere((v) => v.name == game['speed'],
                    orElse: () => Speed.blitz),
                orientation: Side.values.firstWhere(
                    (v) => v.name == game['color'],
                    orElse: () => Side.white),
                rated: game['rated'],
                white: game['color'] == 'white' ? player : opponent,
                black: game['color'] == 'white' ? opponent : player,
              ));
            }
          }
      }
    }
  }
}

final playActionProvider =
    AutoDisposeNotifierProvider<PlayActionNotifier, AsyncValue<Game?>>(
        PlayActionNotifier.new);
