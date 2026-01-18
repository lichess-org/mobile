import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/node.dart';

void main() {
  group('ServerAnalysisService.mergeOngoingAnalysis', () {
    test('merges analysis using UCI instead of id field', () {
      // Create a simple game tree: e2e4
      final root = Root(position: Chess.initial);
      final e4Move = Move.parse('e2e4')!;
      final e4Position = root.position.playUnchecked(e4Move);
      final e4Branch = Branch(
        sanMove: SanMove('e4', e4Move),
        position: e4Position,
      );
      root.addChild(e4Branch);

      // Server analysis data - note: no 'id' field, only 'uci'
      final serverNode = {
        'eval': {'cp': 20},
        'children': [
          {
            'uci': 'e2e4',
            'san': 'e4',
            'eval': {'cp': 25},
            'children': [
              {
                'uci': 'e7e5',
                'san': 'e5',
                'eval': {'cp': 30},
                'children': <Map<String, dynamic>>[],
              },
            ],
          },
        ],
      };

      // This should work without the 'id' field
      ServerAnalysisService.mergeOngoingAnalysis(root, serverNode);

      // Verify the tree was merged correctly
      expect(root.children.length, 1);
      expect(root.children.first.sanMove.san, 'e4');
      expect(root.children.first.children.length, 1);
      expect(root.children.first.children.first.sanMove.san, 'e5');
    });

    test('adds new variation from server analysis using UCI', () {
      // Create a game tree with just e2e4
      final root = Root(position: Chess.initial);
      final e4Move = Move.parse('e2e4')!;
      final e4Position = root.position.playUnchecked(e4Move);
      final e4Branch = Branch(
        sanMove: SanMove('e4', e4Move),
        position: e4Position,
      );
      root.addChild(e4Branch);

      // Server sends a new variation (d2d4) - no 'id' field
      final serverNode = {
        'children': [
          {
            'uci': 'd2d4',
            'san': 'd4',
            'eval': {'cp': 15},
            'children': <Map<String, dynamic>>[],
          },
        ],
      };

      ServerAnalysisService.mergeOngoingAnalysis(root, serverNode);

      // Should have added d4 as a new variation
      expect(root.children.length, 2);
      final variations = root.children.map((c) => c.sanMove.san).toList();
      expect(variations, containsAll(['e4', 'd4']));
    });

    test('merges evaluation into existing node', () {
      final root = Root(position: Chess.initial);
      final e4Move = Move.parse('e2e4')!;
      final e4Position = root.position.playUnchecked(e4Move);
      final e4Branch = Branch(
        sanMove: SanMove('e4', e4Move),
        position: e4Position,
      );
      root.addChild(e4Branch);

      // Server sends eval for e4 - no 'id' field
      final serverNode = {
        'children': [
          {
            'uci': 'e2e4',
            'san': 'e4',
            'eval': {'cp': 42},
            'comments': [
              {'text': 'Best move!'},
            ],
            'children': <Map<String, dynamic>>[],
          },
        ],
      };

      ServerAnalysisService.mergeOngoingAnalysis(root, serverNode);

      // Verify eval was merged
      expect(root.children.length, 1);
      expect(root.children.first.lichessAnalysisComments?.length, 1);
      expect(root.children.first.lichessAnalysisComments?.first.text, 'Best move!');
    });

    test('recursively merges nested children in new variations', () {
      final root = Root(position: Chess.initial);

      // Server sends a new variation with nested children - no 'id' fields
      final serverNode = {
        'children': [
          {
            'uci': 'e2e4',
            'san': 'e4',
            'eval': {'cp': 20},
            'children': [
              {
                'uci': 'e7e5',
                'san': 'e5',
                'eval': {'cp': 25},
                'comments': [
                  {'text': 'Classic response'},
                ],
                'children': [
                  {
                    'uci': 'g1f3',
                    'san': 'Nf3',
                    'eval': {'cp': 30},
                    'children': <Map<String, dynamic>>[],
                  },
                ],
              },
            ],
          },
        ],
      };

      ServerAnalysisService.mergeOngoingAnalysis(root, serverNode);

      // Verify the entire tree was built
      expect(root.children.length, 1);
      expect(root.children.first.sanMove.san, 'e4');
      
      final e4 = root.children.first;
      expect(e4.children.length, 1);
      expect(e4.children.first.sanMove.san, 'e5');
      expect(e4.children.first.lichessAnalysisComments?.first.text, 'Classic response');
      
      final e5 = e4.children.first;
      expect(e5.children.length, 1);
      expect(e5.children.first.sanMove.san, 'Nf3');
    });
  });
}
