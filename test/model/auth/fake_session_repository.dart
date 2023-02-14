import 'package:lichess_mobile/src/model/auth/user_session.dart';
import 'package:lichess_mobile/src/model/auth/session_repository.dart';

class FakeSessionRepository implements SessionRepository {
  FakeSessionRepository([UserSession? initial]) : _session = initial;

  UserSession? _session;

  @override
  Future<UserSession?> read() async {
    await Future<void>.delayed(const Duration(milliseconds: 2));
    return _session;
  }

  @override
  Future<void> write(UserSession session) async {
    await Future<void>.delayed(const Duration(milliseconds: 2));
    _session = session;
  }

  @override
  Future<void> delete() async {
    await Future<void>.delayed(const Duration(milliseconds: 2));
    _session = null;
  }
}
