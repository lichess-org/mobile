import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassButton;
import 'package:material_ui/material_ui.dart';

import '../test_helpers.dart';

void main() {
  testWidgets('glass bar buttons are glass capsules on iOS', variant: kPlatformVariant, (
    tester,
  ) async {
    var iconTaps = 0;
    var textTaps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomBar(
            cupertinoGlass: true,
            children: [
              BottomBarButton(
                icon: Icons.chat_bubble_outline,
                label: 'Chat',
                showLabel: true,
                onTap: () => iconTaps++,
              ),
              BottomBarTextButton(onPressed: () => textTaps++, child: const Text('Round 1')),
            ],
          ),
        ),
      ),
    );

    final isIOS = debugDefaultTargetPlatformOverride == TargetPlatform.iOS;
    expect(find.byType(GlassButton), isIOS ? findsNWidgets(2) : findsNothing);

    await tester.tap(find.text('Chat'));
    await tester.tap(find.text('Round 1'));
    await tester.pumpAndSettle();

    expect(iconTaps, 1);
    expect(textTaps, 1);
  });
}
