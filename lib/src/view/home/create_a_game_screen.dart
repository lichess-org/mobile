import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/home/create_game_options.dart';
import 'package:lichess_mobile/src/view/home/quick_game_button.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class CreateAGameScreen extends StatelessWidget {
  const CreateAGameScreen();

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: _Body(),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.createAGame),
      ),
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListSection(
            header: Text(context.l10n.quickPairing),
            children: [
              Padding(
                padding: Theme.of(context).platform == TargetPlatform.android
                    ? const EdgeInsets.symmetric(horizontal: 16.0)
                    : const EdgeInsets.only(right: 2.0),
                child: const QuickGameButton(),
              ),
            ],
          ),
          const CreateGameOptions(),
        ],
      ),
    );
  }
}
