import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/log/app_log_paginator.dart';
import 'package:lichess_mobile/src/model/log/app_log_service.dart';
import 'package:lichess_mobile/src/model/log/app_log_storage.dart';
import 'package:lichess_mobile/src/model/settings/log_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/haptic_refresh_indicator.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

final Logger _logger = Logger('AppLogSettingsScreen');

final _logDateFormatter = DateFormat.yMd().add_Hms();

class AppLogSettingsScreen extends ConsumerStatefulWidget {
  const AppLogSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const AppLogSettingsScreen());
  }

  @override
  ConsumerState<AppLogSettingsScreen> createState() => _AppLogSettingsScreenState();
}

class _AppLogSettingsScreenState extends ConsumerState<AppLogSettingsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      final currentState = ref.read(appLogPaginatorProvider(_searchQuery));
      if (currentState.hasValue && !currentState.isLoading && currentState.requireValue.hasMore) {
        ref.read(appLogPaginatorProvider(_searchQuery).notifier).next();
      }
    }
  }

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return ref.read(appLogPaginatorProvider(_searchQuery).notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final currentLevel = ref.watch(logPreferencesProvider.select((prefs) => prefs.level));
    final asyncState = ref.watch(appLogPaginatorProvider(_searchQuery));
    final logs = asyncState.value?.logs ?? [];

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('App Logs'),
        actions: [
          if (logs.isNotEmpty)
            IconButton(
              tooltip: 'Export',
              icon: const Icon(Icons.share),
              onPressed: () => launchShareDialog(
                context,
                ShareParams(
                  text: logs
                      .map(
                        (entry) =>
                            '[${_logDateFormatter.format(entry.logTime)}] [${entry.loggerName}] [${entry.levelName}] ${entry.message}',
                      )
                      .join('\n'),
                ),
              ),
            ),
          if (asyncState.value?.isDeleteButtonVisible == true)
            IconButton(
              tooltip: 'Delete all logs',
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                showConfirmDialog<dynamic>(
                  context,
                  title: const Text('Delete all logs'),
                  onConfirm: () {
                    ref.read(appLogServiceProvider).clear();
                    ref.read(appLogPaginatorProvider(_searchQuery).notifier).deleteAll();
                  },
                );
              },
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: PlatformSearchBar(
                    controller: _searchController,
                    hintText: 'Search logs...',
                    onChanged: (value) => setState(() {
                      _searchQuery = value.isEmpty ? null : value;
                    }),
                    onClear: () => setState(() {
                      _searchQuery = null;
                      _searchController.clear();
                    }),
                  ),
                ),
                TextButton(
                  onPressed: () {
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
                  child: Text(currentLevel.name),
                ),
              ],
            ),
          ),
        ),
      ),
      body: switch (asyncState) {
        AsyncData(:final value) when value.logs.isEmpty => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No logs to show'),
              TextButton(onPressed: _onRefresh, child: const Text('Tap to refresh')),
            ],
          ),
        ),
        AsyncData(:final value) => HapticRefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.separated(
            controller: _scrollController,
            itemCount: value.logs.length,
            separatorBuilder: (_, _) => const Divider(height: 1, thickness: 0),
            itemBuilder: (_, index) => _LogTile(entry: value.logs[index]),
          ),
        ),
        AsyncError(:final error) => Center(
          child: Padding(
            padding: Styles.bodySectionPadding,
            child: Text('Failed to load logs: $error'),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator.adaptive()),
      },
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.entry});

  final AppLogEntry entry;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: SizedBox(
        width: 30,
        child: Text(entry.levelName, style: const TextStyle(fontSize: 12)),
      ),
      title: Text(
        '[${entry.loggerName}] ${entry.message}',
        style: const TextStyle(fontSize: 14, letterSpacing: -0.15),
      ),
      subtitle: Text(
        _logDateFormatter.format(entry.logTime),
        style: TextStyle(color: textShade(context, 0.7), fontSize: 12),
      ),
    );
  }
}
