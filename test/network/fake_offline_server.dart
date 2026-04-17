import 'package:lichess_mobile/src/network/server_status.dart';

class FakeServerOffline extends ServerStatusNotifier {
  @override
  Future<bool> build() async {
    return false;
  }
}
