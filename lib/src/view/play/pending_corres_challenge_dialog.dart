import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/network/socket.dart';

class CorrespondenceChallengeNotifier extends FamilyAsyncNotifier<Challenge, ChallengeRequest> {
  StreamSubscription<void>? _socketConnectSubscription;
  StreamSubscription<SocketEvent>? _socketEventsSubscription;
  Timer? _challengePingTimer;

  late final SocketClient _socketClient;

  ChallengeRepository get challengeRepository => ref.read(challengeRepositoryProvider);

  @override
  Future<Challenge> build(ChallengeRequest request) async {
    ref.onDispose(() {
      _socketConnectSubscription?.cancel();
      _socketEventsSubscription?.cancel();
      _challengePingTimer?.cancel();
    });

    final socketPool = ref.read(socketPoolProvider);
    final challenge = await ref.read(createGameServiceProvider).newCorrespondenceChallenge(request);

    _socketClient = socketPool.open(
      Uri(
        path: '/challenge/${challenge.id}/socket/v5',
        queryParameters: {'v': challenge.socketVersion.toString()},
      ),
    );

    _socketConnectSubscription = _socketClient.connectedStream.listen(_onSocketConnect);
    _socketEventsSubscription = _socketClient.stream.listen(_onSocketEvent);

    return challenge;
  }

  void _onSocketConnect(_) {
    _socketClient.send('ping', null);
    _challengePingTimer?.cancel();
    _challengePingTimer = Timer.periodic(
      const Duration(seconds: 9),
      (_) => _socketClient.send('ping', null),
    );
  }

  Future<void> _onSocketEvent(SocketEvent event) async {
    if (!state.hasValue) return;
    if (event.topic == 'reload') {
      try {
        final challenge = state.requireValue;
        final updatedChallenge = await challengeRepository.show(challenge.id);
        state = AsyncData(updatedChallenge);
      } catch (e) {
        debugPrint('Failed to reload challenge $e');
      }
    }
  }
}

// class PendingCorresChallengeDialog extends ConsumerWidget {
//   const PendingCorresChallengeDialog({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {}
// }
