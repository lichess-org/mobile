import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:lichess_mobile/src/model/settings/play_preferences.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

part 'game_loader.g.dart';

@riverpod
Stream<({int nbPlayers, int nbGames})> lobbyNumbers(
  LobbyNumbersRef ref,
) async* {
  final socket = ref.watch(authSocketProvider);
  final stream = socket.connect();
  await for (final msg in stream) {
    if (msg.topic == 'n') {
      final data = msg.data as Map<String, int>;
      yield (
        nbPlayers: data['nbPlayers']!,
        nbGames: data['nbGames']!,
      );
    }
  }
}

class GameLoader extends ConsumerWidget {
  const GameLoader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeControlPref = ref
        .watch(playPreferencesProvider.select((prefs) => prefs.timeIncrement));

    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: BoardTable(
              boardData: const cg.BoardData(
                interactableSide: cg.InteractableSide.none,
                orientation: cg.Side.white,
                fen: kEmptyFen,
              ),
              topTable: const SizedBox.shrink(),
              bottomTable: const SizedBox.shrink(),
              showMoveListPlaceholder: true,
              boardOverlay: PlatformCard(
                elevation: 2.0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${context.l10n.waitingForOpponent}...'),
                      const SizedBox(height: 26.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            timeControlPref.speed.icon,
                            color: DefaultTextStyle.of(context).style.color,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            timeControlPref.display,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      _LobbyNumbers(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        _BottomBar(
          children: [
            BottomBarButton(
              onTap: () => Navigator.of(context).pop(),
              label: context.l10n.cancel,
              shortLabel: context.l10n.cancel,
              icon: CupertinoIcons.xmark,
              showAndroidShortLabel: true,
            ),
          ],
        ),
      ],
    );
  }
}

class CreateGameError extends StatelessWidget {
  const CreateGameError();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: SafeArea(
            bottom: false,
            child: BoardTable(
              boardData: cg.BoardData(
                interactableSide: cg.InteractableSide.none,
                orientation: cg.Side.white,
                fen: kEmptyFen,
              ),
              topTable: SizedBox.shrink(),
              bottomTable: SizedBox.shrink(),
              showMoveListPlaceholder: true,
              errorMessage:
                  'Sorry, we could not create the game. Please try again later.',
            ),
          ),
        ),
        _BottomBar(
          children: [
            BottomBarButton(
              onTap: () => Navigator.of(context).pop(),
              label: context.l10n.cancel,
              shortLabel: context.l10n.cancel,
              icon: CupertinoIcons.xmark,
              showAndroidShortLabel: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Styles.horizontalBodyPadding,
      color: defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: children,
        ),
      ),
    );
  }
}

class _LobbyNumbers extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lobbyNumbers = ref.watch(lobbyNumbersProvider);
    return lobbyNumbers.when(
      data: (numbers) => Column(
        children: [
          _AnimatedLobbyNumber(
            labelBuilder: (nb) => context.l10n.nbPlayers(nb),
            value: numbers.nbPlayers,
          ),
          const SizedBox(height: 8.0),
          _AnimatedLobbyNumber(
            labelBuilder: (nb) => context.l10n.nbGamesInPlay(nb),
            value: numbers.nbGames,
          ),
        ],
      ),
      loading: () => const Column(
        children: [
          Text(''),
          SizedBox(height: 8.0),
          Text(''),
        ],
      ),
      error: (err, __) {
        return const SizedBox.shrink();
      },
    );
  }
}

class _AnimatedLobbyNumber extends StatefulWidget {
  const _AnimatedLobbyNumber({
    required this.labelBuilder,
    required this.value,
  });

  final String Function(int) labelBuilder;
  final int value;

  @override
  State<_AnimatedLobbyNumber> createState() => _AnimatedLobbyNumberState();
}

class _AnimatedLobbyNumberState extends State<_AnimatedLobbyNumber> {
  int previousValue = 0;
  int value = 0;

  @override
  void didUpdateWidget(covariant _AnimatedLobbyNumber oldWidget) {
    previousValue = oldWidget.value;
    value = widget.value;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(
        begin: previousValue,
        end: value,
      ),
      duration: const Duration(seconds: 3),
      builder: (context, int value, _) {
        return Text(widget.labelBuilder(value));
      },
    );
  }
}
