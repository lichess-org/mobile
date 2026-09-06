import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

/// One active choice at a time: count target, MB target, or all.
enum OfflineVaultMode { count, mb, all }

/// Target for the offline vault. All modes map to one row goal.
///
/// No codegen here on purpose: plain JSON so no build_runner step is needed.
class OfflineVaultPrefs implements Serializable {
  const OfflineVaultPrefs({required this.mode, required this.mbTarget, required this.countTarget});

  final OfflineVaultMode mode;
  final int mbTarget;
  final int countTarget;

  static const int kMinCount = 100;
  static const int kMaxServerCount = 5000;
  static const int kMinMb = 1;
  static const int kMaxMb = 2048;

  /// Rough bytes per stored row. Real value shifts with moves/themes.
  /// Calibrated after first fill; start guess only.
  static const int kBytesPerPuzzleGuess = 500;

  factory OfflineVaultPrefs.defaults({LightUser? user}) =>
      const OfflineVaultPrefs(mode: OfflineVaultMode.count, mbTarget: 0, countTarget: 100);

  factory OfflineVaultPrefs.fromJson(Map<String, dynamic> json) {
    final modeStr = json['mode'] as String?;
    return OfflineVaultPrefs(
      mode: OfflineVaultMode.values.asNameMap()[modeStr] ?? OfflineVaultMode.count,
      mbTarget: (json['mbTarget'] as num?)?.toInt() ?? 0,
      countTarget: (json['countTarget'] as num?)?.toInt() ?? 100,
    );
  }

  @override
  Map<String, dynamic> toJson() => {'mode': mode.name, 'mbTarget': mbTarget, 'countTarget': countTarget};

  /// Row goal for [mode]. `all` = no cap (caller must gate WiFi/power).
  /// `mb` maps via guess; UI shows real kept MB after fill.
  int get targetCount {
    switch (mode) {
      case OfflineVaultMode.count:
        return countTarget.clamp(kMinCount, 6000000);
      case OfflineVaultMode.mb:
        final n = (mbTarget.clamp(kMinMb, kMaxMb) * 1024 * 1024) ~/ kBytesPerPuzzleGuess;
        return n.clamp(kMinCount, 6000000);
      case OfflineVaultMode.all:
        return 6000000;
    }
  }

  bool get needsFileImport => targetCount > kMaxServerCount;

  OfflineVaultPrefs copyWith({OfflineVaultMode? mode, int? mbTarget, int? countTarget}) =>
      OfflineVaultPrefs(
        mode: mode ?? this.mode,
        mbTarget: mbTarget ?? this.mbTarget,
        countTarget: countTarget ?? this.countTarget,
      );
}

final offlineVaultPrefsProvider = NotifierProvider<OfflineVaultPrefsNotifier, OfflineVaultPrefs>(
  OfflineVaultPrefsNotifier.new,
  name: 'OfflineVaultPrefsProvider',
);

class OfflineVaultPrefsNotifier extends Notifier<OfflineVaultPrefs>
    with SessionPreferencesStorage<OfflineVaultPrefs> {
  @override
  PrefCategory get prefCategory => PrefCategory.offlineVault;

  @override
  OfflineVaultPrefs defaults({LightUser? user}) => OfflineVaultPrefs.defaults(user: user);

  @override
  OfflineVaultPrefs fromJson(Map<String, dynamic> json) => OfflineVaultPrefs.fromJson(json);

  @override
  OfflineVaultPrefs build() {
    final p = fetch();
    final fixedCount = p.countTarget.clamp(
      OfflineVaultPrefs.kMinCount,
      6000000,
    );
    final fixedMb = p.mbTarget.clamp(0, OfflineVaultPrefs.kMaxMb);
    return (fixedCount == p.countTarget && fixedMb == p.mbTarget)
        ? p
        : p.copyWith(countTarget: fixedCount, mbTarget: fixedMb);
  }

  Future<void> setCount(int n) =>
      save(state.copyWith(mode: OfflineVaultMode.count, countTarget: n));

  Future<void> setMb(int mb) => save(state.copyWith(mode: OfflineVaultMode.mb, mbTarget: mb));

  Future<void> setAll() => save(state.copyWith(mode: OfflineVaultMode.all));
}
