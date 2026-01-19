import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

final _logDateFormatter = DateFormat.Hms();

class AppLogSettingsScreen extends ConsumerWidget {
  const AppLogSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const AppLogSettingsScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLevel = ref.watch(logPreferencesProvider.select((prefs) => prefs.level));
    final logs = ref.read(appLogServiceProvider).logs.toIList().reversed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Logs'),
        actions: [
          IconButton(
            tooltip: 'Export',
            icon: const Icon(Icons.share),
            onPressed: () => launchShareDialog(
              context,
              ShareParams(
                text: logs
                    .map(
                      (record) =>
                          '[${_logDateFormatter.format(record.time)}] [${record.loggerName}] ${record.message}',
                    )
                    .join('\n'),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Delete all logs',
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              showConfirmDialog<dynamic>(
                context,
                title: const Text('Delete all logs'),
                onConfirm: ref.read(appLogServiceProvider).clear,
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
                  child: ListView.separated(
                    itemCount: logs.length,
                    separatorBuilder: (_, _) => const Divider(height: 1, thickness: 0),
                    itemBuilder: (_, index) => _LogTile(record: logs[index]),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.record});

  final LogRecord record;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: SizedBox(
        width: 30,
        child: Text(record.level.name, style: const TextStyle(fontSize: 12)),
      ),
      title: Text(
        '[${record.loggerName}] ${record.message}',
        style: const TextStyle(fontSize: 14, letterSpacing: -0.15),
      ),
      subtitle: Text(
        _logDateFormatter.format(record.time),
        style: TextStyle(color: textShade(context, 0.7), fontSize: 12),
      ),
    );
  }
}
