// Device Preview is only imported by this development entry point.
// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:device_preview/presets.dart';
import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/binding/binding_play.dart';
import 'package:lichess_mobile/src/bootstrap.dart';
import 'package:lichess_mobile/src/widgets/platform.dart'
    show DebugLiquidGlassOverride, useLiquidGlass;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show LiquidGlassWidgets;
import 'package:material_ui/material_ui.dart';

/// Run with `flutter run -t bin/device_preview.dart`.
Future<void> main() async {
  if (!kDebugMode) {
    throw UnsupportedError('The device preview entry point requires a debug build.');
  }
  DevicePreview.enable();
  for (final preset in [_classicIosPreset, _classicIpadPreset]) {
    DevicePreview.controller.registerPreset(preset);
  }
  // The preview can show iOS glass on any host.
  if (!Platform.isIOS) await LiquidGlassWidgets.initialize();
  await bootstrapApp(
    PlayLichessBinding.ensureInitialized,
    app: const DevicePreviewApp(
      child: AppInitializationScreen(
        application: Application(
          themeAnimationStyle: AnimationStyle.noAnimation,
          themeOverride: previewTheme,
        ),
      ),
    ),
  );
}

/// Resolves list title styles so live platform switches can animate them safely.
ThemeData previewTheme(ThemeData theme) {
  final titleStyle = theme.listTileTheme.titleTextStyle;
  return titleStyle == null
      ? theme
      : theme.copyWith(
          listTileTheme: theme.listTileTheme.copyWith(
            titleTextStyle: theme.textTheme.bodyMedium!.merge(titleStyle).copyWith(inherit: false),
          ),
        );
}

// Custom device presets shown in the DevTools device picker.
final _classicIosPreset = DevicePreset.fromJson({
  ...DevicePresets.iPhone16.toJson(),
  'id': 'lichess-ios-classic',
  'name': 'Lichess iOS <26 (iPhone 16)',
});
final _classicIpadPreset = DevicePreset.fromJson({
  ...DevicePresets.iPad10.toJson(),
  'id': 'lichess-ipados-classic',
  'name': 'Lichess iPadOS <26 (iPad 10th gen)',
});

/// Connects the DevTools device picker to the app's platform designs.
class const DevicePreviewApp({required final Widget child, super.key}) extends StatefulWidget {
  @override
  State<DevicePreviewApp> createState() => _DevicePreviewAppState();
}

class _DevicePreviewAppState() extends State<DevicePreviewApp> {
  late final _controller = DevicePreview.controller;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_syncPresetPlatform);
  }

  void _syncPresetPlatform() {
    final simulation = _controller.simulation;
    if (simulation == null) return;
    final preset = _controller.presets
        .where((preset) => preset.id == simulation.presetId)
        .firstOrNull;
    if (simulation.simulatesMetrics && preset == null) return;
    final platform = simulation.simulatesMetrics ? preset!.platform : null;
    if (simulation.targetPlatform == platform) return;

    final device = (simulation.presetId, simulation.simulatesMetrics);
    unawaited(
      Future<void>(() async {
        if (!mounted) return;
        await _controller.update(
          (current) => (current.presetId, current.simulatesMetrics) == device
              ? current.copyWith(targetPlatform: platform)
              : current,
        );
      }),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_syncPresetPlatform);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller.simulationListenable,
      child: widget.child,
      builder: (context, simulation, child) => DebugLiquidGlassOverride(
        enabled: simulation != null && simulation.simulatesMetrics
            ? simulation.presetId != _classicIosPreset.id &&
                  simulation.presetId != _classicIpadPreset.id
            : useLiquidGlass(context),
        child: child!,
      ),
    );
  }
}
