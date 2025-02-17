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

  static const _pageSize = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformScaffold(
      appBar: const PlatformAppBar(title: Text('HTTP Logs')),
      body: ListView.builder(itemBuilder: (context, index) => itemBuilder(context, index, ref)),
    );
  }

  /// Builds the item widget for the ListView.
  ///
  /// This method fetches the HTTP logs data asynchronously and builds the
  /// corresponding widget based on the current index.
  Widget? itemBuilder(BuildContext context, int index, WidgetRef ref) {
    // Calculate the current page and the index within that page.
    final page = index ~/ _pageSize + 1;
    final indexInPage = index % _pageSize;

    // Watch the HTTP logs provider for the current page.
    final responseAsync = ref.watch(httpLogsProvider(page: page, limit: _pageSize));

    // Handle the different states of the asynchronous response.
    return responseAsync.when(
      // If there's an error, display the error message.
      error: (err, stack) => Text(err.toString()),
      // While loading, display a loading message.
      loading: () => const Text('Loading...'),
      // When data is available, build the corresponding widget.
      data: (response) {
        // If the index is out of bounds, return a message or null.
        if (indexInPage >= response.length) {
          return index == 0 ? const Center(child: Text('No logs')) : null;
        }
        // Get the HTTP log for the current index.
        final httpLog = response[indexInPage];
        // Display the HTTP log details.
        return HttpLogTile(httpLog: httpLog);
      },
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
