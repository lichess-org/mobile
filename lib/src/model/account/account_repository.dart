import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'account_preferences.dart';
import 'ongoing_game.dart';

part 'account_repository.g.dart';

@riverpod
Future<User?> account(AccountRef ref) async {
  final session = ref.watch(authSessionProvider);
  if (session == null) return null;

  return ref.withClientCacheFor(
    (client) => AccountRepository(client).getProfile(),
    const Duration(hours: 1),
  );
}

@riverpod
Future<LightUser?> accountUser(AccountUserRef ref) async {
  return ref.watch(accountProvider.selectAsync((user) => user?.lightUser));
}

@riverpod
Future<IList<UserActivity>> accountActivity(AccountActivityRef ref) async {
  final session = ref.watch(authSessionProvider);
  if (session == null) return IList();
  return ref.withClientCacheFor(
    (client) => UserRepository(client).getActivity(session.user.id),
    const Duration(hours: 1),
  );
}

@riverpod
Future<IList<LightArchivedGame>> accountRecentGames(
  AccountRecentGamesRef ref,
) async {
  final session = ref.watch(authSessionProvider);
  if (session == null) return IList();
  return ref.withClientCacheFor(
    (client) => GameRepository(client).getRecentGames(session.user.id),
    const Duration(hours: 1),
  );
}

@riverpod
Future<IList<OngoingGame>> ongoingGames(OngoingGamesRef ref) async {
  final session = ref.watch(authSessionProvider);
  if (session == null) return IList();

  return ref.withClientCacheFor(
    (client) => AccountRepository(client).getOngoingGames(nb: 20),
    const Duration(hours: 1),
  );
}

class AccountRepository {
  AccountRepository(this.client);

  final http.Client client;
  final Logger _log = Logger('AccountRepository');

  Future<User> getProfile() {
    return client.readJson(
      Uri(path: '/api/account'),
      mapper: User.fromServerJson,
    );
  }

  Future<void> saveProfile(Map<String, String> profile) async {
    final uri = Uri(path: '/account/profile');
    final response = await client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: profile,
    );

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Failed to post save profile: ${response.statusCode}',
        uri,
      );
    }
  }

  Future<IList<OngoingGame>> getOngoingGames({int? nb}) {
    return client.readJson(
      Uri(
        path: '/api/account/playing',
        queryParameters: nb != null
            ? {
                'nb': nb.toString(),
              }
            : null,
      ),
      mapper: (Map<String, dynamic> json) {
        final list = json['nowPlaying'];
        if (list is! List<dynamic>) {
          _log.severe(
            'Could not read json object as {nowPlaying: []}: expected a list.',
          );
          throw Exception('Could not read json object as {nowPlaying: []}');
        }
        return list
            .map((e) => _ongoingGameFromJson(e as Map<String, dynamic>))
            .where((e) => e.variant.isSupported)
            .toIList();
      },
    );
  }

  Future<AccountPrefState> getPreferences() {
    return client.readJson(
      Uri(path: '/api/account/preferences'),
      mapper: (Map<String, dynamic> json) {
        return _accountPreferencesFromPick(
          pick(json, 'prefs').required(),
        );
      },
    );
  }

  Future<void> setPreference<T>(String prefKey, AccountPref<T> pref) async {
    final uri = Uri(path: '/api/account/preferences/$prefKey');

    final response = await client.post(uri, body: {prefKey: pref.toFormData});

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Failed to set preference: ${response.statusCode}',
        uri,
      );
    }
  }
}

AccountPrefState _accountPreferencesFromPick(RequiredPick pick) {
  return (
    zenMode: Zen.fromInt(
      pick('zen').asIntOrThrow(),
    ),
    showRatings: BooleanPref.fromInt(pick('ratings').asIntOrThrow()),
    premove: BooleanPref(pick('premove').asBoolOrThrow()),
    autoQueen: AutoQueen.fromInt(
      pick('autoQueen').asIntOrThrow(),
    ),
    autoThreefold: AutoThreefold.fromInt(
      pick('autoThreefold').asIntOrThrow(),
    ),
    takeback: Takeback.fromInt(
      pick('takeback').asIntOrThrow(),
    ),
    moretime: Moretime.fromInt(
      pick('moretime').asIntOrThrow(),
    ),
    confirmResign: BooleanPref.fromInt(
      pick('confirmResign').asIntOrThrow(),
    ),
    submitMove: SubmitMove.fromInt(
      pick('submitMove').asIntOrThrow(),
    ),
    follow: BooleanPref(pick('follow').asBoolOrThrow()),
  );
}

OngoingGame _ongoingGameFromJson(Map<String, dynamic> json) {
  return _ongoingGameFromPick(pick(json).required());
}

OngoingGame _ongoingGameFromPick(RequiredPick pick) {
  return OngoingGame(
    id: GameId(pick('gameId').asStringOrThrow()),
    fullId: GameFullId(pick('fullId').asStringOrThrow()),
    orientation: pick('color').asSideOrThrow(),
    fen: pick('fen').asStringOrThrow(),
    lastMove: pick('lastMove').asUciMoveOrNull(),
    perf: pick('perf').asPerfOrThrow(),
    speed: pick('speed').asSpeedOrThrow(),
    variant: pick('variant').asVariantOrThrow(),
    opponent: pick('opponent').asLightUserOrNull(),
    opponentRating: pick('opponent', 'rating').asIntOrNull(),
    opponentAiLevel: pick('opponent', 'aiLevel').asIntOrNull(),
    secondsLeft: pick('secondsLeft').asIntOrNull(),
    isMyTurn: pick('isMyTurn').asBoolOrThrow(),
  );
}
