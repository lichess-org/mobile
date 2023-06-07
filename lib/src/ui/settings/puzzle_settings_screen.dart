import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';

class PuzzleSettingsScreen extends StatelessWidget {
  const PuzzleSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.background)),
      body: _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.read(authSessionProvider);
    final puzzlePrefs = ref.watch(puzzlePreferencesProvider(session?.user.id));
    return SafeArea(
      child: ListView(
        children: [
          ListSection(
            hasLeading: false,
            showDivider: true,
            children: [
              SwitchSettingTile(
                title: const Text('Jump to next puzzle immediately'),
                value: puzzlePrefs.nextPuzzleImmediately,
                onChanged: (value) {
                  ref
                      .read(
                          puzzlePreferencesProvider(session?.user.id).notifier)
                      .toggleNextPuzzleImmediately();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
