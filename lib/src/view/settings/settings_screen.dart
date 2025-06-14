import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/home/home_tab_screen.dart';
import 'package:lichess_mobile/src/view/settings/board_settings_screen.dart';
import 'package:lichess_mobile/src/view/settings/engine_settings_screen.dart';
import 'package:lichess_mobile/src/view/settings/http_log_screen.dart';
import 'package:lichess_mobile/src/view/settings/sound_settings_screen.dart';
import 'package:lichess_mobile/src/view/settings/theme_settings_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const SettingsScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generalPrefs = ref.watch(generalPreferencesProvider);
    final packageInfo = ref.read(preloadedDataProvider).requireValue.packageInfo;
    final userSession = ref.watch(authSessionProvider);
    final dbSize = ref.watch(getDbSizeInBytesProvider);

    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.settingsSettings)),
      body: ListView(
        children: [
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
                title: Text(context.l10n.mobileSettingsHomeWidgets),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const Icon(Icons.chevron_right)
                    : null,
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(HomeTabScreen.buildRoute(context, editModeEnabled: true));
                },
              ),
              ListTile(
                leading: const Icon(Symbols.chess_pawn),
                title: Text(context.l10n.mobileBoardSettings, overflow: TextOverflow.ellipsis),
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
                leading: const Icon(Symbols.database),
                title: Text(context.l10n.database),
                trailing: const _OpenInNewIcon(),
                onTap: () {
                  launchUrl(Uri.parse('https://database.lichess.org'));
                },
              ),
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
            child: Text('v${packageInfo.version}', style: TextTheme.of(context).bodySmall),
          ),
        ],
      ),
    );
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
