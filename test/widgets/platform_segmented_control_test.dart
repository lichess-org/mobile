import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/platform_segmented_control.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassSegmentedControl;
import 'package:material_ui/material_ui.dart';

import '../test_helpers.dart';

class const _Host() extends StatefulWidget {
  @override
  State<_Host> createState() => _HostState();
}

class _HostState() extends State<_Host> {
  String selected = 'a';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: PlatformSegmentedControl<String>(
            segments: const [('a', 'First'), ('b', 'Second')],
            selected: selected,
            onChanged: (value) => setState(() => selected = value),
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('selects a segment', variant: kPlatformVariant, (tester) async {
    await tester.pumpWidget(const _Host());

    final isIOS = debugDefaultTargetPlatformOverride == TargetPlatform.iOS;
    expect(find.byType(GlassSegmentedControl), isIOS ? findsOneWidget : findsNothing);
    expect(find.byType(SegmentedButton<String>), isIOS ? findsNothing : findsOneWidget);

    await tester.tap(find.text('Second').first);
    await tester.pumpAndSettle();

    expect(tester.state<_HostState>(find.byType(_Host)).selected, 'b');
  });
}
