import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'opening_explorer_repository.g.dart';

@riverpod
Future<OpeningExplorer> openingExplorer(
  OpeningExplorerRef ref, {
  required String fen,
}) async {
  final prefs = ref.watch(openingExplorerPreferencesProvider);
  return ref.withClient(
    (client) => switch (prefs.db) {
      OpeningDatabase.master =>
        OpeningExplorerRepository(client).getMasterDatabase(
          fen,
          since: prefs.masterDb.sinceYear,
        ),
      OpeningDatabase.lichess =>
        OpeningExplorerRepository(client).getLichessDatabase(
          fen,
          speeds: prefs.lichessDb.speeds,
          ratings: prefs.lichessDb.ratings,
          since: prefs.lichessDb.since,
        ),
      OpeningDatabase.player =>
        OpeningExplorerRepository(client).getPlayerDatabase(
          fen,
          // null check handled by widget
          usernameOrId: prefs.playerDb.usernameOrId!,
          color: prefs.playerDb.side,
          speeds: prefs.playerDb.speeds,
          modes: prefs.playerDb.modes,
          since: prefs.playerDb.since,
        )
    },
  );
}

class OpeningExplorerRepository {
  const OpeningExplorerRepository(this.client);

  final LichessClient client;

  Future<OpeningExplorer> getMasterDatabase(
    String fen, {
    int? since,
  }) {
    return client.readJson(
      Uri(
        path: '/masters',
        queryParameters: {
          'fen': fen,
          if (since != null) 'since': since.toString(),
        },
      ),
      mapper: OpeningExplorer.fromJson,
    );
  }

  Future<OpeningExplorer> getLichessDatabase(
    String fen, {
    required ISet<Perf> speeds,
    required ISet<int> ratings,
    DateTime? since,
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
        },
      ),
      mapper: OpeningExplorer.fromJson,
    );
  }

  Future<OpeningExplorer> getPlayerDatabase(
    String fen, {
    required String usernameOrId,
    required Side color,
    required ISet<Perf> speeds,
    required ISet<Mode> modes,
    DateTime? since,
  }) {
    return client.readJson(
      Uri(
        path: '/player',
        queryParameters: {
          'fen': fen,
          'player': usernameOrId,
          'color': color.name,
          if (speeds.isNotEmpty)
            'speeds': speeds.map((speed) => speed.name).join(','),
          if (modes.isNotEmpty)
            'modes': modes.map((mode) => mode.name).join(','),
          if (since != null) 'since': '${since.year}-${since.month}',
        },
      ),
      mapper: OpeningExplorer.fromJson,
    );
  }
}
