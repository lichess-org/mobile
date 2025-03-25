import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/view/settings/account_preferences_screen.dart';
import 'package:lichess_mobile/src/view/settings/app_background_mode_screen.dart';
import 'package:lichess_mobile/src/view/settings/board_settings_screen.dart';
import 'package:lichess_mobile/src/view/settings/engine_settings_screen.dart';
import 'package:lichess_mobile/src/view/settings/http_log_screen.dart';
import 'package:lichess_mobile/src/view/settings/sound_settings_screen.dart';
import 'package:lichess_mobile/src/view/settings/theme_settings_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:url_launcher/url_launcher.dart';

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
        appBar: AppBar(title: Text(context.l10n.settingsSettings)),
        body: SafeArea(child: _Body()),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        controller: settingsScrollController,
        slivers: [
          CupertinoSliverNavigationBar(largeTitle: Text(context.l10n.settingsSettings)),
          SliverSafeArea(top: false, sliver: _Body()),
        ],
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(currentBottomTabProvider, (prev, current) {
      if (prev != BottomTab.settings && current == BottomTab.settings) {
        _refreshData(ref);
      }
    });

    final generalPrefs = ref.watch(generalPreferencesProvider);
    final authController = ref.watch(authControllerProvider);
    final userSession = ref.watch(authSessionProvider);
    final packageInfo = ref.read(preloadedDataProvider).requireValue.packageInfo;
    final dbSize = ref.watch(getDbSizeInBytesProvider);

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
              trailing:
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? const CupertinoListTileChevron()
                      : null,
              onTap: () {
                launchUrl(Uri.parse('https://lichess.org/patron'));
              },
            )
            : null;

    final List<Widget> content = [
      ListSection(
        header: userSession != null ? UserFullNameWidget(user: userSession.user) : null,
        hasLeading: true,
        children: [
          if (userSession != null) ...[
            PlatformListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(context.l10n.profile),
              trailing:
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? const CupertinoListTileChevron()
                      : null,
              onTap: () {
                ref.invalidate(accountActivityProvider);
                Navigator.of(context).push(ProfileScreen.buildRoute(context));
              },
            ),
            PlatformListTile(
              leading: const Icon(Icons.manage_accounts_outlined),
              title: Text(context.l10n.preferencesPreferences),
              trailing:
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? const CupertinoListTileChevron()
                      : null,
              onTap: () {
                Navigator.of(context).push(AccountPreferencesScreen.buildRoute(context));
              },
            ),
            if (authController.isLoading)
              const PlatformListTile(
                leading: Icon(Icons.logout_outlined),
                title: Center(child: ButtonLoadingIndicator()),
              )
            else
              PlatformListTile(
                leading: const Icon(Icons.logout_outlined),
                title: Text(context.l10n.logOut),
                onTap: () {
                  _showSignOutConfirmDialog(context, ref);
                },
              ),
          ] else ...[
            if (authController.isLoading)
              const PlatformListTile(
                leading: Icon(Icons.login_outlined),
                title: Center(child: ButtonLoadingIndicator()),
              )
            else
              PlatformListTile(
                leading: const Icon(Icons.login_outlined),
                title: Text(context.l10n.signIn),
                onTap: () {
                  ref.read(authControllerProvider.notifier).signIn();
                },
              ),
          ],
          if (Theme.of(context).platform == TargetPlatform.android && donateButton != null)
            donateButton,
        ],
      ),
      ListSection(
        hasLeading: true,
        children: [
          SettingsListTile(
            icon: const Icon(Icons.music_note_outlined),
            settingsLabel: Text(context.l10n.sound),
            settingsValue:
                '${soundThemeL10n(context, generalPrefs.soundTheme)} (${volumeLabel(generalPrefs.masterVolume)})',
            onTap: () {
              Navigator.of(context).push(SoundSettingsScreen.buildRoute(context));
            },
          ),
          Opacity(
            opacity: generalPrefs.isForcedDarkMode ? 0.5 : 1.0,
            child: SettingsListTile(
              icon: const Icon(Icons.brightness_medium_outlined),
              settingsLabel: Text(context.l10n.background),
              settingsValue: AppBackgroundModeScreen.themeTitle(
                context,
                generalPrefs.isForcedDarkMode ? BackgroundThemeMode.dark : generalPrefs.themeMode,
              ),
              onTap:
                  generalPrefs.isForcedDarkMode
                      ? null
                      : () {
                        if (Theme.of(context).platform == TargetPlatform.android) {
                          showChoicePicker(
                            context,
                            choices: BackgroundThemeMode.values,
                            selectedItem: generalPrefs.themeMode,
                            labelBuilder:
                                (t) => Text(AppBackgroundModeScreen.themeTitle(context, t)),
                            onSelectedItemChanged:
                                (BackgroundThemeMode? value) => ref
                                    .read(generalPreferencesProvider.notifier)
                                    .setBackgroundThemeMode(value ?? BackgroundThemeMode.system),
                          );
                        } else {
                          Navigator.of(context).push(AppBackgroundModeScreen.buildRoute(context));
                        }
                      },
            ),
          ),
          PlatformListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(context.l10n.mobileTheme),
            trailing:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
            onTap: () {
              Navigator.of(context).push(ThemeSettingsScreen.buildRoute(context));
            },
          ),
          PlatformListTile(
            leading: const Icon(LichessIcons.chess_pawn),
            title: Text(context.l10n.preferencesGameBehavior, overflow: TextOverflow.ellipsis),
            trailing:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
            onTap: () {
              Navigator.of(context).push(BoardSettingsScreen.buildRoute(context));
            },
          ),
          PlatformListTile(
            leading: const Icon(Icons.memory_outlined),
            title: const Text('Engine'),
            trailing:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
            onTap: () {
              Navigator.of(context).push(EngineSettingsScreen.buildRoute(context));
            },
          ),
          SettingsListTile(
            icon: const Icon(Icons.language_outlined),
            settingsLabel: Text(context.l10n.language),
            settingsValue: localeToLocalizedName(
              generalPrefs.locale ?? Localizations.localeOf(context),
            ),
            onTap: () {
              if (Theme.of(context).platform == TargetPlatform.android) {
                showChoicePicker<Locale>(
                  context,
                  choices: AppLocalizations.supportedLocales,
                  selectedItem: generalPrefs.locale ?? Localizations.localeOf(context),
                  labelBuilder: (t) => Text(localeToLocalizedName(t)),
                  onSelectedItemChanged:
                      (Locale? locale) =>
                          ref.read(generalPreferencesProvider.notifier).setLocale(locale),
                );
              } else {
                AppSettings.openAppSettings();
              }
            },
          ),
        ],
      ),
      ListSection(
        hasLeading: true,
        children: [
          PlatformListTile(
            leading: const Icon(Icons.info_outlined),
            title: Text(context.l10n.aboutX('Lichess')),
            trailing: const _OpenInNewIcon(),
            onTap: () {
              launchUrl(Uri.parse('https://lichess.org/about'));
            },
          ),
          PlatformListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: Text(context.l10n.mobileFeedbackButton),
            trailing: const _OpenInNewIcon(),
            onTap: () {
              launchUrl(Uri.parse('https://lichess.org/contact'));
            },
          ),
          PlatformListTile(
            leading: const Icon(Icons.article_outlined),
            title: Text(context.l10n.termsOfService),
            trailing: const _OpenInNewIcon(),
            onTap: () {
              launchUrl(Uri.parse('https://lichess.org/terms-of-service'));
            },
          ),
          PlatformListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
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
        children: [
          PlatformListTile(
            leading: const Icon(Icons.code_outlined),
            title: Text(context.l10n.sourceCode),
            trailing: const _OpenInNewIcon(),
            onTap: () {
              launchUrl(Uri.parse('https://lichess.org/source'));
            },
          ),
          PlatformListTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: Text(context.l10n.contribute),
            trailing: const _OpenInNewIcon(),
            onTap: () {
              launchUrl(Uri.parse('https://lichess.org/help/contribute'));
            },
          ),
          PlatformListTile(
            leading: const Icon(Icons.star_border_outlined),
            title: Text(context.l10n.thankYou),
            trailing: const _OpenInNewIcon(),
            onTap: () {
              launchUrl(Uri.parse('https://lichess.org/thanks'));
            },
          ),
        ],
      ),
      ListSection(
        hasLeading: true,
        children: [
          PlatformListTile(
            leading: const Icon(Icons.storage_outlined),
            title: const Text('Local database size'),
            subtitle:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? null
                    : Text(_getSizeString(dbSize.value)),
            additionalInfo: dbSize.hasValue ? Text(_getSizeString(dbSize.value)) : null,
          ),
          PlatformListTile(
            leading: const Icon(Icons.http),
            title: const Text('HTTP logs'),
            onTap: () => Navigator.push(context, HttpLogScreen.buildRoute(context)),
          ),
        ],
      ),
      if (userSession != null)
        ListSection(
          hasLeading: true,
          children: [
            if (Theme.of(context).platform == TargetPlatform.iOS)
              PlatformListTile(
                leading: Icon(Icons.dangerous_outlined, color: context.lichessColors.error),
                title: Text(
                  'Delete your account',
                  style: TextStyle(color: context.lichessColors.error),
                ),
                trailing: const _OpenInNewIcon(),
                onTap: () {
                  launchUrl(lichessUri('/account/delete'));
                },
              )
            else
              PlatformListTile(
                leading: Icon(Icons.dangerous_outlined, color: context.lichessColors.error),
                title: Text(
                  context.l10n.settingsCloseAccount,
                  style: TextStyle(color: context.lichessColors.error),
                ),
                trailing: const _OpenInNewIcon(),
                onTap: () {
                  launchUrl(lichessUri('/account/close'));
                },
              ),
          ],
        ),
      Padding(
        padding: Styles.bodySectionPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LichessMessage(style: TextTheme.of(context).bodyMedium),
            const SizedBox(height: 10),
            Text('v${packageInfo.version}', style: TextTheme.of(context).bodySmall),
          ],
        ),
      ),
    ];

    return Theme.of(context).platform == TargetPlatform.iOS
        ? SliverList(delegate: SliverChildListDelegate(content))
        : ListView(controller: settingsScrollController, children: content);
  }

  Future<void> _showSignOutConfirmDialog(BuildContext context, WidgetRef ref) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return showCupertinoActionSheet(
        context: context,
        actions: [
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.logOut),
            isDestructiveAction: true,
            onPressed: () async {
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
                style: TextButton.styleFrom(textStyle: TextTheme.of(context).labelLarge),
                child: Text(context.l10n.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(textStyle: TextTheme.of(context).labelLarge),
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

  String _getSizeString(int? bytes) => '${_bytesToMB(bytes ?? 0).toStringAsFixed(2)}MB';

  double _bytesToMB(int bytes) => bytes * 0.000001;

  void _refreshData(WidgetRef ref) {
    ref.invalidate(getDbSizeInBytesProvider);
  }
}

class _OpenInNewIcon extends StatelessWidget {
  const _OpenInNewIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.open_in_new,
      size: 18,
      color:
          Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoColors.systemGrey2.resolveFrom(context)
              : null,
    );
  }
}
