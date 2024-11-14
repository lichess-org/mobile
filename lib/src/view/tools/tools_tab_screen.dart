import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_screen.dart';
import 'package:lichess_mobile/src/view/clock/clock_screen.dart';
import 'package:lichess_mobile/src/view/coordinate_training/coordinate_training_screen.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_screen.dart';
import 'package:lichess_mobile/src/view/study/study_list_screen.dart';
import 'package:lichess_mobile/src/view/tools/load_position_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class ToolsTabScreen extends ConsumerWidget {
  const ToolsTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (!didPop) {
          ref.read(currentBottomTabProvider.notifier).state = BottomTab.home;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.tools),
        ),
        body: const Column(
          children: [
            ConnectivityBanner(),
            Expanded(child: _Body()),
          ],
        ),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        controller: puzzlesScrollController,
        slivers: [
          CupertinoSliverNavigationBar(largeTitle: Text(context.l10n.tools)),
          const SliverToBoxAdapter(child: ConnectivityBanner()),
          const SliverSafeArea(
            top: false,
            sliver: _Body(),
          ),
        ],
      ),
    );
  }
}

class _ToolsButton extends StatelessWidget {
  const _ToolsButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;

  final String title;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tilePadding = Theme.of(context).platform == TargetPlatform.iOS
        ? const EdgeInsets.symmetric(vertical: 8.0)
        : EdgeInsets.zero;

    return Padding(
      padding: Theme.of(context).platform == TargetPlatform.android
          ? const EdgeInsets.only(bottom: 16.0)
          : EdgeInsets.zero,
      child: Opacity(
        opacity: onTap == null ? 0.5 : 1.0,
        child: PlatformListTile(
          leading: Icon(
            icon,
            size: Styles.mainListTileIconSize,
            color: Theme.of(context).platform == TargetPlatform.iOS
                ? CupertinoTheme.of(context).primaryColor
                : Theme.of(context).colorScheme.primary,
          ),
          title: Padding(
            padding: tilePadding,
            child: Text(title, style: Styles.callout),
          ),
          trailing: Theme.of(context).platform == TargetPlatform.iOS
              ? const CupertinoListTileChevron()
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline =
        ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? false;

    final content = [
      if (Theme.of(context).platform == TargetPlatform.android)
        const SizedBox(height: 16.0),
      ListSection(
        hasLeading: true,
        children: [
          _ToolsButton(
            icon: Icons.upload_file,
            title: context.l10n.loadPosition,
            onTap: () => pushPlatformRoute(
              context,
              builder: (context) => const LoadPositionScreen(),
            ),
          ),
          _ToolsButton(
            icon: Icons.biotech,
            title: context.l10n.analysis,
            onTap: () => pushPlatformRoute(
              context,
              rootNavigator: true,
              builder: (context) => const AnalysisScreen(
                pgnOrId: '',
                options: AnalysisOptions(
                  isLocalEvaluationAllowed: true,
                  variant: Variant.standard,
                  orientation: Side.white,
                  id: standaloneAnalysisId,
                ),
              ),
            ),
          ),
          _ToolsButton(
            icon: Icons.explore_outlined,
            title: context.l10n.openingExplorer,
            onTap: isOnline
                ? () => pushPlatformRoute(
                      context,
                      rootNavigator: true,
                      builder: (context) => const OpeningExplorerScreen(
                        pgn: '',
                        options: AnalysisOptions(
                          isLocalEvaluationAllowed: false,
                          variant: Variant.standard,
                          orientation: Side.white,
                          id: standaloneOpeningExplorerId,
                        ),
                      ),
                    )
                : null,
          ),
          if (isOnline)
            _ToolsButton(
              icon: LichessIcons.study,
              title: context.l10n.studyMenu,
              onTap: () => pushPlatformRoute(
                context,
                builder: (context) => const StudyListScreen(),
              ),
            ),
          _ToolsButton(
            icon: Icons.edit_outlined,
            title: context.l10n.boardEditor,
            onTap: () => pushPlatformRoute(
              context,
              builder: (context) => const BoardEditorScreen(),
              rootNavigator: true,
            ),
          ),
          _ToolsButton(
            icon: Icons.where_to_vote_outlined,
            title: 'Coordinate Training', // TODO l10n
            onTap: () => pushPlatformRoute(
              context,
              rootNavigator: true,
              builder: (context) => const CoordinateTrainingScreen(),
            ),
          ),
          _ToolsButton(
            icon: Icons.alarm,
            title: context.l10n.clock,
            onTap: () => pushPlatformRoute(
              context,
              builder: (context) => const ClockScreen(),
              rootNavigator: true,
            ),
          ),
        ],
      ),
    ];

    return Theme.of(context).platform == TargetPlatform.iOS
        ? SliverList(delegate: SliverChildListDelegate(content))
        : ListView(
            controller: puzzlesScrollController,
            children: content,
          );
  }
}
