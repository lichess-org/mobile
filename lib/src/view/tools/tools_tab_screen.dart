import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/profile_button.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_position_choice_screen.dart';
import 'package:lichess_mobile/src/view/clock/clock_screen.dart';
import 'package:lichess_mobile/src/view/settings/settings_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
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
    final session = ref.watch(authSessionProvider);
    return Scaffold(
      appBar: AppBar(
        leading: session != null ? const ProfileButton() : null,
        title: Text(context.l10n.tools),
        actions: const [
          SettingsButton(),
        ],
      ),
      body: const Center(child: _Body()),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    return CupertinoPageScaffold(
      child: CustomScrollView(
        controller: puzzlesScrollController,
        slivers: [
          CupertinoSliverNavigationBar(
            leading: session != null ? const ProfileButton() : null,
            padding: EdgeInsetsDirectional.only(
              start: session == null ? 16.0 : 8.0,
              end: 8.0,
            ),
            largeTitle: Text(context.l10n.tools),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SettingsButton(),
              ],
            ),
          ),
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
    final content = [
      const SizedBox(height: 16.0),
      Padding(
        padding: Styles.bodySectionBottomPadding,
        child: CardButton(
          icon: Icon(
            Icons.biotech,
            size: 44,
            color: context.lichessColors.good,
          ),
          title: Text(
            context.l10n.analysis,
            style: Styles.callout,
          ),
          onTap: () => pushPlatformRoute(
            context,
            builder: (context) => const AnalysisPositionChoiceScreen(),
          ),
        ),
      ),
      Padding(
        padding: Styles.bodySectionBottomPadding,
        child: CardButton(
          icon: Icon(
            Icons.alarm,
            size: 44,
            color: context.lichessColors.primary,
          ),
          title: Text(
            context.l10n.clock,
            style: Styles.callout,
          ),
          onTap: () => pushPlatformRoute(
            context,
            builder: (context) => const ClockScreen(),
            rootNavigator: true,
          ),
        ),
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
