import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/utils/in_memory_store.dart';
import 'package:lichess_mobile/src/features/auth/ui/auth_widget.dart';
import 'package:lichess_mobile/src/features/auth/data/auth_repository.dart';
import 'package:lichess_mobile/src/features/settings/ui/theme_mode_notifier.dart';
import 'package:lichess_mobile/src/features/user/model/user.dart';

void main() {
  testWidgets('auth widget', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository(null)),
          selectedBrigthnessProvider.overrideWithValue(Brightness.dark),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Consumer(builder: (context, ref, _) {
            return Scaffold(
              appBar: AppBar(
                actions: const [
                  AuthWidget(),
                ],
              ),
            );
          }),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();

    expect(find.text('Sign in'), findsOneWidget);

    await tester.tap(find.text('Sign in'));

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}

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
  TaskEither<IOError, void> signInTask() {
    return TaskEither(() async {
      await Future.delayed(const Duration(milliseconds: 5));
      _authState.value = _fakeUser;
      return Either.right(null);
    });
  }

  @override
  TaskEither<IOError, void> signOutTask() {
    return TaskEither(() async {
      await Future.delayed(const Duration(milliseconds: 5));
      _authState.value = null;
      return Either.right(null);
    });
  }

  @override
  TaskEither<IOError, User> getAccountTask() {
    return TaskEither.right(_fakeUser);
  }

  @override
  void dispose() {}
}

final _fakeUser = User(
  id: 'test',
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
    rating: 1500, ratingDeviation: 0, progression: 0, numberOfGames: 0);
