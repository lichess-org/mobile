import 'package:lichess_mobile/src/binding/binding_play.dart';
import 'package:lichess_mobile/src/bootstrap.dart';

Future<void> main() {
  return bootstrapApp(PlayLichessBinding.ensureInitialized);
}
