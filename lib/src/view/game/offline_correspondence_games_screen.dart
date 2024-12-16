import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/correspondence/offline_correspondence_game_screen.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:timeago/timeago.dart' as timeago;

class OfflineCorrespondenceGamesScreen extends ConsumerWidget {
  const OfflineCorrespondenceGamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineGames = ref.watch(offlineOngoingCorrespondenceGamesProvider);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: offlineGames.maybeWhen(
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
    final offlineGames = ref.watch(offlineOngoingCorrespondenceGamesProvider);
    return offlineGames.maybeWhen(
      data:
          (data) => ListView(
            children: [
              const SizedBox(height: 8.0),
              ...data.map(
                (game) => OfflineCorrespondenceGamePreview(game: game.$2, lastModified: game.$1),
              ),
            ],
          ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class OfflineCorrespondenceGamePreview extends ConsumerWidget {
  const OfflineCorrespondenceGamePreview({
    required this.game,
    required this.lastModified,
    super.key,
  });
  final DateTime lastModified;
  final OfflineCorrespondenceGame game;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SmallBoardPreview(
      orientation: game.orientation,
      lastMove: game.lastMove,
      fen: game.lastPosition.fen,
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          UserFullNameWidget(user: game.opponent.user, style: Styles.boardPreviewTitle),
          if (game.myTimeLeft(lastModified) != null)
            Text(
              timeago.format(
                DateTime.now().add(game.myTimeLeft(lastModified)!),
                allowFromNow: true,
              ),
            ),
          Icon(game.perf.icon, size: 40, color: DefaultTextStyle.of(context).style.color),
        ],
      ),
      onTap: () {
        pushPlatformRoute(
          context,
          rootNavigator: true,
          builder: (_) => OfflineCorrespondenceGameScreen(initialGame: (lastModified, game)),
        );
      },
    );
  }
}
