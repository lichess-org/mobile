import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class PuzzleSettingsScreen extends StatelessWidget {
  const PuzzleSettingsScreen({super.key, required this.userId});

  final UserId userId;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _Body(userId: userId),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.userId});

  final UserId userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoNext = ref.watch(
      PuzzlePreferencesProvider(userId).select((value) => value.autoNext),
    );

    return SafeArea(
      child: ListView(
        children: [
          ListSection(
            hasLeading: true,
            showDivider: true,
            children: [
              SwitchSettingTile(
                title: Text(context.l10n.puzzleJumpToNextPuzzleImmediately),
                value: autoNext,
                onChanged: (value) {
                  ref
                      .read(PuzzlePreferencesProvider(userId).notifier)
                      .setAutoNext(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
