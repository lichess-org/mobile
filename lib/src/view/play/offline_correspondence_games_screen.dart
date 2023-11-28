import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart' as cg;
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/correspondence/offline_correspondence_game_screen.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:timeago/timeago.dart' as timeago;

class OfflineCorrespondenceGamesScreen extends ConsumerWidget {
  const OfflineCorrespondenceGamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildIos(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _Body(),
    );
  }

  Widget _buildAndroid(BuildContext context, WidgetRef ref) {
    final offlineGames = ref.watch(offlineOngoingCorrespondenceGamesProvider);
    return Scaffold(
      appBar: offlineGames.maybeWhen(
        data: (data) =>
            AppBar(title: Text(context.l10n.nbGamesInPlay(data.length))),
        orElse: () => AppBar(title: const SizedBox.shrink()),
      ),
      body: _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineGames = ref.watch(offlineOngoingCorrespondenceGamesProvider);
    return offlineGames.maybeWhen(
      data: (data) => ListView(
        children: [
          const SizedBox(height: 8.0),
          ...data.map((game) => OfflineCorrespondenceGamePreview(game: game)),
        ],
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class OfflineCorrespondenceGamePreview extends ConsumerWidget {
  const OfflineCorrespondenceGamePreview({required this.game, super.key});
  final OfflineCorrespondenceGame game;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SmallBoardPreview(
      orientation: game.orientation.cg,
      lastMove: game.lastMove?.cg,
      fen: game.lastPosition.fen,
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PlayerTitle(
            userName: game.opponent.name ?? context.l10n.anonymous,
            title: game.opponent.title,
            isPatron: game.opponent.patron,
            style: Styles.boardPreviewTitle,
          ),
          if (game.estimatedTimeLeft != null)
            Text(
              timeago.format(
                DateTime.now().add(game.estimatedTimeLeft!),
                allowFromNow: true,
              ),
            ),
          Icon(
            game.perf.icon,
            size: 40,
            color: DefaultTextStyle.of(context).style.color,
          ),
        ],
      ),
      onTap: () {
        pushPlatformRoute(
          context,
          rootNavigator: true,
          builder: (_) => OfflineCorrespondenceGameScreen(game: game),
        );
      },
    );
  }
}
