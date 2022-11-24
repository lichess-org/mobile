import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/http.dart';
import 'package:lichess_mobile/src/constants.dart';

class TvRepository {
  const TvRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final ApiClient apiClient;
  final Logger _log;

  Stream<Map<String, dynamic>> tvFeed() async* {
    final resp = await apiClient
        .send(http.Request('GET', Uri.parse('$kLichessHost/api/tv/feed')));
    _log.fine('Start streaming TV.');
    yield* resp.stream
        .toStringStream()
        .where((event) => event.isNotEmpty && event != '\n')
        .map((event) => jsonDecode(event));
  }

  void dispose() {
    apiClient.close();
  }
}

final tvRepositoryProvider = Provider<TvRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo = TvRepository(Logger('TvRepository'), apiClient: apiClient);
  ref.onDispose(() => repo.dispose());
  return repo;
});
