import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/puzzle/offline_vault_prefs.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:material_ui/material_ui.dart';

/// Human label for the current vault goal. Hardcoded English until stable.
String offlineVaultLabel(OfflineVaultPrefs prefs) {
  return switch (prefs.mode) {
    OfflineVaultMode.count => '${prefs.countTarget} puzzles',
    OfflineVaultMode.mb => '${prefs.mbTarget} MB (~${prefs.targetCount} puzzles)',
    OfflineVaultMode.all => 'All puzzles',
  };
}

/// One active choice at a time: count, MB target, or all.
/// Call from the puzzles tab, never from inside a puzzle.
Future<void> showOfflineVaultPicker(BuildContext context, WidgetRef ref) async {
  final prefs = ref.read(offlineVaultPrefsProvider);
  OfflineVaultMode selMode = prefs.mode;
  if (!context.mounted) return;
  await showChoicePicker(
    context,
    choices: OfflineVaultMode.values,
    selectedItem: prefs.mode,
    labelBuilder: (t) => Text(t.name),
    onSelectedItemChanged: (OfflineVaultMode? m) {
      if (m != null) selMode = m;
    },
  );
  final notifier = ref.read(offlineVaultPrefsProvider.notifier);
  switch (selMode) {
    case OfflineVaultMode.count:
      const choices = [100, 500, 1000, 5000, 20000, 100000];
      int sel = prefs.countTarget;
      if (!context.mounted) return;
      await showChoicePicker(
        context,
        choices: choices,
        selectedItem: choices.contains(sel) ? sel : 1000,
        labelBuilder: (t) => Text(t.toString()),
        onSelectedItemChanged: (int? n) {
          if (n != null) sel = n;
        },
      );
      await notifier.setCount(sel);
    case OfflineVaultMode.mb:
      const choices = [10, 50, 100, 250, 500, 1000];
      int sel = prefs.mbTarget == 0 ? 50 : prefs.mbTarget;
      if (!context.mounted) return;
      await showChoicePicker(
        context,
        choices: choices,
        selectedItem: choices.contains(sel) ? sel : 50,
        labelBuilder: (t) => Text('$t MB'),
        onSelectedItemChanged: (int? n) {
          if (n != null) sel = n;
        },
      );
      await notifier.setMb(sel);
    case OfflineVaultMode.all:
      await notifier.setAll();
  }
}
