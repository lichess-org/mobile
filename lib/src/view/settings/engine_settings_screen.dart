import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/stockfish_settings.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class EngineSettingsScreen extends StatelessWidget {
  const EngineSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const EngineSettingsScreen(), title: 'Engine');
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(appBarTitle: const Text('Engine'), body: _Body());
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        StockfishSettingsWidget(
          onSetEngineSearchTime: (value) {
            ref.read(engineEvaluationPreferencesProvider.notifier).setEngineSearchTime(value);
          },
          onSetEngineCores: (value) {
            ref.read(engineEvaluationPreferencesProvider.notifier).setEngineCores(value);
          },
          onSetNumEvalLines: (value) {
            ref.read(engineEvaluationPreferencesProvider.notifier).setNumEvalLines(value);
          },
        ),
      ],
    );
  }
}
