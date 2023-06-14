import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';

import 'game_seek.dart';

part 'lobby_repository.g.dart';

@Riverpod(keepAlive: true)
LobbyRepository lobbyRepository(LobbyRepositoryRef ref) {
  final authClient = ref.watch(authClientProvider);
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
