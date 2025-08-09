import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/ongoing_game.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class OngoingGamesScreen extends ConsumerWidget {
  const OngoingGamesScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const OngoingGamesScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ongoingGames = ref.watch(ongoingGamesProvider);
    return Scaffold(
      appBar: AppBar(
        title: ongoingGames.maybeWhen(
          data: (data) => Text(context.l10n.nbGamesInPlay(data.length)),
          orElse: () => const SizedBox.shrink(),
        ),
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
      data: (data) => ListView(
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
  const OngoingGamePreview({required this.game, this.padding, super.key});

  final OngoingGame game;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SmallBoardPreview(
      padding: padding,
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
            color: game.isMyTurn
                ? context.lichessColors.brag
                : DefaultTextStyle.of(context).style.color?.withValues(alpha: 0.5),
          ),
          if (game.isMyTurn && game.secondsLeft != null)
            Text(
              relativeDate(context.l10n, DateTime.now().add(Duration(seconds: game.secondsLeft!))),
            )
          else
            Text(game.isMyTurn ? context.l10n.yourTurn : context.l10n.waitingForOpponent),
        ],
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          GameScreen.buildRoute(
            context,
            initialGameId: game.fullId,
            loadingFen: game.fen,
            loadingOrientation: game.orientation,
            loadingLastMove: game.lastMove,
          ),
        );
      },
    );
  }
}
