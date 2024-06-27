import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_position_choice_screen.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/clock/clock_screen.dart';
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
        body: const Center(child: _Body()),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        controller: puzzlesScrollController,
        slivers: [
          CupertinoSliverNavigationBar(largeTitle: Text(context.l10n.tools)),
          const SliverSafeArea(
            top: false,
            sliver: _Body(),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final tilePadding = Theme.of(context).platform == TargetPlatform.iOS
        ? const EdgeInsets.symmetric(vertical: 8.0)
        : EdgeInsets.zero;

    final content = [
      const SizedBox(height: 16.0),
      ListSection(
        hasLeading: true,
        children: [
          Padding(
            padding: Theme.of(context).platform == TargetPlatform.android
                ? const EdgeInsets.only(bottom: 16.0)
                : EdgeInsets.zero,
            child: PlatformListTile(
              leading: Icon(
                Icons.biotech,
                size: Styles.mainListTileIconSize,
                color: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoTheme.of(context).primaryColor
                    : Theme.of(context).colorScheme.primary,
              ),
              title: Padding(
                padding: tilePadding,
                child: Text(context.l10n.analysis, style: Styles.callout),
              ),
              trailing: Theme.of(context).platform == TargetPlatform.iOS
                  ? const CupertinoListTileChevron()
                  : null,
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
          ),
          Padding(
            padding: Theme.of(context).platform == TargetPlatform.android
                ? const EdgeInsets.only(bottom: 16.0)
                : EdgeInsets.zero,
            child: PlatformListTile(
              leading: Icon(
                Icons.upload_file,
                size: Styles.mainListTileIconSize,
                color: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoTheme.of(context).primaryColor
                    : Theme.of(context).colorScheme.primary,
              ),
              title: Padding(
                padding: tilePadding,
                child: Text(context.l10n.loadPosition, style: Styles.callout),
              ),
              trailing: Theme.of(context).platform == TargetPlatform.iOS
                  ? const CupertinoListTileChevron()
                  : null,
              onTap: () => pushPlatformRoute(
                context,
                builder: (context) => const AnalysisPositionChoiceScreen(),
              ),
            ),
          ),
          PlatformListTile(
            leading: Icon(
              Icons.alarm,
              size: Styles.mainListTileIconSize,
              color: Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoTheme.of(context).primaryColor
                  : Theme.of(context).colorScheme.primary,
            ),
            title: Padding(
              padding: tilePadding,
              child: Text(context.l10n.clock, style: Styles.callout),
            ),
            trailing: Theme.of(context).platform == TargetPlatform.iOS
                ? const CupertinoListTileChevron()
                : null,
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
