import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'opening_explorer_repository.g.dart';

@riverpod
class OpeningExplorer extends _$OpeningExplorer {
  StreamSubscription<OpeningExplorerEntry>? _openingExplorerSubscription;

  @override
  Future<({OpeningExplorerEntry entry, bool isIndexing})?> build({
    required String fen,
  }) async {
    await ref.debounce(const Duration(milliseconds: 300));
    ref.onDispose(() {
      _openingExplorerSubscription?.cancel();
    });

    final prefs = ref.watch(openingExplorerPreferencesProvider);
    final client = ref.read(defaultClientProvider);
    switch (prefs.db) {
      case OpeningDatabase.master:
        final openingExplorer =
            await OpeningExplorerRepository(client).getMasterDatabase(
          fen,
          since: prefs.masterDb.sinceYear,
        );
        return (entry: openingExplorer, isIndexing: false);
      case OpeningDatabase.lichess:
        final openingExplorer =
            await OpeningExplorerRepository(client).getLichessDatabase(
          fen,
          speeds: prefs.lichessDb.speeds,
          ratings: prefs.lichessDb.ratings,
          since: prefs.lichessDb.since,
        );
        return (entry: openingExplorer, isIndexing: false);
      case OpeningDatabase.player:
        final openingExplorerStream =
            await OpeningExplorerRepository(client).getPlayerDatabase(
          fen,
          // null check handled by widget
          usernameOrId: prefs.playerDb.username!,
          color: prefs.playerDb.side,
          speeds: prefs.playerDb.speeds,
          gameModes: prefs.playerDb.gameModes,
          since: prefs.playerDb.since,
        );

        _openingExplorerSubscription = openingExplorerStream.listen(
          (openingExplorer) => state =
              AsyncValue.data((entry: openingExplorer, isIndexing: true)),
          onDone: () => state.value != null
              ? state = AsyncValue.data(
                  (entry: state.value!.entry, isIndexing: false),
                )
              : state = AsyncValue.error(
                  'No opening explorer data returned for player ${prefs.playerDb.username}',
                  StackTrace.current,
                ),
        );
        return null;
    }
  }
}

class OpeningExplorerRepository {
  const OpeningExplorerRepository(this.client);

  final Client client;

  Future<OpeningExplorerEntry> getMasterDatabase(
    String fen, {
    int? since,
  }) {
    return client.readJson(
      Uri.https(
        kLichessOpeningExplorerHost,
        '/masters',
        {
          'fen': fen,
          if (since != null) 'since': since.toString(),
        },
      ),
      mapper: OpeningExplorerEntry.fromJson,
    );
  }

  Future<OpeningExplorerEntry> getLichessDatabase(
    String fen, {
    required ISet<Speed> speeds,
    required ISet<int> ratings,
    DateTime? since,
  }) {
    return client.readJson(
      Uri.https(
        kLichessOpeningExplorerHost,
        '/lichess',
        {
          'fen': fen,
          if (speeds.isNotEmpty)
            'speeds': speeds.map((speed) => speed.name).join(','),
          if (ratings.isNotEmpty) 'ratings': ratings.join(','),
          if (since != null) 'since': '${since.year}-${since.month}',
        },
      ),
      mapper: OpeningExplorerEntry.fromJson,
    );
  }

  Future<Stream<OpeningExplorerEntry>> getPlayerDatabase(
    String fen, {
    required String usernameOrId,
    required Side color,
    required ISet<Speed> speeds,
    required ISet<GameMode> gameModes,
    DateTime? since,
  }) {
    return client.readNdJsonStream(
      Uri.https(
        kLichessOpeningExplorerHost,
        '/player',
        {
          'fen': fen,
          'player': usernameOrId,
          'color': color.name,
          if (speeds.isNotEmpty)
            'speeds': speeds.map((speed) => speed.name).join(','),
          if (gameModes.isNotEmpty)
            'modes': gameModes.map((gameMode) => gameMode.name).join(','),
          if (since != null) 'since': '${since.year}-${since.month}',
        },
      ),
      mapper: OpeningExplorerEntry.fromJson,
    );
  }
}
