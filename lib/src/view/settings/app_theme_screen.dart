import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class AppThemeScreen extends StatelessWidget {
  const AppThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _androidBuilder, iosBuilder: _iosBuilder);
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(context.l10n.mobileTheme)), body: _Body());
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(navigationBar: const CupertinoNavigationBar(), child: _Body());
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(generalPreferencesProvider.select((p) => p.appTheme));
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final hasSystemColors = getCorePalette() != null;

    final choices = AppTheme.values.where((t) => t != AppTheme.system || hasSystemColors).toList();

    void onChanged(AppTheme? value) =>
        ref.read(generalPreferencesProvider.notifier).setAppTheme(value ?? defaultAppTheme);

    final brightness = Theme.of(context).brightness;

    const itemsByRow = 4;
    final width = MediaQuery.sizeOf(context).width;
    final size = (width - 16 * (itemsByRow + 2)) / itemsByRow;

    return GridView.builder(
      padding: MediaQuery.paddingOf(context) + Styles.bodyPadding,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemsByRow,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemBuilder: (context, index) {
        final t = choices[index];
        final fsd = t.getFlexScheme(boardPrefs.boardTheme);

        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: FlexThemeModeOptionButton(
              flexSchemeColor: brightness == Brightness.light ? fsd.light : fsd.dark,
              selected: t == appTheme,
              // unselectedBorder: BorderSide.none,
              // selectedBorder: BorderSide(color: Theme.of(context).colorScheme.outline, width: 3),
              backgroundColor: Theme.of(context).colorScheme.surface,
              padding: EdgeInsets.zero,
              width: size / 2,
              height: size / 2,
              borderRadius: 0,
              optionButtonPadding: EdgeInsets.zero,
              optionButtonMargin: EdgeInsets.zero,
              optionButtonBorderRadius: 4,
              onSelect: () => onChanged(t),
            ),
          ),
        );
      },
      itemCount: choices.length,
    );
  }
}
