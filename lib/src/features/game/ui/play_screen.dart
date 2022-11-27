import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/utils/lichess_icons.dart';
import '../../authentication/ui/auth_widget.dart';
import './time_control_modal.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('lichess.org'), actions: const [
        AuthWidget(),
      ]),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Play against maia',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 5),
              const Text(
                  'Maia is a human-like neural network chess engine. It was trained by learning from over 10 million Lichess games. Maia Chess is an ongoing research project aiming to make a more human-friendly, useful, and fun chess AI. For more information go to maiachess.com.'),
              const SizedBox(height: 15),
              const MaiaChoices(),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => const TimeControlModal(),
                      fullscreenDialog: true,
                    ),
                  );
                },
                style: buttonStyle,
                child: Row(
                  children: const [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 28.0),
                        child: Text('5 | 3', textAlign: TextAlign.center),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, size: 28.0),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: buttonStyle,
                child: const Text('Play'),
              ),
            ],
          ),
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
  int? _value = 0;

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
                label: Text('maia${index + 1}'),
                selected: _value == index,
                onSelected: (bool selected) {
                  setState(() {
                    _value = selected ? index : null;
                  });
                },
              );
            },
          ).toList(),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Center(
            child: ListTile(
              title: const Text('maia1', style: titleStyle),
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
        ),
      ],
    );
  }
}

final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  textStyle: const TextStyle(fontSize: 20),
);

const TextStyle titleStyle = TextStyle(fontSize: 18);
const TextStyle textStyle = TextStyle(fontSize: 16);
