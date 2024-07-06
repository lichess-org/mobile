import 'package:lichess_mobile/src/model/analysis/opening_explorer.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'opening_explorer_repository.g.dart';

@riverpod
Future<OpeningExplorer> masterDatabase(
  MasterDatabaseRef ref, {
  required String fen,
}) async {
  return ref.withClient(
    (client) => OpeningExplorerRepository(client).getMasterDatabase(fen),
  );
}

class OpeningExplorerRepository {
  const OpeningExplorerRepository(this.client);

  final LichessClient client;

  Future<OpeningExplorer> getMasterDatabase(String fen) {
    return client.readJson(
      Uri(path: '/masters', queryParameters: {'fen': fen}),
      mapper: OpeningExplorer.fromJson,
    );
  }
}
