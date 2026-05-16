import 'package:lichess_mobile/src/network/server_status.dart';

class FakeServerOnline extends ServerStatusNotifier {
  @override
  bool build() => true;
}
