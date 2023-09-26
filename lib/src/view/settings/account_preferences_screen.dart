import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';

import 'game_behavior_settings_screen.dart';

class AccountPreferencesScreen extends StatelessWidget {
  const AccountPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account preferences'),
      ),
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
    return SafeArea(
      child: ListView(
        children: [
          ListSection(
            hasLeading: false,
            children: [
              PlatformListTile(
                title: Text(context.l10n.preferencesGameBehavior),
                onTap: () => pushPlatformRoute(
                  context,
                  title: context.l10n.preferencesGameBehavior,
                  builder: (context) => const GameBehaviorSettingsScreen(),
                ),
                trailing: defaultTargetPlatform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
