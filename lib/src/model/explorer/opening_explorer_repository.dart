import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/chess.dart' show Variant;
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';

final openingExplorerProvider = AsyncNotifierProvider.autoDispose
    .family<
      OpeningExplorer,
      ({OpeningExplorerEntry entry, bool isIndexing})?,
      ({String fen, Variant variant})
    >((request) => OpeningExplorer(request.fen, request.variant), name: 'OpeningExplorerProvider');

class OpeningExplorer extends AsyncNotifier<({OpeningExplorerEntry entry, bool isIndexing})?> {
  OpeningExplorer(this.fen, this.variant);

  final String fen;
  final Variant variant;

  StreamSubscription<OpeningExplorerEntry>? _openingExplorerSubscription;

  @override
  Future<({OpeningExplorerEntry entry, bool isIndexing})?> build() async {
    ref.onDispose(() {
      _openingExplorerSubscription?.cancel();
    });

    await ref.debounce(const Duration(milliseconds: 300));

    final prefs = ref.watch(openingExplorerPreferencesProvider);
    final db = _openingExplorerDatabaseFor(prefs.db, variant);
    final repository = ref.read(openingExplorerRepositoryProvider);
    switch (db) {
      case OpeningDatabase.master:
        final openingExplorer = await repository.getMasterDatabase(
          fen,
          since: prefs.masterDb.sinceYear,
        );
        return (entry: openingExplorer, isIndexing: false);
      case OpeningDatabase.lichess:
        final openingExplorer = await repository.getLichessDatabase(
          fen,
          variant: variant,
          speeds: prefs.lichessDb.speeds,
          ratings: prefs.lichessDb.ratings,
          since: prefs.lichessDb.since,
        );
        return (entry: openingExplorer, isIndexing: false);
      case OpeningDatabase.player:
        final openingExplorerStream = await repository.getPlayerDatabase(
          fen,
          variant: variant,
          // null check handled by widget
          usernameOrId: prefs.playerDb.username!,
          color: prefs.playerDb.side,
          speeds: prefs.playerDb.speeds,
          gameModes: prefs.playerDb.gameModes,
          since: prefs.playerDb.since,
        );

        _openingExplorerSubscription = openingExplorerStream.listen(
          (openingExplorer) => state = AsyncValue.data((entry: openingExplorer, isIndexing: true)),
          onDone: () => state.value != null
              ? state = AsyncValue.data((entry: state.value!.entry, isIndexing: false))
              : state = AsyncValue.error(
                  'No opening explorer data returned for player ${prefs.playerDb.username}',
                  StackTrace.current,
                ),
        );
        return null;
    }
  }
}

/// A provider for [OpeningExplorerRepository].
final openingExplorerRepositoryProvider = Provider<OpeningExplorerRepository>((Ref ref) {
  return OpeningExplorerRepository(ref.watch(lichessClientProvider));
}, name: 'OpeningExplorerRepositoryProvider');

Uri _explorerUri(String path, [Map<String, dynamic>? queryParameters]) =>
    kLichessOpeningExplorerHost.startsWith('localhost') ||
        kLichessOpeningExplorerHost.startsWith('10.') ||
        kLichessOpeningExplorerHost.startsWith('192.168.')
    ? Uri.http(kLichessOpeningExplorerHost, path, queryParameters)
    : Uri.https(kLichessOpeningExplorerHost, path, queryParameters);

class OpeningExplorerRepository {
  const OpeningExplorerRepository(this.client);

  final Client client;

  Future<OpeningExplorerEntry> getMasterDatabase(String fen, {int? since}) {
    return client.readJson(
      _explorerUri('/masters', {
        'source': 'mobile',
        'fen': fen,
        if (since != null) 'since': since.toString(),
      }),
      mapper: OpeningExplorerEntry.fromJson,
    );
  }

  Future<OpeningExplorerEntry> getLichessDatabase(
    String fen, {
    required Variant variant,
    required ISet<Speed> speeds,
    required ISet<int> ratings,
    DateTime? since,
  }) {
    return client.readJson(
      _explorerUri('/lichess', {
        'source': 'mobile',
        'variant': _openingExplorerVariantKey(variant),
        'fen': fen,
        if (speeds.isNotEmpty) 'speeds': speeds.map((speed) => speed.name).join(','),
        if (ratings.isNotEmpty) 'ratings': ratings.join(','),
        if (since != null) 'since': '${since.year}-${since.month}',
      }),
      mapper: OpeningExplorerEntry.fromJson,
    );
  }

  Future<Stream<OpeningExplorerEntry>> getPlayerDatabase(
    String fen, {
    required Variant variant,
    required String usernameOrId,
    required Side color,
    required ISet<Speed> speeds,
    required ISet<GameMode> gameModes,
    DateTime? since,
  }) {
    return client.readNdJsonStream(
      _explorerUri('/player', {
        'source': 'mobile',
        'variant': _openingExplorerVariantKey(variant),
        'fen': fen,
        'player': usernameOrId,
        'color': color.name,
        if (speeds.isNotEmpty) 'speeds': speeds.map((speed) => speed.name).join(','),
        if (gameModes.isNotEmpty) 'modes': gameModes.map((gameMode) => gameMode.name).join(','),
        if (since != null) 'since': '${since.year}-${since.month}',
      }),
      mapper: OpeningExplorerEntry.fromJson,
    );
  }
}

// Opening explorer treats imported/custom positions as standard chess.
// Other variants must be explicit or the API falls back to standard data.
String _openingExplorerVariantKey(Variant variant) =>
    variant == Variant.fromPosition ? Variant.standard.name : variant.name;

OpeningDatabase _openingExplorerDatabaseFor(OpeningDatabase db, Variant variant) {
  // The masters endpoint has no variant parameter. For variants, fall back to
  // Lichess DB instead of asking users to change their persisted setting.
  if (db == OpeningDatabase.master &&
      variant != Variant.standard &&
      variant != Variant.fromPosition) {
    return OpeningDatabase.lichess;
  }
  return db;
}
