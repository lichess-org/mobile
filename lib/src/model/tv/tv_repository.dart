import 'dart:async';
import 'dart:convert';
import 'package:deep_pick/deep_pick.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:stream_transform/stream_transform.dart';
import './tv_event.dart';

part 'tv_repository.g.dart';

class TvRepository {
  const TvRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final AuthClient apiClient;
  final Logger _log;

  Stream<TvEvent> tvFeed() async* {
    final resp = await apiClient.stream(Uri.parse('$kLichessHost/api/tv/feed'));
    _log.fine('Start streaming TV.');
    yield* resp.stream
        .toStringStream()
        .where((event) => event.isNotEmpty && event != '\n')
        .map((event) => jsonDecode(event) as Map<String, dynamic>)
        .where((json) => json['t'] == 'featured' || json['t'] == 'fen')
        .map((json) => TvEvent.fromJson(json))
        .handleError((Object error) => _log.warning(error));
  }

  Stream<TvEvent> tvFeedChannel(TvChannel selectedChannel) async* {
    _log.fine('Start streaming TV selectedChannel: $selectedChannel');

    final sc = StreamController<TvChannel>()..add(selectedChannel);

    final str = sc.stream
        .asyncMap((variant) async {
          final topGamesDataResp = await apiClient.get(
            Uri.parse('$kLichessHost/api/tv/channels'),
          );

          final topGamesData =
              jsonDecode(topGamesDataResp.asValue?.value.body ?? "")
                  as Map<String, dynamic>;

          final gameId =
              pick(topGamesData, "$variant", "gameId").asStringOrThrow();

          return Uri.parse(
            '$kLichessHost/api/stream/game/$gameId',
          );
        })
        .asyncMap(
          (uri) => apiClient.stream(uri),
        )
        .switchMap(
          (r) => r.stream.toStringStream(),
        );

    yield* str
        .expand((event) => event.split('\n'))
        .where((event) => event.isNotEmpty && event != '\n')
        .map((event) => jsonDecode(event) as Map<String, dynamic>)
        .map((json) {
          final gameStatus = pick(json, 'status', 'name').asStringOrNull();
          final lm = pick(json, 'lm').asStringOrNull();

          if (gameStatus != null && gameStatus == 'started') {
            final orientation = pick(json, 'player').asStringOrNull();

            final Map<String, dynamic> whitePlayerData =
                pick(json, 'players', 'white').required().asMapOrThrow();

            final Map<String, dynamic> blackPlayerData =
                pick(json, 'players', 'black').required().asMapOrThrow();

            return <String, dynamic>{
              't': 'featured',
              'd': {
                ...json,
                'orientation': orientation,
                'players': [
                  {
                    ...whitePlayerData,
                    'color': 'white',
                  },
                  {
                    ...blackPlayerData,
                    'color': 'black',
                  },
                ],
              }
            };
          } else if (gameStatus != null &&
              gameStatus != 'started' &&
              lm == null) {
            // when game is finished in the current `gameId` fetch the game ids
            // again by adding event in the stream controller
            Future.delayed(
              const Duration(seconds: 4),
              () => sc.add(selectedChannel),
            );

            return json;
          } else if (lm != null) {
            return <String, dynamic>{'t': 'fen', 'd': json};
          } else {
            return json;
          }
        })
        .where((json) {
          return json['t'] == 'featured' || json['t'] == 'fen';
        })
        .map((json) => TvEvent.fromJson(json))
        .handleError((Object error) {
          _log.warning(error);
        });
  }

  void dispose() {
    apiClient.close();
  }
}

@Riverpod(keepAlive: true)
TvRepository tvRepository(TvRepositoryRef ref) {
  final apiClient = ref.watch(authClientProvider);
  final repo = TvRepository(Logger('TvRepository'), apiClient: apiClient);
  ref.onDispose(() => repo.dispose());
  return repo;
}
