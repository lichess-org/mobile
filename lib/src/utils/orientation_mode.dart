import 'package:flutter/services.dart';

/// A utility class for managing screen orientations.
enum OrientationMode {
  /// Forces the screen orientation to portrait mode only.
  portraitUp,

  /// Sets orientations for a specialized clock tool screen.
  clockToolScreen,

  /// The default orientation mode.
  systemDefault;

  /// The last set of orientations applied.
  List<DeviceOrientation> get orientations => switch (this) {
    portraitUp => [DeviceOrientation.portraitUp],
    clockToolScreen => [
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],

    /// The empty list causes the application to defer to the operating system default.
    /// https://github.com/flutter/flutter/blob/5491c8c146441d3126aff91beaa3fb5df6d710d0/packages/flutter/lib/src/services/system_chrome.dart#L400
    systemDefault => [],
  };

  /// Applies the orientation mode.
  Future<void> apply() => SystemChrome.setPreferredOrientations(orientations);
}
