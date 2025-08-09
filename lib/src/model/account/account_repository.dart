import 'package:deep_pick/deep_pick.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/aggregator.dart';
import 'package:lichess_mobile/src/network/http.dart';

/// A provider that fetches the current user's account information.
final accountProvider = FutureProvider.autoDispose<User?>((Ref ref) {
  final session = ref.watch(authSessionProvider);
  if (session == null) return null;
  final aggregator = ref.read(aggregatorProvider);
  return aggregator.readJson(
    Uri(path: '/api/account', queryParameters: {'playban': '1'}),
    atomicMapper: User.fromServerJson,
    aggregatedMapper: (json) => User.fromServerJson(json as Map<String, dynamic>),
  );
}, name: 'AccountProvider');

/// A provider that fetches the current user's kid mode status.
final kidModeProvider = FutureProvider.autoDispose<bool>((ref) {
  return ref.watch(accountProvider.selectAsync((user) => user?.kid ?? false));
}, name: 'KidModeProvider');

class AccountRepository {
  AccountRepository(this.client);

  final LichessClient client;

  Future<void> saveProfile(Map<String, String> profile) async {
    final uri = Uri(path: '/account/profile');
    final response = await client.post(uri, headers: {'Accept': 'application/json'}, body: profile);

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to post save profile: ${response.statusCode}', uri);
    }
  }

  Future<AccountPrefState> getPreferences() {
    return client.readJson(
      Uri(path: '/api/account/preferences'),
      mapper: (Map<String, dynamic> json) {
        return _accountPreferencesFromPick(pick(json, 'prefs').required());
      },
    );
  }

  Future<void> setPreference<T>(String prefKey, AccountPref<T> pref) async {
    final uri = Uri(path: '/api/account/preferences/$prefKey');

    final response = await client.post(uri, body: {prefKey: pref.toFormData});

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to set preference: ${response.statusCode}', uri);
    }
  }

  /// Bookmark the game for the given `id` if `bookmark` is true else unbookmark it
  Future<void> bookmark(GameId id, {required bool bookmark}) async {
    final uri = Uri(path: '/bookmark/$id', queryParameters: {'v': bookmark ? '1' : '0'});
    final response = await client.post(uri);
    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to bookmark game: ${response.statusCode}', uri);
    }
  }
}

AccountPrefState _accountPreferencesFromPick(RequiredPick pick) {
  return (
    zenMode: Zen.fromInt(pick('zen').asIntOrThrow()),
    pieceNotation: PieceNotation.fromInt(pick('pieceNotation').asIntOrThrow()),
    showRatings: ShowRatings.fromInt(pick('ratings').asIntOrThrow()),
    premove: BooleanPref(pick('premove').asBoolOrThrow()),
    autoQueen: AutoQueen.fromInt(pick('autoQueen').asIntOrThrow()),
    autoThreefold: AutoThreefold.fromInt(pick('autoThreefold').asIntOrThrow()),
    takeback: Takeback.fromInt(pick('takeback').asIntOrThrow()),
    moretime: Moretime.fromInt(pick('moretime').asIntOrThrow()),
    clockSound: BooleanPref(pick('clockSound').asBoolOrThrow()),
    confirmResign: BooleanPref.fromInt(pick('confirmResign').asIntOrThrow()),
    submitMove: SubmitMove.fromInt(pick('submitMove').asIntOrThrow()),
    follow: BooleanPref(pick('follow').asBoolOrThrow()),
    challenge: Challenge.fromInt(pick('challenge').asIntOrThrow()),
    message: Message.fromInt(pick('message').asIntOrThrow()),
  );
}
