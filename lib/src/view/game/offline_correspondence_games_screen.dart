import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/correspondence/offline_correspondence_game_screen.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/user.dart';

class OfflineCorrespondenceGamesScreen extends ConsumerWidget {
  const OfflineCorrespondenceGamesScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const OfflineCorrespondenceGamesScreen(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineGames = ref.watch(offlineOngoingCorrespondenceGamesProvider);
    return Scaffold(
      appBar: AppBar(
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
      data: (data) => ListView(
        children: [
          const SizedBox(height: 8.0),
          ...data.map(
            (game) => OfflineCorrespondenceGamePreview(
              game: game.$2,
              lastModified: game.$1,
            ),
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
          UserFullNameWidget(
            user: game.opponent!.user,
            style: Styles.boardPreviewTitle,
          ),
          if (game.myTimeLeft(lastModified) != null)
            Text(
              relativeDate(
                context.l10n,
                DateTime.now().add(game.myTimeLeft(lastModified)!),
              ),
            ),
          Icon(
            game.perf.icon,
            size: 32,
            color: DefaultTextStyle.of(context).style.color,
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          OfflineCorrespondenceGameScreen.buildRoute(
            context,
            initialGame: (lastModified, game),
          ),
        );
      },
    );
  }
}
