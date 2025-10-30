import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tournament_providers.g.dart';

@riverpod
Future<IList<LightTournament>> featuredTournaments(Ref ref) {
  // logged in users get personalized featured tournaments
  ref.watch(authSessionProvider);
  return ref.read(tournamentRepositoryProvider).featured();
}

@riverpod
Future<TournamentLists> tournaments(Ref ref) {
  return ref.read(tournamentRepositoryProvider).getTournaments();
}

@riverpod
Future<TournamentPlayer> tournamentPlayer(
  Ref ref,
  TournamentId tournamentId,
  UserId userId,
) {
  return ref.withClientCacheFor(
    (client) => ref
        .read(tournamentRepositoryProvider)
        .getTournamentPlayer(tournamentId, userId),
    const Duration(seconds: 10),
  );
}
