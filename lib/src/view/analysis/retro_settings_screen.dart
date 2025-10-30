import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/retro_controller.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/engine_settings_widget.dart';

class RetroSettingsScreen extends ConsumerWidget {
  const RetroSettingsScreen(this.options);

  final RetroOptions options;

  static Route<dynamic> buildRoute(
    BuildContext context, {
    required RetroOptions options,
  }) {
    return buildScreenRoute(context, screen: RetroSettingsScreen(options));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = retroControllerProvider(options);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsSettings)),
      body: ListView(
        children: [
          EngineSettingsWidget(
            onSetEngineSearchTime: (value) {
              ref.read(ctrlProvider.notifier).setEngineSearchTime(value);
            },
            onSetEngineCores: (value) {
              ref.read(ctrlProvider.notifier).setEngineCores(value);
            },
          ),
        ],
      ),
    );
  }
}
