import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/settings/board_settings_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class PuzzleSettingsScreen extends ConsumerWidget {
  const PuzzleSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoNext = ref.watch(
      puzzlePreferencesProvider.select((value) => value.autoNext),
    );
    return BottomSheetScrollableContainer(
      children: [
        SwitchSettingTile(
          title: Text(context.l10n.puzzleJumpToNextPuzzleImmediately),
          value: autoNext,
          onChanged: (value) {
            ref.read(puzzlePreferencesProvider.notifier).setAutoNext(value);
          },
        ),
        PlatformListTile(
          title: const Text('Board settings'),
          trailing: const Icon(CupertinoIcons.chevron_right),
          onTap: () {
            pushPlatformRoute(
              context,
              fullscreenDialog: true,
              screen: const BoardSettingsScreen(),
            );
          },
        ),
      ],
    );
  }
}
