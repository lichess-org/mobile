import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/features/game/model/game.dart';
import '../model/user.dart';

class UserRepository {
  const UserRepository({required this.apiClient, required Logger logger})
      : _log = logger;

  final ApiClient apiClient;
  final Logger _log;

  TaskEither<IOError, User> getUserTask(String username) {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/user/$username'))
        .flatMap((response) {
      return TaskEither.fromEither(
          readJsonObject(response.body, mapper: User.fromJson, logger: _log));
    });
  }

  TaskEither<IOError, List<UserStatus>> getUsersStatusTask(List<String> ids) {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/users/status?ids=${ids.join(',')}'))
        .flatMap((response) => TaskEither.fromEither(readJsonListOfObjects(
            response.body,
            mapper: UserStatus.fromJson,
            logger: _log)));
  }

  TaskEither<IOError, List<ArchivedGame>> getRecentGames(String username) {
    return apiClient.get(
      Uri.parse('$kLichessHost/api/games/user/$username?max=10'),
      headers: {'Accept': 'application/x-ndjson'},
    ).flatMap((r) => TaskEither.fromEither(Either.tryCatch(() {
          final lines = r.body.split('\n');
          return lines.where((e) => e.isNotEmpty && e != '\n').map((e) {
            final json = jsonDecode(e) as Map<String, dynamic>;
            return ArchivedGame.fromJson(json);
          }).toList(growable: false);
        }, (error, stackTrace) {
          _log.severe('Could not read json object as ArchivedGame: $error');
          return DataFormatError(stackTrace);
        })));
  }

  void dispose() {
    apiClient.close();
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo =
      UserRepository(apiClient: apiClient, logger: Logger('UserRepository'));
  ref.onDispose(() => repo.dispose());
  return repo;
});
