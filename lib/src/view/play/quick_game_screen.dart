import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/play/quick_game_matrix.dart';

class QuickGameScreen extends StatelessWidget {
  const QuickGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.quickPairing)),
      body: const Padding(padding: EdgeInsets.all(16.0), child: QuickGameMatrix()),
    );
  }
}
