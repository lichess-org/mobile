import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/http_log/http_log_controller.dart';
import 'package:lichess_mobile/src/model/http_log/http_log_storage.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
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

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      ref.read(httpLogControllerProvider.notifier).next();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(httpLogControllerProvider);

    Future<void> onRefresh() async {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return ref.read(httpLogControllerProvider.notifier).refresh();
    }

    return PlatformScaffold(
      appBarTitle: const Text('HTTP Logs'),
      appBarActions: [
        IconButton(
          tooltip: 'Clear all logs',
          icon: const Icon(Icons.delete_sweep),
          onPressed: () => ref.read(httpLogControllerProvider.notifier).deleteAll(),
        ),
      ],
      body: switch (state) {
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        AsyncData(:final value) => _HttpLogList(
          scrollController: _scrollController,
          refreshIndicatorKey: _refreshIndicatorKey,
          logs: value.items.toList(),
          onRefresh: onRefresh,
        ),
        AsyncLoading(:final value) => _HttpLogList(
          scrollController: _scrollController,
          refreshIndicatorKey: _refreshIndicatorKey,
          logs: value?.items.toList() ?? [],
          onRefresh: onRefresh,
        ),
        _ => const CircularProgressIndicator(),
      },
    );
  }
}

class _HttpLogList extends StatelessWidget {
  const _HttpLogList({
    required this.logs,
    required this.onRefresh,
    required this.scrollController,
    required this.refreshIndicatorKey,
  });

  final List<HttpLog> logs;
  final ScrollController scrollController;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      key: refreshIndicatorKey,
      edgeOffset:
          Theme.of(context).platform == TargetPlatform.iOS
              ? MediaQuery.paddingOf(context).top + 16.0
              : 0,
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        itemBuilder: (context, index) => HttpLogTile(httpLog: logs[index]),
        itemCount: logs.length,
      ),
    );
  }
}

class HttpLogTile extends StatelessWidget {
  const HttpLogTile({super.key, required this.httpLog});

  final HttpLog httpLog;

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
