import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/http_log/http_log_paginator.dart';
import 'package:lichess_mobile/src/model/http_log/http_log_storage.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

// TODO localize
class HttpLogScreen extends ConsumerStatefulWidget {
  const HttpLogScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const HttpLogScreen(), title: 'HTTP Logs');
  }

  @override
  ConsumerState<HttpLogScreen> createState() => _HttpLogScreenState();
}

class _HttpLogScreenState extends ConsumerState<HttpLogScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      final currentState = ref.read(httpLogPaginatorProvider);
      if (currentState.hasValue && !currentState.isLoading && currentState.requireValue.hasMore) {
        ref.read(httpLogPaginatorProvider.notifier).next();
      }
    }
  }

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return ref.read(httpLogPaginatorProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(httpLogPaginatorProvider);
    return PlatformScaffold(
      appBarTitle: const Text('HTTP Logs'),
      appBarActions: [
        if (asyncState.valueOrNull?.isDeleteButtonVisible == true)
          IconButton(
            // TODO localize
            tooltip: 'Clear all logs',
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              showConfirmDialog<dynamic>(
                context,
                // TODO localize
                title: const Text('Delete all logs'),
                onConfirm: () => ref.read(httpLogPaginatorProvider.notifier).deleteAll(),
              );
            },
          ),
      ],
      body: _HttpLogList(
        scrollController: _scrollController,
        refreshIndicatorKey: _refreshIndicatorKey,
        logs: asyncState.valueOrNull?.logs.toList() ?? [],
        onRefresh: _onRefresh,
      ),
    );
  }
}

class _HttpLogList extends ConsumerStatefulWidget {
  const _HttpLogList({
    required this.logs,
    required this.onRefresh,
    required this.scrollController,
    required this.refreshIndicatorKey,
  });

  final List<HttpLogEntry> logs;
  final ScrollController scrollController;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final RefreshCallback onRefresh;

  @override
  ConsumerState<_HttpLogList> createState() => _HttpLogListState();
}

class _HttpLogListState extends ConsumerState<_HttpLogList> {
  @override
  Widget build(BuildContext context) {
    if (widget.logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No logs to show'),
            AdaptiveTextButton(onPressed: widget.onRefresh, child: const Text('Tap to refresh')),
          ],
        ),
      );
    }
    return RefreshIndicator.adaptive(
      key: widget.refreshIndicatorKey,
      edgeOffset:
          Theme.of(context).platform == TargetPlatform.iOS
              ? MediaQuery.paddingOf(context).top + 16.0
              : 0,
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: widget.scrollController,
        itemCount: widget.logs.length,
        itemBuilder: (context, index) => HttpLogTile(httpLog: widget.logs[index]),
      ),
    );
  }
}

class HttpLogTile extends StatelessWidget {
  const HttpLogTile({super.key, required this.httpLog});

  final HttpLogEntry httpLog;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      backgroundColor: switch (httpLog.responseCode) {
        null => Colors.yellow.shade50,
        final int code when code >= 400 => Colors.red.shade100,
        _ => Colors.white,
      },
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '[${httpLog.responseCode ?? '?'}]'),
            const WidgetSpan(child: SizedBox(width: 4)),
            TextSpan(text: '[${httpLog.requestMethod}]'),
            const WidgetSpan(child: SizedBox(width: 4)),
            TextSpan(text: httpLog.requestUrl),
          ],
        ),
      ),
      subtitle: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '[${DateFormat.yMd().add_Hms().format(httpLog.requestDateTime)}]'),
            const WidgetSpan(child: SizedBox(width: 4)),
            if (httpLog.hasResponse) TextSpan(text: '[${httpLog.elapsed!.inMilliseconds} ms]'),
          ],
        ),
      ),
    );
  }
}
