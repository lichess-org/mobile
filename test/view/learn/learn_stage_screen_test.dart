import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/l10n/l10n_en.dart';
import 'package:lichess_mobile/src/model/learn/learn_progress.dart';
import 'package:lichess_mobile/src/model/learn/learn_stage_controller.dart';
import 'package:lichess_mobile/src/model/learn/learn_stages.dart';
import 'package:lichess_mobile/src/view/learn/learn_screen.dart';
import 'package:lichess_mobile/src/view/learn/learn_stage_screen.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final l10n = AppLocalizationsEn();

void main() {
  testWidgets('shows the intro, then completes a level and moves to the next one', (tester) async {
    final rook = learnStageByKey('rook')!;
    final app = await makeTestProviderScopeApp(tester, home: LearnStageScreen(stage: rook));
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text(l10n.learnRookIntro), findsOneWidget);
    await tester.tap(find.text(l10n.learnLetsGo));
    await tester.pump();

    expect(find.text(l10n.learnRookGoal), findsOneWidget);
    await playMove(tester, 'e2', 'e7');

    expect(boardHasPiece(tester, Square.e7, Piece.whiteRook), isTrue);
    expect(find.text(l10n.learnAwesome), findsOneWidget);

    // The score is saved as soon as the level is completed.
    final container = ProviderScope.containerOf(tester.element(find.byType(LearnStageScreen)));
    await tester.pump();
    expect(container.read(learnProgressProvider).value!.levelScore(rook, 0), 550);

    await tester.pump(kLearnNextLevelDelay);
    await tester.pumpAndSettle();
    expect(find.text(l10n.learnGrabAllTheStars), findsOneWidget);
    expect(boardHasPiece(tester, Square.c7, Piece.whiteRook), isTrue);
  });

  testWidgets('the opponent plays its scripted move first', (tester) async {
    final enpassant = learnStageByKey('enpassant')!;
    final app = await makeTestProviderScopeApp(tester, home: LearnStageScreen(stage: enpassant));
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.learnLetsGo));
    await tester.pump();

    expect(boardHasPiece(tester, Square.d7, Piece.blackPawn), isTrue);
    await tester.pump(kLearnOpponentMoveDelay);
    await tester.pumpAndSettle();
    expect(boardHasPiece(tester, Square.d5, Piece.blackPawn), isTrue);

    await playMove(tester, 'c5', 'd6');
    await tester.pumpAndSettle();
    expect(boardHasPiece(tester, Square.d6, Piece.whitePawn), isTrue);
    expect(boardHasPiece(tester, Square.d5, Piece.blackPawn), isFalse);
    expect(find.text(l10n.learnAwesome), findsOneWidget);

    await tester.pump(kLearnNextLevelDelay);
    await tester.pumpAndSettle();
  });

  testWidgets('a failed level can be retried', (tester) async {
    final capture = learnStageByKey('capture')!;
    final app = await makeTestProviderScopeApp(tester, home: LearnStageScreen(stage: capture));
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.learnLetsGo));
    await tester.pump();

    // Go to the second level, where the queen can be lost.
    await tester.tap(find.text('2'));
    await tester.pump();
    await playMove(tester, 'f4', 'f7');
    expect(find.text(l10n.learnPuzzleFailed), findsOneWidget);

    await tester.pump(kLearnFailureFollowUpDelay);
    await tester.pumpAndSettle();
    expect(boardHasPiece(tester, Square.f7, Piece.blackRook), isTrue);

    await tester.tap(find.text(l10n.learnRetry));
    await tester.pumpAndSettle();
    expect(find.text(l10n.learnPuzzleFailed), findsNothing);
    expect(boardHasPiece(tester, Square.f4, Piece.whiteQueen), isTrue);
    expect(find.byType(Chessboard), findsOneWidget);
  });

  testWidgets('the menu lists every stage and opens one', (tester) async {
    final app = await makeTestProviderScopeApp(tester, home: const LearnScreen());
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text(l10n.learnProgressX('0%')), findsOneWidget);
    expect(find.text(l10n.learnTheRook), findsOneWidget);

    await tester.tap(find.text(l10n.learnTheRook));
    await tester.pumpAndSettle();
    expect(find.byType(LearnStageScreen), findsOneWidget);
    expect(find.text(l10n.learnRookIntro), findsOneWidget);

    // Leave the screen so that no timer is pending at the end of the test.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text(l10n.learnTheRook), findsOneWidget);
  });
}
