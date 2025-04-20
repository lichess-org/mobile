import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/over_the_board/over_the_board_screen.dart';
import 'package:lichess_mobile/src/view/play/create_custom_game_screen.dart';
import 'package:lichess_mobile/src/view/play/quick_game_button.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_list_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

/// A widget that displays the options for creating a game.
class CreateGameOptions extends ConsumerWidget {
  const CreateGameOptions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? false;
    final isPlayban = ref.watch(accountProvider).valueOrNull?.playban != null;

    return Column(
      children: [
        _Section(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: QuickGameButton(),
            ),
            _CreateGamePlatformButton(
              onTap:
                  isOnline && !isPlayban
                      ? () {
                        ref.invalidate(accountProvider);
                        Navigator.of(context).push(CreateCustomGameScreen.buildRoute(context));
                      }
                      : null,
              icon: Icons.tune,
              label: context.l10n.custom,
            ),
          ],
        ),
        _Section(
          children: [
            _CreateGamePlatformButton(
              onTap:
                  isOnline && !isPlayban
                      ? () {
                        Navigator.of(context).push(TournamentListScreen.buildRoute(context));
                      }
                      : null,
              icon: LichessIcons.tournament_cup,
              label: context.l10n.arenaArenaTournaments,
            ),
          ],
        ),
        _Section(
          children: [
            _CreateGamePlatformButton(
              onTap: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).push(OverTheBoardScreen.buildRoute(context));
              },
              icon: LichessIcons.chess_board,
              label: 'Over the board',
            ),
          ],
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListSection(hasLeading: true, children: children);
  }
}

class _CreateGamePlatformButton extends StatelessWidget {
  const _CreateGamePlatformButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;

  final String label;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1.0,
      child: ListTile(
        leading: Icon(icon, size: 28),
        trailing: const Icon(Icons.chevron_right),
        title: Text(label, style: Styles.mainListTileTitle),
        onTap: onTap,
      ),
    );
  }
}
