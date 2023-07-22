import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/crashlytics.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';

import 'game_seek.dart';

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
  return LobbyRepository(authClient: authClient);
}

class LobbyRepository {
  const LobbyRepository({
    required this.authClient,
  });

  final AuthClient authClient;

  FutureResult<void> createSeek(GameSeek seek, {required String sri}) {
    return authClient.post(
      Uri.parse(
        '$kLichessHost/api/board/seek?sri=$sri',
      ),
      body: seek.requestBody,
    );
  }
}
