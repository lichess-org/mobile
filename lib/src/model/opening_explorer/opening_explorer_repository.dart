import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'opening_explorer_repository.g.dart';

@riverpod
Future<MasterOpeningExplorer> masterOpeningDatabase(
  MasterOpeningDatabaseRef ref, {
  required String fen,
}) async {
  final prefs = ref.watch(
    openingExplorerPreferencesProvider.select(
      (state) => state.masterDb,
    ),
  );
  return ref.withClient(
    (client) => OpeningExplorerRepository(client).getMasterDatabase(
      fen,
      since: prefs.sinceYear,
      until: prefs.untilYear,
    ),
  );
}

@riverpod
Future<LichessOpeningExplorer> lichessOpeningDatabase(
  LichessOpeningDatabaseRef ref, {
  required String fen,
}) async {
  final prefs = ref.watch(
    openingExplorerPreferencesProvider.select(
      (state) => state.lichessDb,
    ),
  );
  return ref.withClient(
    (client) => OpeningExplorerRepository(client).getLichessDatabase(
      fen,
      speeds: prefs.speeds,
      ratings: prefs.ratings,
      since: prefs.since,
      until: prefs.until,
    ),
  );
}

class OpeningExplorerRepository {
  const OpeningExplorerRepository(this.client);

  final LichessClient client;

  Future<MasterOpeningExplorer> getMasterDatabase(
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
      mapper: MasterOpeningExplorer.fromJson,
    );
  }

  Future<LichessOpeningExplorer> getLichessDatabase(
    String fen, {
    required ISet<Perf> speeds,
    required ISet<int> ratings,
    DateTime? since,
    DateTime? until,
  }) {
    return client.readJson(
      Uri(
        path: '/lichess',
        queryParameters: {
          'fen': fen,
          if (speeds.isNotEmpty)
            'speeds': speeds.map((speed) => speed.name).join(','),
          if (ratings.isNotEmpty) 'ratings': ratings.join(','),
          if (since != null) 'since': '${since.year}-${since.month}',
          if (until != null) 'until': '${until.year}-${until.month}',
        },
      ),
      mapper: LichessOpeningExplorer.fromJson,
    );
  }
}
