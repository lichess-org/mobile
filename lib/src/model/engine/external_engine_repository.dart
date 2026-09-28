import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/external_engine.dart';
import 'package:lichess_mobile/src/network/http.dart';

/// A provider for [ExternalEngineRepository].
final externalEngineRepositoryProvider = Provider<ExternalEngineRepository>((ref) {
  return ExternalEngineRepository(ref.watch(lichessClientProvider));
}, name: 'ExternalEngineRepositoryProvider');

/// The external engines the current user registered, or none when logged out.
///
/// Not retried: an evaluator waiting on a failed fetch should fall back at once.
final externalEnginesProvider = FutureProvider.autoDispose<IList<ExternalEngine>>(
  (ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    if (!isLoggedIn) return const IListConst([]);
    return ref.read(externalEngineRepositoryProvider).getExternalEngines();
  },
  name: 'ExternalEnginesProvider',
  retry: (_, _) => null,
);

/// The engine registered as [id] among [engines], if it plays [variant].
ExternalEngine? findExternalEngine(Iterable<ExternalEngine> engines, String id, Variant variant) =>
    engines.firstWhereOrNull((engine) => engine.id == id && engine.supports(variant));

class const ExternalEngineRepository(final LichessClient client) {
  Future<IList<ExternalEngine>> getExternalEngines() {
    return client.readJsonList(Uri(path: '/api/external-engine'), mapper: ExternalEngine.fromJson);
  }
}
