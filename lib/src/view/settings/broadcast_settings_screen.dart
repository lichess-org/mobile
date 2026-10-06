import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_federation.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/settings/broadcast_federation_choice_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:material_ui/material_ui.dart';

class const BroadcastSettingsScreen({super.key}) extends ConsumerWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const BroadcastSettingsScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcastPrefs = ref.watch(broadcastPreferencesProvider);
    final federation = broadcastPrefs.broadcastFederationCode;
    final federationName = federation?.name ?? context.l10n.none;

    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.broadcastBroadcasts)),
      body: ListView(
        children: [
          ListSection(
            header: const SettingsSectionTitle('Favorite federation'),
            children: [
              SettingsListTile(
                icon: federation != null
                    ? Image.asset(federation.flagAsset, height: 16)
                    : const Icon(Icons.public),
                settingsLabel: Text(context.l10n.broadcastFederation),
                settingsValue: federationName,
                onTap: () {
                  Navigator.of(context).push(BroadcastFederationChoiceScreen.buildRoute());
                },
              ),
              SwitchSettingTile(
                title: const Text('Display games first'),
                value: broadcastPrefs.displayFederationGamesFirst,
                onChanged: federation != null
                    ? (value) => ref
                          .read(broadcastPreferencesProvider.notifier)
                          .setDisplayFederationGamesFirst(value)
                    : null,
              ),
            ],
          ),
          ListSection(
            header: SettingsSectionTitle(context.l10n.preferencesDisplay),
            children: [
              SwitchSettingTile(
                title: Text(context.l10n.studyShowEvalBar),
                value: broadcastPrefs.showRoundEvaluationGauges,
                onChanged: (value) =>
                    ref.read(broadcastPreferencesProvider.notifier).toggleEvaluationBar(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
