import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/http_log/http_log_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_log_providers.g.dart';

@riverpod
Future<IList<HttpLog>> httpLogs(Ref ref, {int page = 0, int limit = 100}) async {
  final httpLogStorage = await ref.read(httpLogStorageProvider.future);
  return httpLogStorage.page(offset: page * limit, limit: limit);
}
