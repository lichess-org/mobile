import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

/// OrientationMode is an enum that controls how the application UI
/// will be oriented on the device screen.
///
/// It offers methods to apply and restore screen orientation preferences
/// by using SystemChrome API.
enum OrientationMode {
  /// Forces the screen orientation to portrait mode only.
  portraitUp,

  /// Allows all device orientations (portrait and landscape).
  allOrientations,

  /// Sets orientations for a specialized clock tool screen.
  clockToolScreen,

  /// The default orientation mode.
  systemDefault;

  /// Holds a history of the last applied orientation modes.
  ///
  /// Each time [apply] is called, the current orientation mode is added here.
  @visibleForTesting
  static List<OrientationMode> lastOrientations = [];

  /// Restores the last applied orientation mode.
  /// If there are no more orientations to restore, the system default is applied.
  ///
  /// This method is used to revert the screen orientation to the previous state.
  static Future<void> restoreLast() {
    if (lastOrientations.isEmpty) {
      return SystemChrome.setPreferredOrientations(systemDefault.orientations);
    }

    lastOrientations.removeLast();
    return SystemChrome.setPreferredOrientations(lastOrientations.last.orientations);
  }

  /// Returns the list of [DeviceOrientation] values associated with the current enum value.
  ///
  /// This is used to set the screen orientation according to the enum's configuration.
  List<DeviceOrientation> get orientations => switch (this) {
    portraitUp => [DeviceOrientation.portraitUp],
    allOrientations => [...DeviceOrientation.values],
    clockToolScreen => [
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],

    /// The empty list causes the application to defer to the operating system default.
    /// https://github.com/flutter/flutter/blob/5491c8c146441d3126aff91beaa3fb5df6d710d0/packages/flutter/lib/src/services/system_chrome.dart#L400
    systemDefault => [],
  };

  /// Applies the orientation list for the current enum value
  /// and appends this orientation mode to the history.
  ///
  /// This locks the screen orientation according to the enum's configuration.
  Future<void> apply() {
    lastOrientations.add(this);
    return SystemChrome.setPreferredOrientations(orientations);
  }
}
