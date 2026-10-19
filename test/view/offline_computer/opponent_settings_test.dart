import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/service/weights_service.dart';
import 'package:lichess_mobile/src/view/offline_computer/opponent_settings.dart';
import 'package:lichess_mobile/src/widgets/platform_segmented_control.dart';
import 'package:material_ui/material_ui.dart';

import '../../binding.dart';
import '../../service/fake_weights_service.dart';
import '../../test_provider_scope.dart';

/// A form whose only job is to hold the opponent settings and remember what they reported.
class const _FormHost({required final OpponentSpec selected, required final Variant variant})
    extends StatefulWidget {
  @override
  State<_FormHost> createState() => _FormHostState();
}

class _FormHostState() extends State<_FormHost> {
  late OpponentSpec selected = widget.selected;
  late Variant variant = widget.variant;
  final reported = <OpponentSpec>[];
  final downloading = <bool>[];

  /// What a form does when a variant is picked: Maia cannot play every variant.
  void pickVariant(Variant newVariant, OpponentSpec opponent) => setState(() {
    variant = newVariant;
    selected = opponent;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          OpponentSettings(
            selected: selected,
            variant: variant,
            onChanged: (spec) => setState(() {
              selected = spec;
              reported.add(spec);
            }),
            onDownloadingChanged: downloading.add,
            children: const [ListTile(title: Text('Other setting'))],
          ),
        ],
      ),
    );
  }
}

void main() {
  TestLichessBinding.ensureInitialized();

  Future<_FormHostState> showSettings(
    WidgetTester tester, {
    OpponentSpec selected = const StockfishOpponentSpec(StockfishLevel.level4),
    Variant variant = Variant.standard,
    FakeMaiaWeightsService? weights,
  }) async {
    final app = await makeTestProviderScopeApp(
      tester,
      home: _FormHost(selected: selected, variant: variant),
      overrides: {
        if (weights != null)
          maiaWeightsServiceProvider: maiaWeightsServiceProvider.overrideWithValue(weights),
      },
    );
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    return tester.state<_FormHostState>(find.byType(_FormHost));
  }

  group('Opponent settings', () {
    testWidgets('shows what each engine is, above the other settings', (tester) async {
      await showSettings(tester);

      expect(find.textContaining('trusted by grandmasters'), findsOneWidget);
      expect(find.text('Other setting'), findsOneWidget);

      await tester.tap(find.text('Maia'));
      await tester.pumpAndSettle();

      expect(find.text('Maia is a human-like neural network chess engine.'), findsOneWidget);
    });

    testWidgets('offers Maia only for the variants it can play', (tester) async {
      await showSettings(tester, variant: Variant.atomic);

      // The networks were trained on standard human games, so there is nothing to choose between.
      expect(find.byType(PlatformSegmentedControl<OpponentEngine>), findsNothing);
      expect(find.textContaining('trusted by grandmasters'), findsOneWidget);
    });

    testWidgets('reports the Maia rating that was chosen', (tester) async {
      final weights = FakeMaiaWeightsService(available: MaiaRating.values.toSet());
      final host = await showSettings(tester, weights: weights);

      await tester.tap(find.text('Maia'));
      await tester.pumpAndSettle();
      expect(host.selected, const MaiaOpponentSpec(MaiaRating.defaultRating));

      await tester.drag(find.byType(Slider), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(host.selected, const MaiaOpponentSpec(MaiaRating.maia1100));
      expect(host.downloading, isEmpty);
    });

    testWidgets('downloads the network of a rating the device does not have', (tester) async {
      final weights = FakeMaiaWeightsService();
      final host = await showSettings(tester, weights: weights);

      await tester.tap(find.text('Maia'));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Slider), const Offset(500, 0));
      await tester.pumpAndSettle();

      expect(weights.downloads, [MaiaRating.maia2200]);
      expect(host.downloading, [true, false]);
      expect(host.selected, const MaiaOpponentSpec(MaiaRating.maia2200));
    });

    testWidgets('a download that fails leaves the bundled network selected', (tester) async {
      final weights = FakeMaiaWeightsService(downloadSucceeds: false);
      final host = await showSettings(tester, weights: weights);

      await tester.tap(find.text('Maia'));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Slider), const Offset(500, 0));
      await tester.pumpAndSettle();

      expect(find.textContaining('could not be downloaded'), findsOneWidget);
      // Never a game that cannot start: the network that ships with the app plays instead.
      expect(host.selected, const MaiaOpponentSpec(MaiaRating.defaultRating));
    });

    testWidgets('falls back to the bundled network when the selected one was deleted', (
      tester,
    ) async {
      final weights = FakeMaiaWeightsService();
      final host = await showSettings(
        tester,
        selected: const MaiaOpponentSpec(MaiaRating.maia2200),
        weights: weights,
      );

      expect(find.textContaining('${MaiaRating.defaultRating.rating}'), findsWidgets);
      expect(find.textContaining('2200'), findsNothing);
      expect(weights.downloads, isEmpty);
      expect(host.reported, [const MaiaOpponentSpec(MaiaRating.defaultRating)]);
    });

    testWidgets('reports the Stockfish level once the drag ends', (tester) async {
      final host = await showSettings(tester);

      await tester.drag(find.byType(Slider), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(host.reported, [const StockfishOpponentSpec(StockfishLevel.level1)]);
    });

    testWidgets('follows the form back to Stockfish for a variant Maia cannot play', (
      tester,
    ) async {
      final host = await showSettings(
        tester,
        selected: const MaiaOpponentSpec(MaiaRating.maia1500),
      );

      host.pickVariant(Variant.atomic, OpponentSpec.defaultSpec);
      await tester.pumpAndSettle();

      expect(find.byType(PlatformSegmentedControl<OpponentEngine>), findsNothing);
      expect(find.textContaining('trusted by grandmasters'), findsOneWidget);
      expect(host.reported, isEmpty);
    });
  });
}
