import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/log.dart';
import 'package:lichess_mobile/src/model/settings/log_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

final Logger _logger = Logger('AppLogSettingsScreen');

class AppLogSettingsScreen extends ConsumerWidget {
  const AppLogSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const AppLogSettingsScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLevel = ref.watch(logPreferencesProvider.select((prefs) => prefs.level));
    final logs = ref
        .watch(appLogStorageProvider.select((state) => state.logs))
        .reversed
        .map(
          (record) =>
              '[${record.time.hour}:${record.time.minute}:${record.time.second}] [${record.loggerName}] ${record.message}',
        )
        .join('\n');

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Logs'),
        actions: [
          IconButton(
            tooltip: 'Export',
            icon: const Icon(Icons.share),
            onPressed: () => launchShareDialog(context, ShareParams(text: logs)),
          ),
          IconButton(
            tooltip: 'Delete all logs',
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              showConfirmDialog<dynamic>(
                context,
                title: const Text('Delete all logs'),
                onConfirm: ref.read(appLogStorageProvider.notifier).clear,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ListSection(
            children: [
              SettingsListTile(
                settingsLabel: const Text('Log Level'),
                settingsValue: currentLevel.name,
                onTap: () {
                  showChoicePicker<Level>(
                    context,
                    choices: Level.LEVELS,
                    selectedItem: currentLevel,
                    labelBuilder: (Level l) => Text(l.name),
                    onSelectedItemChanged: (Level value) {
                      _logger.fine('Changing log level to ${value.name}');
                      ref.read(logPreferencesProvider.notifier).setLogLevel(value);
                    },
                  );
                },
              ),
            ],
          ),
          if (logs.isNotEmpty)
            Expanded(
              child: Padding(
                padding: Styles.bodySectionPadding,
                child: Card(
                  margin: EdgeInsets.zero,
                  child: SingleChildScrollView(
                    child: Padding(padding: const EdgeInsets.all(8.0), child: Text(logs)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
