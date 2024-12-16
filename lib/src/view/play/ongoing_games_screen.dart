import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/account/ongoing_game.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:timeago/timeago.dart' as timeago;

class OngoingGamesScreen extends ConsumerWidget {
  const OngoingGamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(ref: ref, androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(navigationBar: const CupertinoNavigationBar(), child: _Body());
  }

  Widget _buildAndroid(BuildContext context, WidgetRef ref) {
    final ongoingGames = ref.watch(ongoingGamesProvider);
    return Scaffold(
      appBar: ongoingGames.maybeWhen(
        data: (data) => AppBar(title: Text(context.l10n.nbGamesInPlay(data.length))),
        orElse: () => AppBar(title: const SizedBox.shrink()),
      ),
      body: _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ongoingGames = ref.watch(ongoingGamesProvider);
    return ongoingGames.maybeWhen(
      data:
          (data) => ListView(
            children: [
              const SizedBox(height: 8.0),
              ...data.map((game) => OngoingGamePreview(game: game)),
            ],
          ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class OngoingGamePreview extends ConsumerWidget {
  const OngoingGamePreview({required this.game, super.key});

  final OngoingGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SmallBoardPreview(
      orientation: game.orientation,
      lastMove: game.lastMove,
      fen: game.fen,
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UserFullNameWidget.player(
            user: game.opponent,
            rating: game.opponentRating,
            aiLevel: game.opponentAiLevel,
            style: Styles.boardPreviewTitle,
          ),
          Icon(
            game.perf.icon,
            size: 34,
            color: DefaultTextStyle.of(context).style.color?.withValues(alpha: 0.6),
          ),
          if (game.secondsLeft != null && game.secondsLeft! > 0)
            Text(game.isMyTurn ? context.l10n.yourTurn : context.l10n.waitingForOpponent),
          if (game.isMyTurn && game.secondsLeft != null)
            Text(
              timeago.format(
                DateTime.now().add(Duration(seconds: game.secondsLeft!)),
                allowFromNow: true,
              ),
            ),
        ],
      ),
      onTap: () {
        pushPlatformRoute(
          context,
          rootNavigator: true,
          builder:
              (context) => GameScreen(
                initialGameId: game.fullId,
                loadingFen: game.fen,
                loadingOrientation: game.orientation,
                loadingLastMove: game.lastMove,
              ),
        ).then((_) {
          if (context.mounted) {
            ref.invalidate(ongoingGamesProvider);
          }
        });
      },
    );
  }
}
