import 'package:chessground/chessground.dart' as cg;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/piece_set_provider.dart';

import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

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
      appBar: AppBar(title: Text(context.l10n.pieceSet)),
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
    void onTap(cg.PieceSet pieceSet) {
      ref.read(pieceSetProvider.notifier).changePieceSet(pieceSet);

      Navigator.pop(context);
    }

    ListTile getListItem(cg.PieceSet pieceSet) {
      final asset = AssetImage(pieceSet.assets['whiteknight']?.keyName ?? '');

      return ListTile(
        leading: Image(
          image: asset,
          errorBuilder: (context, o, st) => const SizedBox.shrink(),
        ),
        title: Text(pieceSet.label),
        onTap: () => onTap(pieceSet),
      );
    }

    return ListView(
      children: cg.PieceSet.values.map(getListItem).asList(),
    );
  }
}
