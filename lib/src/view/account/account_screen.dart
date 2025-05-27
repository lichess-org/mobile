import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/account/home_widgets.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/view/settings/account_preferences_screen.dart';
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
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountIconButton extends ConsumerStatefulWidget {
  const AccountIconButton({super.key});

  @override
  ConsumerState<AccountIconButton> createState() => _AccountIconButtonState();
}

class _AccountIconButtonState extends ConsumerState<AccountIconButton> {
  bool errorLoadingFlair = false;

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider);
    return switch (account) {
      AsyncData(:final value) => IconButton(
        tooltip: value == null ? context.l10n.signIn : value.username,
        icon: value == null
            ? const Icon(Icons.account_circle_outlined, size: 30)
            : CircleAvatar(
                radius: 16,
                foregroundImage: value.flair != null
                    ? CachedNetworkImageProvider(lichessFlairSrc(value.flair!))
                    : null,
                onForegroundImageError: value.flair != null
                    ? (error, _) {
                        setState(() {
                          errorLoadingFlair = true;
                        });
                      }
                    : null,
                backgroundColor: value.flair == null || errorLoadingFlair
                    ? null
                    : ColorScheme.of(context).surfaceContainer,
                child: value.flair == null || errorLoadingFlair ? Text(value.initials) : null,
              ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(AccountScreen.buildRoute(context));
        },
      ),
      _ => IconButton(
        icon: const Icon(Icons.account_circle_outlined, size: 30),
        tooltip: context.l10n.signIn,
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(AccountScreen.buildRoute(context));
        },
      ),
    };
  }
}

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const AccountScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generalPrefs = ref.watch(generalPreferencesProvider);
    final authController = ref.watch(authControllerProvider);
    final account = ref.watch(accountProvider);
    final userSession = ref.watch(authSessionProvider);
    final LightUser? user = account.valueOrNull?.lightUser ?? userSession?.user;
    final packageInfo = ref.read(preloadedDataProvider).requireValue.packageInfo;
    final dbSize = ref.watch(getDbSizeInBytesProvider);

    final Widget? donateButton = userSession == null || userSession.user.isPatron != true
        ? ListTile(
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
                ? const Icon(Icons.chevron_right)
                : null,
            onTap: () {
              launchUrl(Uri.parse('https://lichess.org/patron'));
            },
          )
        : null;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: user == null ? const SizedBox.shrink() : UserFullNameWidget(user: user),
        actions: const [SocketPingRating()],
      ),
      body: ListView(
        children: [
          ListSection(
            hasLeading: true,
            children: [
              if (userSession != null) ...[
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(context.l10n.profile),
                  trailing: Theme.of(context).platform == TargetPlatform.iOS
                      ? const Icon(Icons.chevron_right)
                      : null,
                  onTap: () {
                    ref.invalidate(accountActivityProvider);
                    Navigator.of(context).push(ProfileScreen.buildRoute(context));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.manage_accounts_outlined),
                  title: Text(context.l10n.preferencesPreferences),
                  trailing: Theme.of(context).platform == TargetPlatform.iOS
                      ? const Icon(Icons.chevron_right)
                      : null,
                  onTap: () {
                    Navigator.of(context).push(AccountPreferencesScreen.buildRoute(context));
                  },
                ),
                if (authController.isLoading)
                  const ListTile(
                    leading: Icon(Icons.logout_outlined),
                    title: Center(child: ButtonLoadingIndicator()),
                  )
                else
                  ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: Text(context.l10n.logOut),
                    onTap: () {
                      _showSignOutConfirmDialog(context, ref);
                    },
                  ),
              ] else ...[
                if (authController.isLoading)
                  const ListTile(
                    leading: Icon(Icons.login_outlined),
                    title: Center(child: ButtonLoadingIndicator()),
                  )
                else
                  ListTile(
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
                  settingsValue: generalPrefs.isForcedDarkMode
                      ? BackgroundThemeMode.dark.title(context.l10n)
                      : generalPrefs.themeMode.title(context.l10n),
                  onTap: generalPrefs.isForcedDarkMode
                      ? null
                      : () {
                          showChoicePicker(
                            context,
                            choices: BackgroundThemeMode.values,
                            selectedItem: generalPrefs.themeMode,
                            labelBuilder: (t) => Text(t.title(context.l10n)),
                            onSelectedItemChanged: (BackgroundThemeMode? value) => ref
                                .read(generalPreferencesProvider.notifier)
                                .setBackgroundThemeMode(value ?? BackgroundThemeMode.system),
                          );
                        },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: Text(context.l10n.mobileTheme),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const Icon(Icons.chevron_right)
                    : null,
                onTap: () {
                  Navigator.of(context).push(ThemeSettingsScreen.buildRoute(context));
                },
              ),
              ListTile(
                leading: const Icon(Icons.app_registration),
                title: const Text('Home widgets'),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const Icon(Icons.chevron_right)
                    : null,
                onTap: () {
                  // Switch to home tab
                  ref.read(currentBottomTabProvider.notifier).state = BottomTab.home;
                  // Pop all the way back to the home tab
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  // Set edit mode
                  ref.read(homeWidgetsEditModeProvider.notifier).state = true;
                },
              ),
              ListTile(
                leading: const Icon(Symbols.chess_pawn),
                title: Text(context.l10n.preferencesGameBehavior, overflow: TextOverflow.ellipsis),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const Icon(Icons.chevron_right)
                    : null,
                onTap: () {
                  Navigator.of(context).push(BoardSettingsScreen.buildRoute(context));
                },
              ),
              ListTile(
                leading: const Icon(Icons.memory_outlined),
                title: const Text('Chess engine'),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const Icon(Icons.chevron_right)
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
                      onSelectedItemChanged: (Locale? locale) =>
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
              ListTile(
                leading: const Icon(Icons.info_outlined),
                title: Text(context.l10n.aboutX('Lichess')),
                trailing: const _OpenInNewIcon(),
                onTap: () {
                  launchUrl(Uri.parse('https://lichess.org/about'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.feedback_outlined),
                title: Text(context.l10n.mobileFeedbackButton),
                trailing: const _OpenInNewIcon(),
                onTap: () {
                  launchUrl(Uri.parse('https://lichess.org/contact'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.article_outlined),
                title: Text(context.l10n.termsOfService),
                trailing: const _OpenInNewIcon(),
                onTap: () {
                  launchUrl(Uri.parse('https://lichess.org/terms-of-service'));
                },
              ),
              ListTile(
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
              ListTile(
                leading: const Icon(Icons.code_outlined),
                title: Text(context.l10n.sourceCode),
                trailing: const _OpenInNewIcon(),
                onTap: () {
                  launchUrl(Uri.parse('https://lichess.org/source'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.bug_report_outlined),
                title: Text(context.l10n.contribute),
                trailing: const _OpenInNewIcon(),
                onTap: () {
                  launchUrl(Uri.parse('https://lichess.org/help/contribute'));
                },
              ),
              ListTile(
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
              ListTile(
                leading: const Icon(Icons.storage_outlined),
                title: const Text('Local database size'),
                trailing: dbSize.hasValue ? Text(_getSizeString(dbSize.value)) : null,
              ),
              ListTile(
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
                  ListTile(
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
                  ListTile(
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
        ],
      ),
    );
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
}

class _OpenInNewIcon extends StatelessWidget {
  const _OpenInNewIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.open_in_new, size: 18);
  }
}
