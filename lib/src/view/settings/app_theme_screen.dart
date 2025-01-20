import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
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

    final checkedIcon =
        Theme.of(context).platform == TargetPlatform.android
            ? const Icon(Icons.check)
            : Icon(
              CupertinoIcons.check_mark_circled_solid,
              color: CupertinoTheme.of(context).primaryColor,
            );

    final brightness = Theme.of(context).brightness;

    return ListView.separated(
      itemBuilder: (context, index) {
        final t = choices[index];
        final fsd = t.getFlexScheme(boardPrefs.boardTheme);

        return AdaptiveListTile(
          // selected: t == appTheme,
          leading: SizedBox(
            width: 52,
            height: 36,
            child: FlexThemeModeOptionButton(
              flexSchemeColor: brightness == Brightness.light ? fsd.light : fsd.dark,
              selected: false,
              unselectedBorder: BorderSide.none,
              selectedBorder: BorderSide(color: Theme.of(context).colorScheme.outline, width: 3),
              backgroundColor: Theme.of(context).colorScheme.surface,
              width: 26,
              height: 18,
              padding: EdgeInsets.zero,
              borderRadius: 0,
              optionButtonPadding: EdgeInsets.zero,
              optionButtonMargin: EdgeInsets.zero,
              optionButtonBorderRadius: 4,
              onSelect: () => onChanged(t),
            ),
          ),
          trailing: t == appTheme ? checkedIcon : null,
          title: Text(fsd.name),
          onTap: () => onChanged(t),
        );
      },
      separatorBuilder:
          (_, __) => PlatformDivider(
            height: 1,
            // on iOS: 52 (leading) + 14 (default indent) + 16 (padding)
            indent: Theme.of(context).platform == TargetPlatform.iOS ? 52 + 14 + 16 : null,
            color: Theme.of(context).platform == TargetPlatform.iOS ? null : Colors.transparent,
          ),
      itemCount: choices.length,
    );
  }
}
