import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassButton;
import 'package:material_ui/material_ui.dart';

Widget _makeApp({required VoidCallback onYes, required VoidCallback onNo}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return Center(
            child: ElevatedButton(
              child: const Text('Show dialog'),
              onPressed: () {
                showAdaptiveDialog<void>(
                  context: context,
                  builder: (context) => PlatformAlertDialog(
                    title: const Text('Title'),
                    content: const Text('Content'),
                    actions: [
                      PlatformDialogAction(onPressed: onNo, child: const Text('No')),
                      PlatformDialogAction(
                        cupertinoIsDefaultAction: true,
                        onPressed: onYes,
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    ),
  );
}

void main() {
  testWidgets('shows a glass dialog on iOS', (WidgetTester tester) async {
    final pressed = <String>[];
    await tester.pumpWidget(
      _makeApp(onYes: () => pressed.add('yes'), onNo: () => pressed.add('no')),
    );
    await tester.tap(find.text('Show dialog'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
    expect(find.byType(GlassButton), findsNWidgets(2));

    await tester.tap(find.text('Yes'));
    expect(pressed, ['yes']);
  }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

  testWidgets('shows a Material dialog on Android', (WidgetTester tester) async {
    final pressed = <String>[];
    await tester.pumpWidget(
      _makeApp(onYes: () => pressed.add('yes'), onNo: () => pressed.add('no')),
    );
    await tester.tap(find.text('Show dialog'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(GlassButton), findsNothing);

    await tester.tap(find.text('No'));
    expect(pressed, ['no']);
  }, variant: const TargetPlatformVariant({TargetPlatform.android}));
}
