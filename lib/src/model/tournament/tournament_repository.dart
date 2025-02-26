import 'package:deep_pick/deep_pick.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
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
}
