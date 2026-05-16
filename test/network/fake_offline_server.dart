import 'package:lichess_mobile/src/network/server_status.dart';

class FakeServerOffline extends ServerStatusNotifier {
  @override
  bool build() => false;
}
