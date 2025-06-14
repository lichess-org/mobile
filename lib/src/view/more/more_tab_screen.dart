import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/account/account_screen.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_screen.dart';
import 'package:lichess_mobile/src/view/clock/clock_tool_screen.dart';
import 'package:lichess_mobile/src/view/more/load_position_screen.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreTabScreen extends ConsumerWidget {
  const MoreTabScreen({super.key});

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
        appBar: PlatformAppBar(
          title: const Text('lichess.org'),
          leading: const AccountIconButton(),
        ),
        drawer: const AccountDrawer(),
        body: const _Body(),
      ),
    );
  }
}

class _ToolsButton extends StatelessWidget {
  const _ToolsButton({required this.leading, required this.title, required this.onTap});

  final Widget leading;

  final String title;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1.0,
      child: ListTile(
        leading: leading,
        title: Text(title),
        trailing: Theme.of(context).platform == TargetPlatform.iOS
            ? const CupertinoListTileChevron()
            : null,
        onTap: onTap,
      ),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body();

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  bool errorLoadingFlair = false;

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? false;

    final packageInfo = ref.read(preloadedDataProvider).requireValue.packageInfo;

    return ListView(
      controller: moreScrollController,
      children: [
        ListSection(
          header: SettingsSectionTitle(context.l10n.tools),
          hasLeading: true,
          children: [
            _ToolsButton(
              leading: const Icon(Icons.upload_file_outlined),
              title: context.l10n.loadPosition,
              onTap: () => Navigator.of(context).push(LoadPositionScreen.buildRoute(context)),
            ),
            _ToolsButton(
              leading: const Icon(Icons.biotech_outlined),
              title: context.l10n.analysis,
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                AnalysisScreen.buildRoute(
                  context,
                  const AnalysisOptions(
                    orientation: Side.white,
                    standalone: (
                      pgn: '',
                      isComputerAnalysisAllowed: true,
                      variant: Variant.standard,
                    ),
                  ),
                ),
              ),
            ),
            _ToolsButton(
              leading: const Icon(Icons.explore_outlined),
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
              leading: const Icon(Icons.edit_outlined),
              title: context.l10n.boardEditor,
              onTap: () => Navigator.of(
                context,
                rootNavigator: true,
              ).push(BoardEditorScreen.buildRoute(context)),
            ),
            ListTile(
              leading: const Icon(Icons.alarm_outlined),
              title: Text(context.l10n.clock),
              trailing: Theme.of(context).platform == TargetPlatform.iOS
                  ? const CupertinoListTileChevron()
                  : null,
              onTap: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).push(ClockToolScreen.buildRoute(context));
              },
            ),
          ],
        ),
        if (Theme.of(context).platform == TargetPlatform.android)
          ListSection(
            hasLeading: true,
            children: [
              ListTile(
                leading: Icon(
                  LichessIcons.patron,
                  semanticLabel: context.l10n.patronLichessPatron,
                  color: context.lichessColors.brag,
                ),
                title: Text(context.l10n.patronDonate),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const Icon(Icons.chevron_right)
                    : null,
                enabled: isOnline,
                onTap: () {
                  launchUrl(Uri.parse('https://lichess.org/patron'));
                },
              ),
            ],
          ),
        Padding(
          padding: Styles.bodySectionPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LichessMessage(style: TextTheme.of(context).bodyMedium),
              const SizedBox(height: 10),
              Text('v${packageInfo.version}', style: TextTheme.of(context).bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
