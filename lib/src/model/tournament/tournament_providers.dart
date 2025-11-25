import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';

final featuredTournamentsProvider = FutureProvider.autoDispose<IList<LightTournament>>((Ref ref) {
  // logged in users get personalized featured tournaments
  ref.watch(authControllerProvider);
  return ref.read(tournamentRepositoryProvider).featured();
}, name: 'FeaturedTournamentsProvider');

final tournamentsProvider = FutureProvider.autoDispose<TournamentLists>((Ref ref) {
  return ref.read(tournamentRepositoryProvider).getTournaments();
}, name: 'TournamentsProvider');

final tournamentPlayerProvider = FutureProvider.autoDispose
    .family<TournamentPlayer, (TournamentId, UserId)>((Ref ref, (TournamentId, UserId) params) {
      return ref.withClientCacheFor(
        (client) =>
            ref.read(tournamentRepositoryProvider).getTournamentPlayer(params.$1, params.$2),
        const Duration(seconds: 10),
      );
    }, name: 'TournamentPlayerProvider');
