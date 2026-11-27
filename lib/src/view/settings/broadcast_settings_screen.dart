import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
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
    final showEvaluationGauges = ref.watch(
      broadcastPreferencesProvider.select((prefs) => prefs.showRoundEvaluationGauges),
    );
    final favoriteFederation = ref.watch(
      accountPreferencesProvider.select((prefs) => prefs.value?.favoriteFederation),
    );

    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.broadcastBroadcasts)),
      body: ListView(
        children: [
          ListSection(
            header: SettingsSectionTitle(context.l10n.preferencesDisplay),
            children: [
              SettingsListTile(
                icon: favoriteFederation != null
                    ? Image.asset(favoriteFederation.flagAsset, height: 16)
                    : const Icon(Icons.public),
                settingsLabel: const Text('Favorite federation'),
                settingsValue: favoriteFederation?.name ?? context.l10n.none,
                onTap: () {
                  Navigator.of(context).push(BroadcastFederationChoiceScreen.buildRoute());
                },
              ),
              SwitchSettingTile(
                title: Text(context.l10n.studyShowEvalBar),
                value: showEvaluationGauges,
                onChanged: (_) =>
                    ref.read(broadcastPreferencesProvider.notifier).toggleEvaluationBar(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
