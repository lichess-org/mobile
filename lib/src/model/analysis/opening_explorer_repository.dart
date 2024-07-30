import 'package:lichess_mobile/src/model/analysis/opening_explorer.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'opening_explorer_repository.g.dart';

@riverpod
Future<OpeningExplorer> masterDatabase(
  MasterDatabaseRef ref, {
  required String fen,
  int? sinceYear,
  int? untilYear,
}) async {
  return ref.withClient(
    (client) => OpeningExplorerRepository(client)
        .getMasterDatabase(fen, since: sinceYear, until: untilYear),
  );
}

class OpeningExplorerRepository {
  const OpeningExplorerRepository(this.client);

  final LichessClient client;

  Future<OpeningExplorer> getMasterDatabase(
    String fen, {
    int? since,
    int? until,
  }) {
    return client.readJson(
      Uri(
        path: '/masters',
        queryParameters: {
          'fen': fen,
          if (since != null) 'since': since.toString(),
          if (until != null) 'until': until.toString(),
        },
      ),
      mapper: OpeningExplorer.fromJson,
    );
  }
}
