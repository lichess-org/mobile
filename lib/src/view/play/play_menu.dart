import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/over_the_board/over_the_board_screen.dart';
import 'package:lichess_mobile/src/view/play/correspondence_challenges_screen.dart';
import 'package:lichess_mobile/src/view/play/create_game_widget.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_list_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

class PlayMenu extends ConsumerWidget {
  const PlayMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? false;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: CreateGameWidget(),
        ),
        _Section(
          children: [
            _CreateGamePlatformButton(
              onTap: isOnline
                  ? () {
                      // Pops the play bottom sheet
                      Navigator.of(context).popUntil((route) => route is! ModalBottomSheetRoute);
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).push(CorrespondenceChallengesScreen.buildRoute(context));
                    }
                  : null,
              icon: Perf.correspondence.icon,
              label: context.l10n.correspondence,
            ),
            _CreateGamePlatformButton(
              onTap: isOnline
                  ? () {
                      // Pops the play bottom sheet
                      Navigator.of(context).popUntil((route) => route is! ModalBottomSheetRoute);

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
                // Pops the play bottom sheet
                Navigator.of(context).popUntil((route) => route is! ModalBottomSheetRoute);
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).push(OverTheBoardScreen.buildRoute(context));
              },
              icon: Icons.table_restaurant_outlined,
              label: context.l10n.mobileOverTheBoard,
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
    return ListSection(hasLeading: true, materialFilledCard: true, children: children);
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
      child: ListTile(leading: Icon(icon), title: Text(label), onTap: onTap),
    );
  }
}
