import 'package:async/async.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  FutureResult<AuthorizationTokenResponse> signIn() async {
    await Future<void>.delayed(const Duration(milliseconds: 5));
    return Result.value(
      AuthorizationTokenResponse(
        'testToken',
        null,
        null,
        null,
        null,
        null,
        null,
        null,
      ),
    );
  }

  @override
  FutureResult<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 5));
    return Result.value(null);
  }
}

final fakeUser = User(
  id: const UserId('test'),
  username: 'test',
  createdAt: DateTime.now(),
  seenAt: DateTime.now(),
  perfs: IMap(const {
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
  }),
);

const _fakePerf = UserPerf(
  rating: 1500,
  ratingDeviation: 0,
  progression: 0,
  numberOfGames: 0,
);
