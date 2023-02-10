import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chessground/chessground.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:lichess_mobile/src/model/settings/providers.dart';

class PieceSetScreen extends StatelessWidget {
  const PieceSetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.background)),
      body: _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceSet = ref.watch(pieceSetPrefProvider);

    void onChanged(PieceSet? value) =>
        ref.read(pieceSetPrefProvider.notifier).set(value ?? PieceSet.cburnett);

    return SafeArea(
      child: ListView(
        children: [
          ChoicePicker(
            notchedTile: true,
            choices: PieceSet.values,
            selectedItem: pieceSet,
            titleBuilder: (t) => Text(t.label),
            leadingBuilder: (t) => Image(
              image: t.assets['whiteknight']!,
            ),
            onSelectedItemChanged: onChanged,
          )
        ],
      ),
    );
  }
}
