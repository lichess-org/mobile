import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'tv_repository.dart';

part 'tv_repository_providers.g.dart';

@Riverpod(keepAlive: true)
TvRepository tvRepository(TvRepositoryRef ref) {
  final apiClient = ref.watch(authClientProvider);
  return TvRepository(logger: Logger('TvRepository'), apiClient: apiClient);
}

@riverpod
Future<TvChannels> tvChannels(TvChannelsRef ref) async {
  final repo = ref.watch(tvRepositoryProvider);
  final result = await repo.getTvChannels();
  return result.asFuture;
}
