import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants.dart';
import 'common/lichess_colors.dart';
import 'features/settings/ui/theme_mode_notifier.dart';
import 'widgets/bottom_navigation.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final brightness = ref.watch(selectedBrigthnessProvider);
    final themeData = ThemeData(
      colorSchemeSeed: LichessColors.primary,
      useMaterial3: true,
      brightness: brightness,
    );
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: kSupportedLocales,
          onGenerateTitle: (BuildContext context) => 'lichess.org',
          theme: themeData,
          themeMode: themeMode,
          home: const BottomNavScaffold(),
        );
      case TargetPlatform.iOS:
        // material theme is also needed on iOS because we're using material widgets
        return Theme(
          data: themeData,
          child: CupertinoApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: kSupportedLocales,
            onGenerateTitle: (BuildContext context) => 'lichess.org',
            theme: CupertinoThemeData(
              brightness: brightness,
            ),
            // ScaffoldMessenger is needed for snack bars
            home: ScaffoldMessenger(
              child: Material(
                // icon theme is needed here because cupertino theme overrides
                // default material icon theme on material widgets
                child: IconTheme(
                  data: CupertinoIconThemeData(
                      color: CupertinoDynamicColor.resolve(
                          CupertinoColors.label, context)),
                  child: const BottomNavScaffold(),
                ),
              ),
            ),
          ),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}
