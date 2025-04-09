import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/play/create_game_options.dart';
import 'package:lichess_mobile/src/view/play/playban.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class PlayScreen extends ConsumerWidget {
  const PlayScreen();

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const PlayScreen(), title: context.l10n.play);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playban = ref.watch(accountProvider).valueOrNull?.playban;

    return PlatformScaffold(
      appBarTitle: Text(context.l10n.play),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            if (playban != null)
              Padding(padding: Styles.bodySectionPadding, child: PlaybanMessage(playban: playban)),
            const CreateGameOptions(),
          ],
        ),
      ),
    );
  }
}
