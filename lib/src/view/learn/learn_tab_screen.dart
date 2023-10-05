import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';

class LearnTabScreen extends StatelessWidget {
  const LearnTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.puzzles)),
      body: const Center(child: _Body()),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        controller: puzzlesScrollController,
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(context.l10n.learnMenu),
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
      Padding(
        padding: Styles.bodySectionPadding,
        child: CardButton(
          icon: const Icon(
            Icons.biotech,
            size: 44,
            color: LichessColors.brag,
          ),
          title: Text(
            context.l10n.analysis,
            style: Styles.sectionTitle,
          ),
          onTap: () => pushPlatformRoute(
            context,
            rootNavigator: true,
            builder: (context) => AnalysisScreen(
              title: context.l10n.analysis,
              options: AnalysisOptions(
                isLocalEvaluationAllowed: true,
                variant: Variant.standard,
                initialFen: kInitialEPD,
                initialPly: 0,
                moves: IList(),
                orientation: Side.white,
                id: const ValueId('standalone_analysis'),
              ),
            ),
          ),
        ),
      ),
    ];

    return defaultTargetPlatform == TargetPlatform.iOS
        ? SliverList(delegate: SliverChildListDelegate(content))
        : ListView(
            controller: puzzlesScrollController,
            children: content,
          );
  }
}
