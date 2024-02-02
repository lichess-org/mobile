import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_position_choice_screen.dart';
import 'package:lichess_mobile/src/view/clock/clock_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class ToolsTabScreen extends StatelessWidget {
  const ToolsTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.tools)),
      body: const Center(child: _Body()),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        controller: puzzlesScrollController,
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(context.l10n.tools),
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
      CardButton(
        icon: const Icon(
          Icons.biotech,
          size: 44,
          color: LichessColors.brag,
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
      CardButton(
        icon: const Icon(
          Icons.alarm,
          size: 44,
          color: LichessColors.brag,
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
    ];

    return Padding(
      padding: Styles.bodySectionPadding,
      child: defaultTargetPlatform == TargetPlatform.iOS
          ? SliverList(delegate: SliverChildListDelegate(content))
          : ListView(
              controller: puzzlesScrollController,
              children: content,
            ),
    );
  }
}
