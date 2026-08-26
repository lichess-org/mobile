import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/model/engine/weights_service.dart';
import 'package:lichess_mobile/src/view/offline_computer/opponent_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../../binding.dart';
import '../../model/engine/fake_weights_service.dart';
import '../../test_provider_scope.dart';

/// A screen whose only job is to open the picker and remember what it returned.
class _PickerHost extends StatefulWidget {
  const _PickerHost({required this.selected, required this.variant});

  final OpponentSpec selected;
  final Variant variant;

  @override
  State<_PickerHost> createState() => _PickerHostState();
}

class _PickerHostState extends State<_PickerHost> {
  OpponentSpec? picked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            final result = await showOpponentPicker(
              context,
              selected: widget.selected,
              variant: widget.variant,
            );
            if (mounted) setState(() => picked = result);
          },
          child: const Text('open'),
        ),
      ),
    );
  }
}

void main() {
  TestLichessBinding.ensureInitialized();

  Future<_PickerHostState> openPicker(
    WidgetTester tester, {
    OpponentSpec selected = const StockfishOpponentSpec(StockfishLevel.level4),
    Variant variant = Variant.standard,
    FakeMaiaWeightsService? weights,
  }) async {
    final app = await makeTestProviderScopeApp(
      tester,
      home: _PickerHost(selected: selected, variant: variant),
      overrides: {
        if (weights != null)
          maiaWeightsServiceProvider: maiaWeightsServiceProvider.overrideWithValue(weights),
      },
    );
    await tester.pumpWidget(app);
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return tester.state<_PickerHostState>(find.byType(_PickerHost));
  }

  group('Opponent picker', () {
    testWidgets('shows what each engine is', (tester) async {
      await openPicker(tester);

      expect(find.textContaining('trusted by grandmasters'), findsOneWidget);

      await tester.tap(find.text('Maia'));
      await tester.pumpAndSettle();

      expect(find.textContaining('human-like neural network'), findsOneWidget);
      expect(find.textContaining('maiachess.com'), findsOneWidget);
    });

    testWidgets('offers Maia only for the variants it can play', (tester) async {
      await openPicker(tester, variant: Variant.atomic);

      // The networks were trained on standard human games, so there is nothing to choose between.
      expect(find.byType(SegmentedButton<OpponentEngine>), findsNothing);
      expect(find.textContaining('trusted by grandmasters'), findsOneWidget);
    });

    testWidgets('returns the Maia rating that was chosen', (tester) async {
      final weights = FakeMaiaWeightsService(available: MaiaRating.values.toSet());
      final host = await openPicker(tester, weights: weights);

      await tester.tap(find.text('Maia'));
      await tester.pumpAndSettle();
      expect(find.textContaining('1500'), findsWidgets);

      await tester.drag(find.byType(Slider), const Offset(-500, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(host.picked, const MaiaOpponentSpec(MaiaRating.maia1100));
    });

    testWidgets('downloads the network of a rating the device does not have', (tester) async {
      final weights = FakeMaiaWeightsService();
      final host = await openPicker(tester, weights: weights);

      await tester.tap(find.text('Maia'));
      await tester.pumpAndSettle();

      // Only the bundled network is there, so the rest have to say what they will cost.
      await tester.drag(find.byType(Slider), const Offset(500, 0));
      await tester.pumpAndSettle();

      expect(weights.downloads, [MaiaRating.maia1900]);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(host.picked, const MaiaOpponentSpec(MaiaRating.maia1900));
    });

    testWidgets('a download that fails leaves the bundled network selected', (tester) async {
      final weights = FakeMaiaWeightsService(downloadSucceeds: false);
      final host = await openPicker(tester, weights: weights);

      await tester.tap(find.text('Maia'));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Slider), const Offset(500, 0));
      await tester.pumpAndSettle();

      expect(find.textContaining('could not be downloaded'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Never a game that cannot start: the network that ships with the app plays instead.
      expect(host.picked, const MaiaOpponentSpec(MaiaRating.defaultRating));
    });

    testWidgets('returns the Stockfish level that was chosen', (tester) async {
      final host = await openPicker(tester);

      await tester.drag(find.byType(Slider), const Offset(-500, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(host.picked, const StockfishOpponentSpec(StockfishLevel.level1));
    });
  });
}
