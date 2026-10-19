import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/study/study_filter.dart';
import 'package:lichess_mobile/src/view/study/study_list.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassButton;
import 'package:material_ui/material_ui.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  testWidgets('selects a category', variant: kPlatformVariant, (tester) async {
    final selected = <StudyCategory>[];
    final app = await makeTestProviderScopeApp(
      tester,
      home: Scaffold(
        body: StudyCategoryChips(
          categories: StudyCategory.values.lock,
          currentCategory: StudyCategory.all,
          onCategorySelected: selected.add,
        ),
      ),
    );
    await tester.pumpWidget(app);

    final isIOS = debugDefaultTargetPlatformOverride == TargetPlatform.iOS;
    expect(find.byType(GlassButton), isIOS ? findsNWidgets(6) : findsNothing);
    expect(find.byType(ChoiceChip), isIOS ? findsNothing : findsNWidgets(6));

    await tester.tap(find.text('My studies'));
    await tester.pumpAndSettle();
    expect(selected, [StudyCategory.mine]);
  });
}
