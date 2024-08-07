import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'opening_explorer_repository.g.dart';
part 'opening_explorer_repository.freezed.dart';

@riverpod
Stream<OpeningExplorer> openingExplorer(
  OpeningExplorerRef ref, {
  required String fen,
}) async* {
  final prefs = ref.watch(openingExplorerPreferencesProvider);
  final client = ref.read(lichessClientProvider);
  final stream = switch (prefs.db) {
    OpeningDatabase.master => OpeningExplorerRepository(client)
        .getMasterDatabase(
          fen,
          since: prefs.masterDb.sinceYear,
        )
        .asStream(),
    OpeningDatabase.lichess => OpeningExplorerRepository(client)
        .getLichessDatabase(
          fen,
          speeds: prefs.lichessDb.speeds,
          ratings: prefs.lichessDb.ratings,
          since: prefs.lichessDb.since,
        )
        .asStream(),
    OpeningDatabase.player =>
      await OpeningExplorerRepository(client).getPlayerDatabase(
        fen,
        // null check handled by widget
        usernameOrId: prefs.playerDb.usernameOrId!,
        color: prefs.playerDb.side,
        speeds: prefs.playerDb.speeds,
        modes: prefs.playerDb.modes,
        since: prefs.playerDb.since,
      ),
  };

  ref.read(openingExplorerDataProvider.notifier).setIndexing(true);
  await for (final openingExplorer in stream) {
    yield openingExplorer;
  }
  ref.read(openingExplorerDataProvider.notifier).setIndexing(false);
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

  Future<Stream<OpeningExplorer>> getPlayerDatabase(
    String fen, {
    required String usernameOrId,
    required Side color,
    required ISet<Perf> speeds,
    required ISet<Mode> modes,
    DateTime? since,
  }) {
    return client.readNdJsonStream(
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

@riverpod
class OpeningExplorerData extends _$OpeningExplorerData {
  @override
  OpeningExplorerDataState build() {
    return const OpeningExplorerDataState(
      isIndexing: false,
    );
  }

  void setIndexing(bool isIndexing) =>
      state = state.copyWith(isIndexing: isIndexing);
}

@freezed
class OpeningExplorerDataState with _$OpeningExplorerDataState {
  const factory OpeningExplorerDataState({
    required bool isIndexing,
  }) = _OpeningExplorerDataState;
}
