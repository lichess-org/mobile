import 'dart:async';
import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class CorrespondenceChallengeNotifier
    extends AutoDisposeFamilyAsyncNotifier<Challenge, ChallengeRequest> {
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
      final challenge = state.requireValue;
      final updatedChallenge = await challengeRepository.show(challenge.id);
      state = AsyncData(updatedChallenge);
    }
  }
}

final correspondenceChallengeProvider = AsyncNotifierProvider.autoDispose
    .family<CorrespondenceChallengeNotifier, Challenge, ChallengeRequest>(
      CorrespondenceChallengeNotifier.new,
      name: 'CorrespondenceChallengeProvider',
    );

class PendingCorresChallengeDialog extends ConsumerWidget {
  const PendingCorresChallengeDialog({required this.request, super.key});

  final ChallengeRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncChallenge = ref.watch(correspondenceChallengeProvider(request));

    switch (asyncChallenge) {
      case AsyncData<Challenge>(value: final challenge):
        return _Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(challenge.perf.icon),
                  const SizedBox(width: 8.0),
                  Text(
                    challenge.timeIncrement?.display ??
                        '${context.l10n.daysPerTurn}: ${challenge.days}',
                    style: TextTheme.of(context).titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ...switch (challenge.status) {
                ChallengeStatus.declined => [
                  const Divider(height: 26.0, thickness: 0.0),
                  Text(
                    (challenge.declineReason ?? ChallengeDeclineReason.generic).label(context.l10n),
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const Divider(height: 26.0, thickness: 0.0),
                ],
                _ => [Text(context.l10n.waitingForOpponent)],
              },
              const SizedBox(height: 16.0),
              UserFullNameWidget(
                user: challenge.destUser?.user,
                style: TextTheme.of(context).titleLarge,
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  ref.read(challengeRepositoryProvider).cancel(challenge.id);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text(context.l10n.cancel),
              ),
            ],
          ),
        );
      case AsyncError<Challenge>(:final error):
        return Dialog(child: Text('Failed to create challenge: $error'));
      case _:
        return const Center(child: CircularProgressIndicator.adaptive());
    }
  }
}

class _Dialog extends StatelessWidget {
  const _Dialog({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddedContent = Padding(padding: const EdgeInsets.all(16.0), child: child);
    final sizedContent = SizedBox(
      width: min(screenWidth, kMaterialPopupMenuMaxWidth),
      child: paddedContent,
    );
    return Dialog(child: sizedContent);
  }
}
