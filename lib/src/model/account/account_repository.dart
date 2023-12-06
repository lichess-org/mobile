import 'dart:convert';

import 'package:async/async.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/errors.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'account_preferences.dart';
import 'ongoing_game.dart';

part 'account_repository.g.dart';

@Riverpod(keepAlive: true)
AccountRepository accountRepository(AccountRepositoryRef ref) {
  final apiClient = ref.watch(authClientProvider);
  return AccountRepository(
    logger: Logger('UserRepository'),
    apiClient: apiClient,
  );
}

@riverpod
Future<User?> account(AccountRef ref) async {
  final session = ref.watch(authSessionProvider);
  final link = ref.cacheFor(const Duration(hours: 1));
  final repo = ref.watch(accountRepositoryProvider);
  if (session != null) {
    final result = await repo.getProfile();
    if (result.isError) {
      link.close();
    }
    return result.asFuture;
  }
  return null;
}

@riverpod
Future<LightUser?> accountUser(AccountUserRef ref) async {
  return ref.watch(accountProvider.selectAsync((user) => user?.lightUser));
}

@riverpod
Future<IList<UserActivity>> accountActivity(AccountActivityRef ref) async {
  final session = ref.watch(authSessionProvider);
  final link = ref.cacheFor(const Duration(hours: 1));
  final repo = ref.watch(userRepositoryProvider);
  if (session != null) {
    final result = await repo.getUserActivity(session.user.id);
    if (result.isError) {
      link.close();
    }
    return result.asFuture;
  }
  return IList();
}

@riverpod
Future<IList<ArchivedGameData>> accountRecentGames(
  AccountRecentGamesRef ref,
) async {
  final session = ref.watch(authSessionProvider);
  final link = ref.cacheFor(const Duration(hours: 1));
  final repo = ref.watch(gameRepositoryProvider);
  if (session != null) {
    final result = await repo.getUserGames(session.user.id);
    if (result.isError) {
      link.close();
    }
    return result.asFuture;
  }

  return IList();
}

@riverpod
Future<IList<OngoingGame>> ongoingGames(OngoingGamesRef ref) async {
  final session = ref.watch(authSessionProvider);
  final link = ref.cacheFor(const Duration(hours: 1));
  final repo = ref.watch(accountRepositoryProvider);
  if (session != null) {
    final result = await repo.getOngoingGames();
    if (result.isError) {
      link.close();
    }
    return result.asFuture;
  }
  return IList();
}

class AccountRepository {
  const AccountRepository({
    required AuthClient apiClient,
    required Logger logger,
  })  : _apiClient = apiClient,
        _log = logger;

  final AuthClient _apiClient;
  final Logger _log;

  FutureResult<User> getProfile() {
    return _apiClient.get(Uri.parse('$kLichessHost/api/account')).then(
          (result) => result.flatMap(
            (response) => readJsonObjectFromResponse(
              response,
              mapper: User.fromServerJson,
              logger: _log,
            ),
          ),
        );
  }

  FutureResult<void> saveProfile(Map<String, String> profile) {
    return _apiClient.post(
      Uri.parse('$kLichessHost/account/profile'),
      headers: {'Accept': 'application/json'},
      body: profile,
    );
  }

  FutureResult<IList<OngoingGame>> getOngoingGames() {
    return _apiClient.get(Uri.parse('$kLichessHost/api/account/playing')).then(
          (result) => result.flatMap(
            (response) => Result(() {
              final dynamic obj = jsonDecode(utf8.decode(response.bodyBytes));
              if (obj is! Map<String, dynamic>) {
                _log.severe(
                  'Could not read json object as {nowPlaying: []}: expected an object.',
                );
                throw DataFormatException();
              }
              final list = obj['nowPlaying'];
              if (list is! List<dynamic>) {
                _log.severe(
                  'Could not read json object as {nowPlaying: []}: expected a list.',
                );
                throw DataFormatException();
              }
              return list;
            }).flatMap(
              (list) => readJsonListOfObjects(
                list,
                mapper: _ongoingGameFromJson,
                logger: _log,
              ),
            ),
          ),
        );
  }

  FutureResult<AccountPrefState> getPreferences() {
    return _apiClient
        .get(Uri.parse('$kLichessHost/api/account/preferences'))
        .then(
          (result) => result.flatMap(
            (response) => readJsonObjectFromResponse(
              response,
              mapper: (Map<String, dynamic> json) {
                return _accountPreferencesFromPick(
                  pick(json, 'prefs').required(),
                );
              },
              logger: _log,
            ),
          ),
        );
  }

  FutureResult<void> setPreference<T>(String prefKey, AccountPref<T> pref) {
    return _apiClient.post(
      Uri.parse('$kLichessHost/api/account/preferences/$prefKey'),
      body: {prefKey: pref.toFormData},
    );
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
    source: pick('source').letOrThrow(
      (pick) =>
          GameSource.nameMap[pick.asStringOrThrow()] ?? GameSource.unknown,
    ),
    opponent: pick('opponent').asLightUserOrThrow(),
    opponentRating: pick('opponent', 'rating').asIntOrNull(),
    opponentAiLevel: pick('opponent', 'aiLevel').asIntOrNull(),
    secondsLeft: pick('secondsLeft').asIntOrNull(),
    isMyTurn: pick('isMyTurn').asBoolOrThrow(),
  );
}
