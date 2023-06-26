import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/constants.dart';
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
}

@Riverpod(keepAlive: true)
TvRepository tvRepository(TvRepositoryRef ref) {
  final apiClient = ref.watch(authClientProvider);
  return TvRepository(Logger('TvRepository'), apiClient: apiClient);
}
