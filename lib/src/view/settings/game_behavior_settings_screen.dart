import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';

class GameBehaviorSettingsScreen extends StatelessWidget {
  const GameBehaviorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.preferencesGameBehavior)),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountPrefs = ref.watch(accountPreferencesProvider);

    return accountPrefs.when(
      data: (data) {
        if (data == null) {
          return const Center(
            child: Text('You must be logged in to view this page.'),
          );
        }
        return SafeArea(
          child: ListView(
            children: [
              ListSection(
                hasLeading: false,
                children: [
                  SettingsListTile(
                    settingsLabel:
                        context.l10n.preferencesPromoteToQueenAutomatically,
                    settingsValue: data.autoQueen.label(context),
                    showCupertinoTrailingValue: false,
                    onTap: () {
                      if (defaultTargetPlatform == TargetPlatform.android) {
                        showChoicePicker(
                          context,
                          choices: AutoQueen.values,
                          selectedItem: data.autoQueen,
                          labelBuilder: (t) => Text(t.label(context)),
                          onSelectedItemChanged: (AutoQueen? value) {
                            ref
                                .read(accountPreferencesProvider.notifier)
                                .setAutoQueen(value ?? data.autoQueen);
                          },
                        );
                      } else {
                        pushPlatformRoute(
                          context,
                          title: context
                              .l10n.preferencesPromoteToQueenAutomatically,
                          builder: (context) => const AutoQueenSettingsScreen(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(err.toString())),
    );
  }
}

class AutoQueenSettingsScreen extends ConsumerWidget {
  const AutoQueenSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountPrefs = ref.watch(accountPreferencesProvider);
    return accountPrefs.when(
      data: (data) {
        if (data == null) {
          return const Center(
            child: Text('You must be logged in to view this page.'),
          );
        }

        return CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(),
          child: SafeArea(
            child: ListView(
              children: [
                ChoicePicker(
                  choices: AutoQueen.values,
                  selectedItem: data.autoQueen,
                  titleBuilder: (t) => Text(t.label(context)),
                  onSelectedItemChanged: (AutoQueen? v) {
                    ref
                        .read(accountPreferencesProvider.notifier)
                        .setAutoQueen(v ?? data.autoQueen);
                  },
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(err.toString())),
    );
  }
}
