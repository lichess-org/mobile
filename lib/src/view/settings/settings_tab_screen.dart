import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/model/settings/sound_theme.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/android.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/package_info.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/view/settings/volume_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:url_launcher/url_launcher.dart';

import 'account_preferences_screen.dart';
import 'board_behavior_settings_screen.dart';
import 'board_theme_screen.dart';
import 'piece_set_screen.dart';
import 'sound_settings_screen.dart';
import 'theme_mode_screen.dart';

class SettingsTabScreen extends ConsumerWidget {
  const SettingsTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (!didPop) {
          ref.read(currentBottomTabProvider.notifier).state = BottomTab.home;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.settingsSettings),
        ),
        body: SafeArea(child: _Body()),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(context.l10n.settingsSettings),
          ),
          SliverSafeArea(
            top: false,
            sliver: _Body(),
          ),
        ],
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generalPrefs = ref.watch(generalPreferencesProvider);
    final authController = ref.watch(authControllerProvider);
    final userSession = ref.watch(authSessionProvider);
    final packageInfo = ref.watch(packageInfoProvider);
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final androidVersionAsync = ref.watch(androidVersionProvider);

    final Widget? donateButton =
        userSession == null || userSession.user.isPatron != true
            ? PlatformListTile(
                leading: Icon(
                  LichessIcons.patron,
                  semanticLabel: context.l10n.patronLichessPatron,
                  color: context.lichessColors.brag,
                ),
                title: Text(
                  context.l10n.patronDonate,
                  style: TextStyle(color: context.lichessColors.brag),
                ),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                onTap: () {
                  launchUrl(Uri.parse('https://lichess.org/patron'));
                },
              )
            : null;

    String volumeLabel(double volume) => '${(volume * 100).toInt()}%';
    final List<Widget> content = [
      ListSection(
        header: userSession != null
            ? UserFullNameWidget(user: userSession.user)
            : null,
        hasLeading: true,
        showDivider: true,
        children: [
          if (userSession != null) ...[
            PlatformListTile(
              leading: const Icon(Icons.person),
              title: Text(context.l10n.profile),
              trailing: Theme.of(context).platform == TargetPlatform.iOS
                  ? const CupertinoListTileChevron()
                  : null,
              onTap: () {
                pushPlatformRoute(
                  context,
                  title: context.l10n.profile,
                  builder: (context) => const ProfileScreen(),
                );
              },
            ),
            PlatformListTile(
              leading: const Icon(Icons.manage_accounts),
              title: Text(context.l10n.preferencesPreferences),
              trailing: Theme.of(context).platform == TargetPlatform.iOS
                  ? const CupertinoListTileChevron()
                  : null,
              onTap: () {
                pushPlatformRoute(
                  context,
                  title: context.l10n.preferencesPreferences,
                  builder: (context) => const AccountPreferencesScreen(),
                );
              },
            ),
            if (authController.isLoading)
              const PlatformListTile(
                leading: Icon(Icons.logout),
                title: Center(child: ButtonLoadingIndicator()),
              )
            else
              PlatformListTile(
                leading: const Icon(Icons.logout),
                title: Text(context.l10n.logOut),
                onTap: () {
                  _showSignOutConfirmDialog(context, ref);
                },
              ),
          ] else ...[
            if (authController.isLoading)
              const PlatformListTile(
                leading: Icon(Icons.login),
                title: Center(child: ButtonLoadingIndicator()),
              )
            else
              PlatformListTile(
                leading: const Icon(Icons.login),
                title: Text(context.l10n.signIn),
                onTap: () {
                  ref.read(authControllerProvider.notifier).signIn();
                },
              ),
          ],
          if (Theme.of(context).platform == TargetPlatform.android &&
              donateButton != null)
            donateButton,
        ],
      ),
      ListSection(
        hasLeading: true,
        showDivider: true,
        children: [
          SettingsListTile(
            icon: const Icon(Icons.music_note),
            settingsLabel: Text(context.l10n.sound),
            settingsValue: soundThemeL10n(context, generalPrefs.soundTheme),
            onTap: () {
              if (Theme.of(context).platform == TargetPlatform.android) {
                showChoicePicker(
                  context,
                  choices: SoundTheme.values,
                  selectedItem: generalPrefs.soundTheme,
                  labelBuilder: (t) => Text(soundThemeL10n(context, t)),
                  onSelectedItemChanged: (SoundTheme? value) {
                    ref
                        .read(generalPreferencesProvider.notifier)
                        .setSoundTheme(value ?? SoundTheme.standard);
                    ref.read(soundServiceProvider).changeTheme(
                          value ?? SoundTheme.standard,
                          playSound: true,
                        );
                  },
                );
              } else {
                pushPlatformRoute(
                  context,
                  title: context.l10n.sound,
                  builder: (context) => const SoundSettingsScreen(),
                );
              }
            },
          ),
          SettingsListTile(
            icon: const Icon(Icons.volume_up),
            // TODO: translate
            settingsLabel: const Text('Volume'),
            settingsValue: volumeLabel(generalPrefs.masterVolume),
            onTap: () {
              if (Theme.of(context).platform == TargetPlatform.iOS) {
                pushPlatformRoute(
                  context,
                  title: 'Volume',
                  builder: (context) => const VolumeScreen(),
                );
              } else {
                showDialog<void>(
                  context: context,
                  builder: (context) {
                    return _SettingsSliderDialog(
                      title: 'Volume',
                      value: generalPrefs.masterVolume,
                      values: kMasterVolumeValues,
                      onChangeEnd: (double value) {
                        ref
                            .read(generalPreferencesProvider.notifier)
                            .setMasterVolume(value);
                      },
                      labelBuilder: volumeLabel,
                    );
                  },
                );
              }
            },
          ),
          if (Theme.of(context).platform == TargetPlatform.android)
            androidVersionAsync.maybeWhen(
              data: (version) => version != null && version.sdkInt >= 31
                  ? SwitchSettingTile(
                      leading: const Icon(Icons.colorize),
                      title: Text(context.l10n.mobileSystemColors),
                      value: generalPrefs.systemColors,
                      onChanged: (value) {
                        ref
                            .read(generalPreferencesProvider.notifier)
                            .toggleSystemColors();
                      },
                    )
                  : const SizedBox.shrink(),
              orElse: () => const SizedBox.shrink(),
            ),
          SettingsListTile(
            icon: const Icon(Icons.brightness_medium),
            settingsLabel: Text(context.l10n.background),
            settingsValue:
                ThemeModeScreen.themeTitle(context, generalPrefs.themeMode),
            onTap: () {
              if (Theme.of(context).platform == TargetPlatform.android) {
                showChoicePicker(
                  context,
                  choices: ThemeMode.values,
                  selectedItem: generalPrefs.themeMode,
                  labelBuilder: (t) =>
                      Text(ThemeModeScreen.themeTitle(context, t)),
                  onSelectedItemChanged: (ThemeMode? value) => ref
                      .read(generalPreferencesProvider.notifier)
                      .setThemeMode(value ?? ThemeMode.system),
                );
              } else {
                pushPlatformRoute(
                  context,
                  title: context.l10n.background,
                  builder: (context) => const ThemeModeScreen(),
                );
              }
            },
          ),
          SettingsListTile(
            icon: const Icon(LichessIcons.chess_board),
            settingsLabel: Text(context.l10n.board),
            settingsValue: boardPrefs.boardTheme.label,
            onTap: () {
              pushPlatformRoute(
                context,
                title: context.l10n.board,
                builder: (context) => const BoardThemeScreen(),
              );
            },
          ),
          SettingsListTile(
            icon: const Icon(LichessIcons.chess_pawn),
            settingsLabel: Text(context.l10n.pieceSet),
            settingsValue: boardPrefs.pieceSet.label,
            onTap: () {
              pushPlatformRoute(
                context,
                title: context.l10n.pieceSet,
                builder: (context) => const PieceSetScreen(),
              );
            },
          ),
          PlatformListTile(
            leading: const Icon(Icons.gamepad),
            title: Text(context.l10n.preferencesGameBehavior),
            trailing: Theme.of(context).platform == TargetPlatform.iOS
                ? const CupertinoListTileChevron()
                : null,
            onTap: () {
              pushPlatformRoute(
                context,
                title: context.l10n.preferencesGameBehavior,
                builder: (context) => const BoardBehaviorSettingsScreen(),
              );
            },
          ),
        ],
      ),
      ListSection(
        hasLeading: true,
        showDivider: true,
        children: [
          PlatformListTile(
            leading: const Icon(Icons.info),
            title: Text(context.l10n.aboutX('Lichess')),
            trailing: const _OpenInNewIcon(),
            onTap: () {
              launchUrl(Uri.parse('https://lichess.org/about'));
            },
          ),
          PlatformListTile(
            leading: const Icon(Icons.feedback),
            title: Text(context.l10n.mobileFeedbackButton),
            trailing: const _OpenInNewIcon(),
            onTap: () {
              launchUrl(Uri.parse('https://lichess.org/contact'));
            },
          ),
          PlatformListTile(
            leading: const Icon(Icons.article),
            title: Text(context.l10n.termsOfService),
            trailing: const _OpenInNewIcon(),
            onTap: () {
              launchUrl(Uri.parse('https://lichess.org/terms-of-service'));
            },
          ),
          PlatformListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text(context.l10n.privacyPolicy),
            trailing: const _OpenInNewIcon(),
            onTap: () {
              launchUrl(Uri.parse('https://lichess.org/privacy'));
            },
          ),
        ],
      ),
      ListSection(
        hasLeading: true,
        showDivider: true,
        children: [
          PlatformListTile(
            leading: const Icon(Icons.code),
            title: Text(context.l10n.sourceCode),
            trailing: const _OpenInNewIcon(),
            onTap: () {
              launchUrl(Uri.parse('https://lichess.org/source'));
            },
          ),
          PlatformListTile(
            leading: const Icon(Icons.bug_report),
            title: Text(context.l10n.contribute),
            trailing: const _OpenInNewIcon(),
            onTap: () {
              launchUrl(Uri.parse('https://lichess.org/help/contribute'));
            },
          ),
          PlatformListTile(
            leading: const Icon(Icons.star),
            title: Text(context.l10n.thankYou),
            trailing: const _OpenInNewIcon(),
            onTap: () {
              launchUrl(Uri.parse('https://lichess.org/thanks'));
            },
          ),
        ],
      ),
      Padding(
        padding: Styles.bodySectionPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LichessMessage(style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            Text(
              'v${packageInfo.version}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ];

    return Theme.of(context).platform == TargetPlatform.iOS
        ? SliverList(delegate: SliverChildListDelegate(content))
        : ListView(children: content);
  }

  Future<void> _showSignOutConfirmDialog(BuildContext context, WidgetRef ref) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return showCupertinoActionSheet(
        context: context,
        actions: [
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.logOut),
            isDestructiveAction: true,
            onPressed: (context) async {
              await ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      );
    } else {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(context.l10n.logOut),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text(context.l10n.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text(context.l10n.mobileOkButton),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await ref.read(authControllerProvider.notifier).signOut();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class _SettingsSliderDialog extends StatefulWidget {
  const _SettingsSliderDialog({
    required this.title,
    required this.value,
    required this.values,
    required this.onChangeEnd,
    this.labelBuilder,
  });

  final String title;
  final double value;
  final List<double> values;
  final void Function(double value) onChangeEnd;
  final String Function(double)? labelBuilder;

  @override
  _SettingsSliderDialogState createState() => _SettingsSliderDialogState();
}

class _SettingsSliderDialogState extends State<_SettingsSliderDialog> {
  late int _index = widget.values.indexOf(widget.value);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider.adaptive(
                value: _index.toDouble(),
                min: 0,
                max: widget.values.length - 1,
                divisions: widget.values.length - 1,
                label: widget.labelBuilder?.call(widget.values[_index]) ??
                    widget.values[_index].toString(),
                onChanged: (double value) {
                  setState(() {
                    _index = value.toInt();
                  });
                },
                onChangeEnd: (double value) {
                  widget.onChangeEnd.call(widget.values[_index]);
                },
              ),
              Text(
                widget.labelBuilder?.call(widget.values[_index]) ??
                    widget.values[_index].toString(),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _OpenInNewIcon extends StatelessWidget {
  const _OpenInNewIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.open_in_new,
      color: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoColors.systemGrey2.resolveFrom(context)
          : null,
    );
  }
}
