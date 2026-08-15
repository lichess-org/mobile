import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// A simple wrapper widget that shows a button to open a bottom sheet via the given [builder].
class TestBottomSheetOpener extends StatelessWidget {
  const TestBottomSheetOpener({required this.builder});

  final WidgetBuilder builder;

  static Future<void> openBottomSheet(WidgetTester tester) async {
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Center(
            child: ElevatedButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                builder: builder,
              ),
              child: const Text('Open'),
            ),
          );
        },
      ),
    );
  }
}
