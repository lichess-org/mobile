import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/play/create_game_options.dart';
import 'package:lichess_mobile/src/view/play/quick_game_button.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen();

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const PlayScreen(), title: context.l10n.play);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.play)),
      body: const SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: Styles.horizontalBodyPadding, child: QuickGameButton()),
            CreateGameOptions(),
          ],
        ),
      ),
    );
  }
}
