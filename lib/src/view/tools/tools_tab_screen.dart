import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/account/account_screen.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_screen.dart';
import 'package:lichess_mobile/src/view/clock/clock_tool_screen.dart';
import 'package:lichess_mobile/src/view/coordinate_training/coordinate_training_screen.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_screen.dart';
import 'package:lichess_mobile/src/view/study/study_list_screen.dart';
import 'package:lichess_mobile/src/view/tools/load_position_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class ToolsTabScreen extends ConsumerWidget {
  const ToolsTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (!didPop) {
          ref.read(currentBottomTabProvider.notifier).state = BottomTab.home;
        }
      },
      child: PlatformScaffold(
        appBar: PlatformAppBar(leading: const AccountIconButton(), title: Text(context.l10n.tools)),
        body: const _Body(),
      ),
    );
  }
}

class _ToolsButton extends StatelessWidget {
  const _ToolsButton({required this.icon, required this.title, required this.onTap});

  final IconData icon;

  final String title;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1.0,
      child: ListTile(
        leading: Icon(icon, color: ColorScheme.of(context).primary),
        title: Text(title, style: Styles.callout),
        trailing: Theme.of(context).platform == TargetPlatform.iOS
            ? const Icon(Icons.chevron_right)
            : null,
        onTap: onTap,
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? false;

    final content = [
      ListSection(
        hasLeading: true,
        children: [
          _ToolsButton(
            icon: Icons.upload_file,
            title: context.l10n.loadPosition,
            onTap: () => Navigator.of(context).push(LoadPositionScreen.buildRoute(context)),
          ),
          _ToolsButton(
            icon: Icons.biotech,
            title: context.l10n.analysis,
            onTap: () => Navigator.of(context, rootNavigator: true).push(
              AnalysisScreen.buildRoute(
                context,
                const AnalysisOptions(
                  orientation: Side.white,
                  standalone: (pgn: '', isComputerAnalysisAllowed: true, variant: Variant.standard),
                ),
              ),
            ),
          ),
          _ToolsButton(
            icon: Icons.explore_outlined,
            title: context.l10n.openingExplorer,
            onTap: isOnline
                ? () => Navigator.of(context, rootNavigator: true).push(
                    OpeningExplorerScreen.buildRoute(
                      context,
                      const AnalysisOptions(
                        orientation: Side.white,
                        standalone: (
                          pgn: '',
                          isComputerAnalysisAllowed: false,
                          variant: Variant.standard,
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          _ToolsButton(
            icon: LichessIcons.study,
            title: context.l10n.studyMenu,
            onTap: isOnline
                ? () => Navigator.of(context).push(StudyListScreen.buildRoute(context))
                : null,
          ),
          _ToolsButton(
            icon: Icons.edit_outlined,
            title: context.l10n.boardEditor,
            onTap: () => Navigator.of(
              context,
              rootNavigator: true,
            ).push(BoardEditorScreen.buildRoute(context)),
          ),
          _ToolsButton(
            icon: Icons.where_to_vote_outlined,
            title: 'Coordinate Training', // TODO l10n
            onTap: () => Navigator.of(
              context,
              rootNavigator: true,
            ).push(CoordinateTrainingScreen.buildRoute(context)),
          ),
          _ToolsButton(
            icon: Icons.alarm,
            title: context.l10n.clock,
            onTap: () => Navigator.of(
              context,
              rootNavigator: true,
            ).push(ClockToolScreen.buildRoute(context)),
          ),
        ],
      ),
    ];

    return ListView(controller: toolsScrollController, children: content);
  }
}
