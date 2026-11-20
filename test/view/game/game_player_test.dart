import 'dart:convert';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:material_ui/material_ui.dart';

import '../../model/game/game_socket_example_data.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  for (final width in [96.0, 109.7, 110.0, 160.0]) {
    testWidgets('compact move confirmation preserves both tap targets at width=$width', (
      tester,
    ) async {
      await prepareLayoutGolden(tester, loadFonts: true);
      var accepted = 0;
      var cancelled = 0;
      final flutterTestOnError = FlutterError.onError!;
      final app = await makeTestProviderScopeApp(
        tester,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: width,
              child: ConfirmMove(onConfirm: () => accepted++, onCancel: () => cancelled++),
            ),
          ),
        ),
      );
      FlutterError.onError = flutterTestOnError;
      addTearDown(() => FlutterError.onError = flutterTestOnError);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      final bounds = tester.getRect(find.byType(ConfirmMove));
      final cancel = find.byIcon(CupertinoIcons.xmark_rectangle_fill);
      final accept = find.byIcon(CupertinoIcons.checkmark_rectangle_fill);
      for (final icon in [cancel, accept]) {
        expect(icon.hitTestable(), findsOneWidget);
        final button = find.ancestor(of: icon, matching: find.byType(SemanticIconButton));
        final rect = tester.getRect(button);
        expect(rect.width, greaterThanOrEqualTo(48));
        expect(rect.height, greaterThanOrEqualTo(48));
        expect(bounds.contains(rect.topLeft), isTrue);
        expect(rect.right, lessThanOrEqualTo(bounds.right));
        expect(rect.bottom, lessThanOrEqualTo(bounds.bottom));
      }
      expect(tester.getRect(cancel).overlaps(tester.getRect(accept)), isFalse);
      await tester.tap(cancel);
      await tester.tap(accept);
      expect(cancelled, 1);
      expect(accepted, 1);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLayoutGolden(
        find.byType(ConfirmMove),
        '../../../build/compact-layout/confirm-move-width-$width',
      );
    }, variant: kPlatformVariant);
  }

  for (final direction in TextDirection.values) {
    for (final clockPosition in ClockPosition.values) {
      testWidgets('compact player metadata retains alignment '
          '${direction.name} ${clockPosition.name}', (tester) async {
        await prepareLayoutGolden(tester, loadFonts: true);
        final event = jsonDecode(
          makeFullEvent(
            const GameId('abcdefgh'),
            '',
            whiteUserName: 'White',
            blackUserName: 'Black',
          ),
        ) as Map<String, dynamic>;
        final game = GameFullEvent.fromJson(event['d'] as Map<String, dynamic>).game;
        final flutterTestOnError = FlutterError.onError!;
        final app = await makeTestProviderScopeApp(
          tester,
          surfaceSize: const Size(400, 200),
          devicePixelRatio: 1,
          home: Scaffold(
            body: Directionality(
              textDirection: direction,
              child: Center(
                child: SizedBox(
                  width: 360,
                  child: GamePlayer(
                    game: game,
                    side: Side.white,
                    shouldLinkToUserProfile: false,
                    clockPosition: clockPosition,
                    clock: const SizedBox(width: 80, height: 32, child: Text('05:00')),
                  ),
                ),
              ),
            ),
          ),
        );
        FlutterError.onError = flutterTestOnError;
        addTearDown(() => FlutterError.onError = flutterTestOnError);
        await tester.pumpWidget(app);
        await tester.pumpAndSettle();
        final metadata = find.descendant(of: find.byType(GamePlayer), matching: find.byType(Wrap));
        final info = find.ancestor(of: metadata, matching: find.byType(Column)).first;
        final infoRect = tester.getRect(info);
        final childRects = tester
            .widget<Wrap>(metadata)
            .children
            .map((child) => tester.getRect(find.byWidget(child)));
        final content = childRects.reduce((bounds, rect) => bounds.expandToInclude(rect));
        expect(content.width, lessThan(infoRect.width));
        expect(tester.getRect(metadata).width, infoRect.width);
        final alignLeft =
            (clockPosition == ClockPosition.right) == (direction == TextDirection.ltr);
        expect(
          alignLeft ? content.left : content.right,
          moreOrLessEquals(alignLeft ? infoRect.left : infoRect.right),
        );
        expect(tester.takeException(), isNull);
        await expectLayoutGolden(
          find.byType(GamePlayer),
          '../../../build/compact-layout/player-alignment-${direction.name}-${clockPosition.name}',
        );
      }, variant: kPlatformVariant);
    }
  }
}
