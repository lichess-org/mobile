import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class BoardClockPositionScreen extends StatelessWidget {
  const BoardClockPositionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clock Position')), //TODO: l10n
      body: _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _Body(),
    );
  }

  static String position(BuildContext context, ClockPosition position) {
    switch (position) {
      case ClockPosition.left:
        return 'Left';
      case ClockPosition.right:
        return 'Right';
    }
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clockPosition = ref.watch(
      boardPreferencesProvider.select((state) => state.clockPosition),
    );

    void onChanged(ClockPosition? value) => ref
        .read(boardPreferencesProvider.notifier)
        .setClockPosition(value ?? ClockPosition.right);

    return SafeArea(
      child: ListView(
        children: [
          ChoicePicker(
            choices: ClockPosition.values,
            selectedItem: clockPosition,
            titleBuilder: (t) =>
                Text(BoardClockPositionScreen.position(context, t)),
            onSelectedItemChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
