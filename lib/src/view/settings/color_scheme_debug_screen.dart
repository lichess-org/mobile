import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/theme.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_segmented_control.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:material_ui/material_ui.dart';

enum _SchemeKind(final String label) {
  iosAccent('iOS accent'),
  tonalSpot('M3 tonal spot'),
  vibrant('M3 vibrant');

  ColorScheme build(Color seed, Brightness brightness) => switch (this) {
    iosAccent => makeIOSAccentColorScheme(seedColor: seed, brightness: brightness),
    tonalSpot => ColorScheme.fromSeed(seedColor: seed, brightness: brightness),
    vibrant => ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
      dynamicSchemeVariant: .vibrant,
    ),
  };
}

/// A debug screen showing every role of the color scheme generated from the app seed (the custom
/// background one if set, the board one otherwise), in light and dark mode, to compare the iOS
/// accent scheme with the Material ones.
class const ColorSchemeDebugScreen({super.key}) extends ConsumerStatefulWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const ColorSchemeDebugScreen());
  }

  @override
  ConsumerState<ColorSchemeDebugScreen> createState() => _ColorSchemeDebugScreenState();
}

class _ColorSchemeDebugScreenState() extends ConsumerState<ColorSchemeDebugScreen> {
  _SchemeKind kind = .iosAccent;

  @override
  Widget build(BuildContext context) {
    final boardSeed = ref
        .watch(boardPreferencesProvider.select((prefs) => prefs.boardTheme))
        .colors
        .darkSquare;
    // Same seed as `makeAppTheme`.
    final backgroundSeed = ref.watch(
      generalPreferencesProvider.select(
        (prefs) =>
            prefs.backgroundImage?.seedColor ??
            switch (prefs.backgroundColor) {
              (final color, true) => color.darker,
              (final color, false) => color.color,
              null => null,
            },
      ),
    );
    final seed = backgroundSeed ?? boardSeed;
    final light = kind.build(seed, .light);
    final dark = kind.build(seed, .dark);
    // The app surfaces: with a custom background, those of the scheme itself; otherwise neutral,
    // from the monochrome variant, as on iOS.
    ColorScheme neutral(Brightness brightness) => backgroundSeed != null
        ? kind.build(seed, brightness)
        : ColorScheme.fromSeed(
            seedColor: seed,
            brightness: brightness,
            dynamicSchemeVariant: .monochrome,
          );
    final lightNeutral = neutral(.light);
    final darkNeutral = neutral(.dark);

    // (name, background, foreground) of each row, from a light or dark scheme.
    List<(String, Color, Color)> rows(ColorScheme s, ColorScheme neutral) => [
      (backgroundSeed != null ? 'seed (background)' : 'seed (board)', seed, Colors.white),
      ('primary', s.primary, s.onPrimary),
      ('primary on app background', neutral.surface, s.primary),
      ('primary on app card', neutral.surfaceContainerHigh, s.primary),
      ('primaryContainer', s.primaryContainer, s.onPrimaryContainer),
      ('primaryFixed', s.primaryFixed, s.onPrimaryFixed),
      ('primaryFixedDim', s.primaryFixedDim, s.onPrimaryFixedVariant),
      ('inversePrimary on inverseSurface', s.inverseSurface, s.inversePrimary),
      ('secondary', s.secondary, s.onSecondary),
      ('secondary on app card', neutral.surfaceContainerHigh, s.secondary),
      ('secondaryContainer', s.secondaryContainer, s.onSecondaryContainer),
      ('secondaryFixed', s.secondaryFixed, s.onSecondaryFixed),
      ('secondaryFixedDim', s.secondaryFixedDim, s.onSecondaryFixedVariant),
      ('tertiary', s.tertiary, s.onTertiary),
      ('tertiary on app card', neutral.surfaceContainerHigh, s.tertiary),
      ('tertiaryContainer', s.tertiaryContainer, s.onTertiaryContainer),
      ('tertiaryFixed', s.tertiaryFixed, s.onTertiaryFixed),
      ('tertiaryFixedDim', s.tertiaryFixedDim, s.onTertiaryFixedVariant),
      ('error', s.error, s.onError),
      ('errorContainer', s.errorContainer, s.onErrorContainer),
      ('surface', s.surface, s.onSurface),
      ('surfaceDim', s.surfaceDim, s.onSurface),
      ('surfaceBright', s.surfaceBright, s.onSurface),
      ('surfaceContainerLowest', s.surfaceContainerLowest, s.onSurface),
      ('surfaceContainerLow', s.surfaceContainerLow, s.onSurface),
      ('surfaceContainer', s.surfaceContainer, s.onSurface),
      ('surfaceContainerHigh', s.surfaceContainerHigh, s.onSurface),
      ('surfaceContainerHighest', s.surfaceContainerHighest, s.onSurface),
      ('onSurfaceVariant on surface', s.surface, s.onSurfaceVariant),
      ('outline', s.outline, s.surface),
      ('outlineVariant', s.outlineVariant, s.onSurface),
      ('inverseSurface', s.inverseSurface, s.onInverseSurface),
      ('surfaceTint', s.surfaceTint, s.surface),
      ('shadow', s.shadow, Colors.white),
      ('scrim', s.scrim, Colors.white),
    ];

    final lightRows = rows(light, lightNeutral);
    final darkRows = rows(dark, darkNeutral);

    return PlatformScaffold(
      appBar: const PlatformAppBar(title: Text('Color scheme')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PlatformSegmentedControl<_SchemeKind>(
              segments: [for (final kind in _SchemeKind.values) (kind, kind.label)],
              selected: kind,
              showSelectedIcon: false,
              onChanged: (value) => setState(() => kind = value),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(child: Text('Light', textAlign: .center)),
                SizedBox(width: 8.0),
                Expanded(child: Text('Dark', textAlign: .center)),
              ],
            ),
          ),
          for (var i = 0; i < lightRows.length; i++)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(lightRows[i].$1, style: TextTheme.of(context).labelMedium),
                  const SizedBox(height: 2.0),
                  Row(
                    children: [
                      Expanded(
                        child: _Swatch(background: lightRows[i].$2, foreground: lightRows[i].$3),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: _Swatch(background: darkRows[i].$2, foreground: darkRows[i].$3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

/// A color with its foreground: the HCT of both and their contrast ratio.
class const _Swatch({required final Color background, required final Color foreground})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bg = Hct.fromInt(background.toARGB32());
    final fg = Hct.fromInt(foreground.toARGB32());
    final contrast = Contrast.ratioOfTones(bg.tone, fg.tone);
    String hct(Hct c) => 'H${c.hue.round()} C${c.chroma.round()} T${c.tone.round()}';
    String hex(Color c) => '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: foreground, fontSize: 11.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Aa ${contrast.toStringAsFixed(1)}:1',
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            Text('${hex(background)} ${hct(bg)}'),
            Text('fg ${hct(fg)}'),
          ],
        ),
      ),
    );
  }
}
