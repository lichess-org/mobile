import 'package:async/async.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/utils/in_memory_store.dart';
import 'package:lichess_mobile/src/features/user/model/user.dart';
import 'package:lichess_mobile/src/features/auth/data/auth_repository.dart';

/// A fake AuthRepository
///
/// Optionnall pass a [User] to have it initialized with an already logged in user
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository(User? loggedInUser)
      : _authState = InMemoryStore<User?>(loggedInUser);

  final InMemoryStore<User?> _authState;

  @override
  Stream<User?> authStateChanges() => _authState.stream;

  @override
  User? get currentAccount => _authState.value;

  @override
  bool get isAuthenticated => _authState.value != null;

  @override
  Future<void> init() async {
    return;
  }

  @override
  FutureResult<void> signIn() async {
    await Future<void>.delayed(const Duration(milliseconds: 5));
    _authState.value = fakeUser;
    return Result.value(null);
  }

  @override
  FutureResult<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 5));
    _authState.value = null;
    return Result.value(null);
  }

  @override
  FutureResult<User> getAccount() async {
    await Future<void>.delayed(const Duration(milliseconds: 5));
    return Result.value(fakeUser);
  }

  @override
  void dispose() {}
}

final fakeUser = User(
  id: const UserId('test'),
  username: 'test',
  createdAt: DateTime.now(),
  seenAt: DateTime.now(),
  perfs: {
    Perf.ultraBullet: _fakePerf,
    Perf.bullet: _fakePerf,
    Perf.blitz: _fakePerf,
    Perf.rapid: _fakePerf,
    Perf.classical: _fakePerf,
    Perf.correspondence: _fakePerf,
    Perf.chess960: _fakePerf,
    Perf.antichess: _fakePerf,
    Perf.kingOfTheHill: _fakePerf,
    Perf.threeCheck: _fakePerf,
    Perf.atomic: _fakePerf,
    Perf.horde: _fakePerf,
    Perf.racingKings: _fakePerf,
    Perf.crazyhouse: _fakePerf,
    Perf.puzzle: _fakePerf,
    Perf.storm: _fakePerf,
  },
);

const _fakePerf = UserPerf(
  rating: 1500,
  ratingDeviation: 0,
  progression: 0,
  numberOfGames: 0,
);
