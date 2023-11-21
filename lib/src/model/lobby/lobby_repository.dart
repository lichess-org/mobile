import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/crashlytics.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/utils/json.dart';

import 'game_seek.dart';
import 'correspondence_seek.dart';

part 'lobby_repository.g.dart';

@Riverpod(keepAlive: true)
LobbyRepository lobbyRepository(LobbyRepositoryRef ref) {
  // lobbyRepository gets its own httpClient because it needs to be able to
  // close it independently from the rest of the app.
  final httpClient = http.Client();
  final crashlytics = ref.watch(crashlyticsProvider);
  final logger = Logger('LobbyAuthClient');
  final authClient = AuthClient(
    httpClient,
    ref,
    logger,
    crashlytics,
  );
  ref.onDispose(() {
    httpClient.close();
  });
  return LobbyRepository(
    authClient: authClient,
    logger: Logger('LobbyRepository'),
  );
}

@riverpod
Future<IList<CorrespondenceSeek>> correspondenceSeeks(
  CorrespondenceSeeksRef ref,
) {
  final lobbyRepository = ref.watch(lobbyRepositoryProvider);
  return Result.release(lobbyRepository.getCorrespondenceSeeks());
}

class LobbyRepository {
  const LobbyRepository({
    required this.authClient,
    required Logger logger,
  }) : _log = logger;

  final AuthClient authClient;
  final Logger _log;

  FutureResult<void> createSeek(GameSeek seek, {required String sri}) {
    return authClient.post(
      Uri.parse(
        '$kLichessHost/api/board/seek?sri=$sri',
      ),
      body: seek.requestBody,
    );
  }

  FutureResult<IList<CorrespondenceSeek>> getCorrespondenceSeeks() {
    return authClient.get(
      Uri.parse('$kLichessHost/lobby/seeks'),
      headers: {'Accept': 'application/json'},
    ).flatMap(
      (response) => readJsonListOfObjectsFromResponse(
        response,
        mapper: _correspondenceSeekFromJson,
        logger: _log,
      ),
    );
  }
}

CorrespondenceSeek _correspondenceSeekFromJson(Map<String, dynamic> json) {
  return _correspondenceSeekFromPick(pick(json).required());
}

CorrespondenceSeek _correspondenceSeekFromPick(RequiredPick pick) {
  return CorrespondenceSeek(
    id: pick('id').asGameIdOrThrow(),
    username: pick('username').asStringOrThrow(),
    title: pick('title').asStringOrNull(),
    rating: pick('rating').asIntOrThrow(),
    variant: pick('variant').asVariantOrNull(),
    perf: pick('perf').asPerfOrThrow(),
    rated: pick('mode').asIntOrThrow() == 1,
    days: pick('days').asIntOrNull(),
    side: pick('color').asSideOrNull(),
    provisional: pick('provisional').asBoolOrNull(),
  );
}
