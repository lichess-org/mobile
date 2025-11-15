import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/http_log/http_log_paginator.dart';
import 'package:lichess_mobile/src/model/http_log/http_log_storage.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/haptic_refresh_indicator.dart';

class HttpLogScreen extends ConsumerStatefulWidget {
  const HttpLogScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const HttpLogScreen());
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTTP logs'),
        actions: [
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
      ),
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
            TextButton(onPressed: widget.onRefresh, child: const Text('Tap to refresh')),
          ],
        ),
      );
    }
    return HapticRefreshIndicator(
      key: widget.refreshIndicatorKey,
      onRefresh: widget.onRefresh,
      child: ListView.separated(
        controller: widget.scrollController,
        itemCount: widget.logs.length,
        separatorBuilder: (_, _) => const Divider(height: 1, thickness: 0),
        itemBuilder: (_, index) {
          if (index < 0 || index >= widget.logs.length) {
            return null;
          }

          return HttpLogTile(httpLog: widget.logs[index]);
        },
      ),
    );
  }
}

final _logDateFormatter = DateFormat.yMd().add_Hms();

class HttpLogTile extends StatelessWidget {
  const HttpLogTile({super.key, required this.httpLog});

  final HttpLogEntry httpLog;

  String get endpoint => httpLog.requestUrl.host == kLichessHost
      ? Uri(path: httpLog.requestUrl.path, query: httpLog.requestUrl.query).toString()
      : httpLog.requestUrl.toString();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: SizedBox(
        width: 40,
        child: httpLog.hasResponse
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    httpLog.responseCode!.toString(),
                    style: TextStyle(
                      color: httpLog.responseCode! >= 400 ? context.lichessColors.error : null,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (httpLog.elapsed != null)
                    Text(
                      '${httpLog.elapsed!.inMilliseconds}ms',
                      style: TextStyle(
                        color: textShade(context, 0.7),
                        fontFeatures: const [FontFeature.tabularFigures()],
                        fontSize: 10,
                      ),
                    ),
                ],
              )
            : const Icon(Icons.error_outline, color: Colors.grey),
      ),
      title: Text(
        '${httpLog.requestMethod} $endpoint',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14,
          letterSpacing: -0.15,
          color: httpLog.hasResponse
              ? httpLog.responseCode! >= 400
                    ? context.lichessColors.error
                    : null
              : textShade(context, 0.7),
        ),
      ),
      subtitle: Text(
        _logDateFormatter.format(httpLog.requestDateTime),
        style: TextStyle(color: textShade(context, 0.7), fontSize: 12),
      ),
    );
  }
}
