import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';
import 'package:material_ui/material_ui.dart';

import '../test_provider_scope.dart';

void main() {
  for (final type in MoveListType.values) {
    testWidgets('${type.name} move list keeps its scroll position when moves are appended', (
      tester,
    ) async {
      final history = ValueNotifier((count: 60, selected: 1));
      addTearDown(history.dispose);
      await tester.pumpWidget(
        await makeTestProviderScopeApp(
          tester,
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 180,
              child: ValueListenableBuilder(
                valueListenable: history,
                builder: (context, value, _) => MoveList(
                  type: type,
                  slicedMoves: List.filled(value.count, 'Nf3').asMap().entries.slices(2),
                  currentMoveIndex: value.selected,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final scroll = tester.state<ScrollableState>(find.byType(Scrollable)).position;
      scroll.jumpTo(scroll.maxScrollExtent / 2);
      await tester.pumpAndSettle();
      final offset = scroll.pixels;
      expect(offset, greaterThan(0));

      history.value = (count: 61, selected: 1);
      await tester.pump();
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
      expect(scroll.pixels, offset);

      history.value = (count: 61, selected: 2);
      await tester.pump();
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
      expect(scroll.pixels, lessThan(offset));
    });
  }
}
