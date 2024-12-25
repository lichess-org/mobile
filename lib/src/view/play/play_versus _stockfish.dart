import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class PlayStockfishScreen extends StatelessWidget {
  const PlayStockfishScreen();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(context.l10n.playWithTheMachine),
      ),
      body: const Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body();

  @override
  State<Body> createState() => BodyState();
}

class BodyState extends State<Body> {
  double aiLevel = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
          ),
          Text(
            context.l10n.aiNameLevelAiLevel('Stockfish', aiLevel.toInt().toString()),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Slider(
            value: aiLevel,
            label: aiLevel.toInt().toString(),
            min: 1,
            max: 8,
            divisions: 7,
            onChanged: (newValue) {
              setState(() {
                aiLevel = newValue;
              });
            },
          ),
          FilledButton(
            onPressed: () {},
            child: Text(
              context.l10n.play,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
