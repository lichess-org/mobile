import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_context.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
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

/// The external engine the user chose for [context], while they have it and it plays the variant.
///
/// Null in a context that names its own engine.
final chosenExternalEngineProvider = Provider.autoDispose
    .family<ExternalEngine?, EvaluationContext>((ref, context) {
      if (context.enginePref != null) return null;
      final id = ref.watch(
        engineEvaluationPreferencesProvider.select((prefs) => prefs.externalEngineId),
      );
      if (id == null) return null;
      final engines = ref.watch(externalEnginesProvider).value;
      return engines == null ? null : findExternalEngine(engines, id, context.variant);
    }, name: 'ChosenExternalEngineProvider');

/// The engine registered as [id] among [engines], if it plays [variant].
ExternalEngine? findExternalEngine(Iterable<ExternalEngine> engines, String id, Variant variant) =>
    engines.firstWhereOrNull((engine) => engine.id == id && engine.supports(variant));

class const ExternalEngineRepository(final LichessClient client) {
  Future<IList<ExternalEngine>> getExternalEngines() {
    return client.readJsonList(Uri(path: '/api/external-engine'), mapper: ExternalEngine.fromJson);
  }
}
