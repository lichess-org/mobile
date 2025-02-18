import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/http_log/http_log_providers.dart';
import 'package:lichess_mobile/src/model/http_log/http_log_storage.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

// TODO localize
class HttpLogScreen extends ConsumerWidget {
  const HttpLogScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const HttpLogScreen(), title: 'HTTP Logs');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(httpLogsNotifierProvider);
    return PlatformScaffold(
      appBar: const PlatformAppBar(title: Text('HTTP Logs')),
      body: switch (state) {
        final InitialHttpLogsState _ => const Center(child: Text('Loading...')),
        final ErrorHttpLogsState error => Center(child: Text('Error: ${error.error}')),
        final DataHttpLogsState data => _HttpLogList(logs: data.httpLogs.toList()),
        final LoadingHttpLogsState loading => _HttpLogList(logs: loading.httpLogs.toList()),
      },
    );
  }
}

class _HttpLogList extends StatelessWidget {
  const _HttpLogList({super.key, required this.logs});

  final List<HttpLog> logs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => HttpLogTile(httpLog: logs[index]),
      itemCount: logs.length,
    );
  }
}

class HttpLogTile extends StatelessWidget {
  const HttpLogTile({super.key, required this.httpLog});

  final HttpLog httpLog;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      title: Text('${httpLog.requestMethod} ${httpLog.requestUrl}'),
      subtitle: Text(httpLog.responseCode != null ? 'Code: ${httpLog.responseCode}' : 'Pending...'),
    );
  }
}
