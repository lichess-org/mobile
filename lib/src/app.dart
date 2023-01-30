import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: kSupportedLocales,
      onGenerateTitle: (BuildContext context) => 'lichess.org',
      theme: ThemeData(
        colorSchemeSeed: LichessColors.primary,
        useMaterial3: true,
        brightness: brightness,
      ),
      themeMode: themeMode,
      builder: (context, child) {
        return CupertinoTheme(
          data: CupertinoThemeData(
            brightness: brightness,
          ),
          child: Material(child: child),
        );
      },
      onGenerateRoute: (RouteSettings settings) {
        // we don't use named routes but we need this for iOS modal animation
        // see: https://pub.dev/packages/modal_bottom_sheet
        switch (settings.name) {
          case '/':
            return MaterialWithModalsPageRoute(
              builder: (_) => const BottomNavScaffold(),
              settings: settings,
            );
        }
        return null;
      },
    );
  }
}
