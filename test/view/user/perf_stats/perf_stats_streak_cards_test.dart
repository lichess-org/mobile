import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_common.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_streak_cards.dart';
import 'package:material_ui/material_ui.dart';

import '../../../test_helpers.dart';
import '../../../test_provider_scope.dart';

void main() {
  final startGame = UserPerfGame(
    finishedAt: DateTime.utc(2023, 1, 12),
    gameId: const GameId('ABcDeFgH'),
  );
  final endGame = UserPerfGame(
    finishedAt: DateTime.utc(2023, 1, 20),
    gameId: const GameId('ABcDeFgH'),
  );

  for (final count in [0, 1, 9, 16, 43]) {
    testWidgets('shows $count games with capped dots and readable dates', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        surfaceSize: const Size(320, 844),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: ListView(
            children: [
              PerfStatsStreakCard(
                title: 'Winning streak',
                color: Colors.green,
                currentStreak: UserStreak.gameStreak(
                  gamesPlayed: count,
                  isValueEmpty: count == 0,
                  startGame: startGame,
                  endGame: endGame,
                ),
                maxStreak: null,
              ),
            ],
          ),
        ),
      );
      await tester.pumpWidget(app);

      final dots = find.byWidgetPredicate(
        (widget) =>
            widget is DecoratedBox &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).shape == BoxShape.circle,
      );
      expect(dots, findsNWidgets(count.clamp(0, 16)));
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.byType(Icon), findsNothing);
      if (count == 0) {
        expect(find.text('-'), findsNWidgets(2));
        for (final text in tester.widgetList<Text>(find.text('-'))) {
          expect(text.semanticsLabel, 'None');
        }
        expect(find.textContaining('2023'), findsNothing);
      } else {
        expect(find.text(count == 1 ? '1 game' : '$count games'), findsOneWidget);
        final date = find.text(
          formatPerfStatsStreakDates(
            UserStreak.gameStreak(
              gamesPlayed: count,
              isValueEmpty: false,
              startGame: startGame,
              endGame: endGame,
            ),
          )!,
        );
        expect(date, findsOneWidget);
        expect(tester.widget<Text>(date).style?.fontSize, 14);
        expect(
          find.ancestor(of: dots.first, matching: find.byType(ExcludeSemantics)),
          findsOneWidget,
        );
        if (count > 16) expect(find.text('+27 games'), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    }, variant: kPlatformVariant);
  }

  test('streak dates show a single day once and keep both years for a longer range', () {
    final previousLocale = Intl.defaultLocale;
    Intl.defaultLocale = 'en';
    addTearDown(() => Intl.defaultLocale = previousLocale);
    final sameDayGame = UserPerfGame(
      finishedAt: DateTime.utc(2023, 1, 12, 23),
      gameId: const GameId('ABcDeFgH'),
    );
    final nextYearGame = UserPerfGame(
      finishedAt: DateTime.utc(2024, 1, 20),
      gameId: const GameId('ABcDeFgH'),
    );
    for (final (end, expected) in [
      (sameDayGame, 'Jan 12, 2023'),
      (endGame, 'Jan 12 – Jan 20, 2023'),
      (nextYearGame, 'Jan 12, 2023 – Jan 20, 2024'),
    ]) {
      expect(
        formatPerfStatsStreakDates(
          UserStreak.gameStreak(
            gamesPlayed: 2,
            isValueEmpty: false,
            startGame: startGame,
            endGame: end,
          ),
        ),
        expected,
      );
    }
    expect(formatPerfStatsStreakDates(null), isNull);
  });
}
