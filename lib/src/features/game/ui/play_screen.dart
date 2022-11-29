import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/shared_preferences.dart';
import '../../authentication/ui/auth_widget.dart';
import './time_control_modal.dart';

enum ComputerOpponent {
  maia1,
  maia5,
  maia9,
  stockfish,
}

final computerOpponentPrefProvider = createPrefProvider(
  prefKey: 'play.computerOpponent',
  defaultValue: ComputerOpponent.maia1,
  mapFrom: (v) => ComputerOpponent.values.firstWhere((e) => e.toString() == v,
      orElse: () => ComputerOpponent.maia1),
  mapTo: (v) => v.toString(),
);

final stockfishLevelProvider = createPrefProvider(
  prefKey: 'play.stockfishLevel',
  defaultValue: 1,
);

const opponentChoices = [
  ComputerOpponent.maia1,
  ComputerOpponent.maia5,
  ComputerOpponent.maia9,
  ComputerOpponent.stockfish,
];

class PlayScreen extends ConsumerWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opponentPref = ref.watch(computerOpponentPrefProvider);
    final stockfishLevel = ref.watch(stockfishLevelProvider);

    final maiaSection = [
      const Text(
        'Play with maia',
        style: TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 5),
      const Text(
          'Maia is a human-like neural network chess engine. It was trained by learning from over 10 million Lichess games. For more information go to maiachess.com.'),
      const SizedBox(height: 10),
      Wrap(
        spacing: 10.0,
        children: opponentChoices.sublist(0, 3).map((opponent) {
          final isSelected = opponentPref == opponent;
          return ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  const Icon(Icons.check, size: 18),
                  const SizedBox(width: 3),
                ],
                Text(opponent.name),
              ],
            ),
            selected: isSelected,
            onSelected: (bool selected) {
              if (selected) {
                ref.read(computerOpponentPrefProvider.notifier).set(opponent);
              }
            },
          );
        }).toList(),
      ),
    ];

    final stockfishSection = [
      const Text(
        'Play with the computer',
        style: TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 10),
      Wrap(
        children: [
          ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (opponentPref == ComputerOpponent.stockfish) ...[
                  const Icon(Icons.check, size: 18),
                  const SizedBox(width: 3),
                ],
                const Text('Fairy-Stockfish 14'),
              ],
            ),
            selected: opponentPref == ComputerOpponent.stockfish,
            onSelected: (bool selected) {
              if (selected) {
                ref
                    .read(computerOpponentPrefProvider.notifier)
                    .set(ComputerOpponent.stockfish);
              }
            },
          ),
        ],
      ),
      const SizedBox(height: 5),
      Builder(builder: (BuildContext context) {
        int value = stockfishLevel;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Slider(
            value: value.toDouble(),
            min: 1,
            max: 8,
            divisions: 8,
            label: 'Level $value',
            onChanged: opponentPref != ComputerOpponent.stockfish
                ? null
                : (double newVal) {
                    setState(() {
                      value = newVal.round();
                    });
                  },
            onChangeEnd: (double value) {
              ref.read(stockfishLevelProvider.notifier).set(value.round());
            },
          );
        });
      }),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('lichess.org'), actions: const [
        AuthWidget(),
      ]),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: [
            ...maiaSection,
            const SizedBox(height: 20),
            ...stockfishSection,
            const SizedBox(height: 20),
            Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                title: opponentPref == ComputerOpponent.stockfish
                    ? const Text('Fairy-Stockfish 14')
                    : Text(opponentPref.name, style: _titleStyle),
                subtitle: opponentPref == ComputerOpponent.stockfish
                    ? Text('Level $stockfishLevel')
                    : Row(
                        children: [1642, 1516, 1446].map((r) {
                          return Row(children: [
                            const Icon(LichessIcons.rapid, size: 14.0),
                            const SizedBox(width: 3.0),
                            Text(r.toString()),
                            const SizedBox(width: 12.0),
                          ]);
                        }).toList(),
                      ),
              ),
            ),
            const SizedBox(height: 5),
            OutlinedButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return const TimeControlModal();
                  },
                );
              },
              style: _buttonStyle,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(LichessIcons.blitz, size: 20),
                          SizedBox(width: 5),
                          Text('5 + 3')
                        ],
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 28.0),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: _buttonStyle,
              child: const Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}

final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
  textStyle: const TextStyle(fontSize: 20),
);
const TextStyle _titleStyle = TextStyle(fontSize: 18);
