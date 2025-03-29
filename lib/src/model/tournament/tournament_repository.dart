import 'package:deep_pick/deep_pick.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tournament_repository.g.dart';

@Riverpod(keepAlive: true)
TournamentRepository tournamentRepository(Ref ref) {
  return TournamentRepository(ref.read(lichessClientProvider));
}

class TournamentRepository {
  TournamentRepository(this.client);

  final Client client;

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
      Uri(path: '/api/tournament/$id'),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) => Tournament.fromServerJson(json),
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
