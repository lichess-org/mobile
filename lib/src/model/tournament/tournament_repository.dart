import 'dart:io' show File;

import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tournament_repository.g.dart';

@Riverpod(keepAlive: true)
TournamentRepository tournamentRepository(Ref ref) {
  return TournamentRepository(ref.read(lichessClientProvider), ref);
}

class TournamentRepository {
  TournamentRepository(this.client, Ref ref) : _ref = ref;

  final Ref _ref;
  final http.Client client;

  Future<IList<LightTournament>> featured() {
    return client.readJson(
      Uri(path: '/tournament/featured'),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) => pick(json, 'featured').asTournamentListOrThrow(),
    );
  }

  Future<TournamentLists> getTournaments() {
    return client.readJson(
      Uri(path: '/api/tournament'),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) {
        return (
          started: pick(json, 'started').asTournamentListOrThrow(),
          created: pick(json, 'created').asTournamentListOrThrow(),
          finished: pick(json, 'finished').asTournamentListOrThrow(),
        );
      },
    );
  }

  Future<Tournament> getTournament(TournamentId id) {
    return client.readJson(
      Uri(path: '/api/tournament/$id', queryParameters: {'chat': '1', 'socketVersion': '1'}),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) => Tournament.fromServerJson(json),
    );
  }

  Future<bool> downloadTournamentGames(TournamentId id, File file, {UserId? userId}) {
    final client = _ref.read(defaultClientProvider);
    return downloadFile(
      client,
      lichessUri('/api/tournament/$id/games', userId != null ? {'player': userId.value} : null),
      file,
    );
  }

  Future<Tournament> reload(Tournament tournament, {required int standingsPage}) {
    return client.readJson(
      Uri(
        path: tournament.reloadEndpoint ?? '/api/tournament/${tournament.id}',
        queryParameters: {'page': standingsPage.toString(), 'partial': 'true'},
      ),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) => tournament.updateFromPartialServerJson(json),
    );
  }

  Future<void> join(TournamentId id) async {
    final uri = Uri(path: '/api/tournament/$id/join');
    final response = await client.post(uri);
    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to join tournament: ${response.statusCode}', uri);
    }
  }

  Future<void> withdraw(TournamentId id) async {
    final uri = Uri(path: '/api/tournament/$id/withdraw');
    final response = await client.post(uri);

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to withdraw from tournament: ${response.statusCode}', uri);
    }
  }
}
