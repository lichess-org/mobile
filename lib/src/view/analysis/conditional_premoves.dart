import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

class ConditionalPremoves extends ConsumerWidget {
  const ConditionalPremoves(this.options);

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);
    final analysisState = ref.watch(ctrlProvider).requireValue;

    return Column(
      children: [
        ...analysisState.forecast!.lines.map(
          (line) => Row(
            children: analysisState.liveMoveBranch!
                .branchesOn(line)
                .map((branch) => Text('${branch.sanMove.san} '))
                .toList(),
          ),
        ),
        if (analysisState.currentPremoveCandidate != null) Text('can add!') else Text('nope'),
      ],
    );
  }
}
