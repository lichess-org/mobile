import 'package:lichess_mobile/src/model/analysis/opening_explorer.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'opening_explorer_repository.g.dart';

@riverpod
Future<OpeningExplorer> openingExplorer(
  OpeningExplorerRef ref, {
  required String fen,
}) async {
  return ref.withClient(
    (client) => OpeningExplorerRepository(client).getOpeningExplorer(fen),
  );
}

class OpeningExplorerRepository {
  const OpeningExplorerRepository(this.client);

  final LichessClient client;

  Future<OpeningExplorer> getOpeningExplorer(String fen) {
    return client.readJson(
      Uri(path: '/masters'),
      mapper: OpeningExplorer.fromJson,
    );
  }
}
