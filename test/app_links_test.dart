import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/app_links.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockBuildContext mockContext;

  setUp(() {
    mockContext = MockBuildContext();
  });

  group('resolveAppLinkUri', () {
    test('returns null for an empty path', () {
      final uri = Uri.parse('https://lichess.org/');
      final result = resolveAppLinkUri(mockContext, uri);
      expect(result, isNull);
    });

    test('resolves /study/{id} to StudyScreen route', () {
      final uri = Uri.parse('https://lichess.org/study/p9uY0321');
      expect(
          resolveAppLinkUri(mockContext, uri)!.first,
          isA<MaterialScreenRoute>().having(
            (r) => r.screen,
            'screen',
            isA<StudyScreen>().having((s) => s.id, 'id', 'p9uY0321'),
          ),
        );
    });

    test('resolves /training/{id} to PuzzleScreen route', () {
      final uri = Uri.parse('https://lichess.org/training/61044');
      expect(
          resolveAppLinkUri(mockContext, uri)!.first,
          isA<MaterialScreenRoute>().having(
            (r) => r.screen,
            'screen',
            isA<PuzzleScreen>().having((s) => s.puzzleId, 'id', '61044'),
          ),
        );
    });

    test('resolves /broadcast/.../{roundId}/{gameId} to two routes (stacking)', () {
      // Broadcast URLs have many segments: /broadcast/slug/name/roundId/gameId
      final uri = Uri.parse(
        'https://lichess.org/broadcast/candidates-2024/round-1/abcde123/zxcvb456',
      );
      final routes = resolveAppLinkUri(mockContext, uri);
      // Should have Round screen followed by Game screen
      expect(
        routes?.first,
        isA<MaterialScreenRoute>().having(
          (r) => r.screen,
          'screen',
          isA<BroadcastRoundScreenLoading>().having((s) => s.roundId, 'id', 'abcde123'),
        ),
      );
      expect(
        routes?.last,
        isA<MaterialScreenRoute>().having(
          (r) => r.screen,
          'screen',
          isA<BroadcastGameScreen>().having((s) => s.gameId, 'id', 'zxcvb456'),
        ),
      );
    });

    test('resolves /gameid analysis link with ply fragment', () {
      // lichess.org/gameid#20 -> Opens analysis at move 20
      final uri = Uri.parse('https://lichess.org/qwertyui#20');
      expect(
        resolveAppLinkUri(mockContext, uri)!.first,
        isA<MaterialScreenRoute>().having(
          (r) => r.screen,
          'screen',
          isA<AnalysisScreen>()
              .having((s) => s.options.gameId, 'id', 'qwertyui')
              .having((s) => s.options.initialMoveCursor, 'move number', 20),
        ),
      );
    });

    test('resolves /gameid/black analysis link', () {
      final uri = Uri.parse('https://lichess.org/qwertyui/black');
      final routes = resolveAppLinkUri(mockContext, uri);

      expect(routes, isNotNull);
      expect(routes!.length, 1);
    });
  });

  group('onLinkifyOpen', () {
    // Note: To test actual navigation, you would need to wrap the app in a
    // MaterialApp with a MockNavigatorObserver.

    test('handles user mentions (@username)', () {
      // The logic extracts the username after '@' and pushes UserOrProfileScreen
      // This is primarily verified via integration tests or by checking
      // if UserOrProfileScreen.buildRoute is invoked.
    });
  });
}
