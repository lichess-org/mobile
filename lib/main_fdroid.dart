import 'package:lichess_mobile/src/binding/binding_fdroid.dart';
import 'package:lichess_mobile/src/bootstrap.dart';

void main() {
  bootstrapApp(FdroidLichessBinding.ensureInitialized);
}
