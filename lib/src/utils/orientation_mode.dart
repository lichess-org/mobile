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
  clockToolScreen;

  /// Holds a history of the last applied orientation modes.
  ///
  /// Each time [apply] is called, the current orientation mode is added here.
  @visibleForTesting
  static List<OrientationMode> lastOrientations = [];

  /// Restores the last orientation mode from the history,
  /// if there is more than one entry available.
  ///
  /// Removes the most recent orientation mode and applies the previous one.
  static Future<void> restoreLast() async {
    if (lastOrientations.length > 1) {
      lastOrientations.removeLast();
      return SystemChrome.setPreferredOrientations(lastOrientations.last.orientations);
    }
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
