import 'package:lichess_mobile/src/binding/binding_play.dart';
import 'package:lichess_mobile/src/bootstrap.dart';

Future<void> main(List<String> args) {
  return bootstrapApp(PlayLichessBinding.ensureInitialized, args: args);
}
