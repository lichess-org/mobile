import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/common/lichess_icons.dart';
import '../../authentication/ui/auth_widget.dart';
import './time_control_modal.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final maiaSection = [
      const Text(
        'Play with maia',
        style: TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 5),
      const Text(
          'Maia is a human-like neural network chess engine. It was trained by learning from over 10 million Lichess games. For more information go to maiachess.com.'),
      const SizedBox(height: 10),
      const MaiaChoices(),
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
              children: const [
                Text('Fairy-Stockfish 14'),
              ],
            ),
            selected: false,
            onSelected: (bool selected) {},
          ),
        ],
      ),
      const SizedBox(height: 5),
      const Slider(
        value: 2,
        min: 1,
        max: 8,
        divisions: 8,
        label: '2',
        onChanged: null,
      ),
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
                title: const Text('maia1', style: _titleStyle),
                subtitle: Row(
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

class MaiaChoices extends StatefulWidget {
  const MaiaChoices({super.key});

  @override
  State<MaiaChoices> createState() => MaiaOptionsState();
}

class MaiaOptionsState extends State<MaiaChoices> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10.0,
          children: List<Widget>.generate(
            3,
            (int index) {
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_value == index) ...[
                      const Icon(Icons.check, size: 18),
                      const SizedBox(width: 3),
                    ],
                    Text('maia${index + 1}'),
                  ],
                ),
                selected: _value == index,
                onSelected: (bool selected) {
                  if (selected) {
                    setState(() {
                      _value = index;
                    });
                  }
                },
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}

final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
  textStyle: const TextStyle(fontSize: 20),
);
const TextStyle _titleStyle = TextStyle(fontSize: 18);
