import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/utils/lichess_icons.dart';

class TimeControlModal extends StatefulWidget {
  const TimeControlModal({super.key});

  @override
  State<TimeControlModal> createState() => TimeControlChoices();
}

class TimeControlChoices extends State<TimeControlModal> {
  int _value = 0;

  void onSelected(int value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Time control')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionChoices(_value,
                title: const _SectionTitle(
                    title: 'Blitz', icon: LichessIcons.blitz),
                numberOfElements: 4,
                startAtIndex: 0,
                onSelected: onSelected),
            _SectionChoices(_value,
                title: const _SectionTitle(
                    title: 'Rapid', icon: LichessIcons.rapid),
                numberOfElements: 3,
                startAtIndex: 4,
                onSelected: onSelected),
            _SectionChoices(_value,
                title: const _SectionTitle(
                    title: 'Classical', icon: LichessIcons.classical),
                numberOfElements: 2,
                startAtIndex: 7,
                onSelected: onSelected),
          ],
        ),
      ),
    );
  }
}

class _SectionChoices extends StatelessWidget {
  const _SectionChoices(this.selected,
      {required this.title,
      required this.numberOfElements,
      required this.startAtIndex,
      required this.onSelected});

  final int selected;
  final _SectionTitle title;
  final int numberOfElements;
  final int startAtIndex;
  final void Function(int index) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 10),
        Wrap(
          spacing: 10.0,
          children: List<Widget>.generate(
            numberOfElements,
            (int index) {
              return ChoiceChip(
                label: Text(timeControls[index + startAtIndex].toString()),
                selected: selected == index + startAtIndex,
                onSelected: (bool selected) {
                  if (selected) onSelected(index + startAtIndex);
                },
                labelStyle: const TextStyle(fontSize: 16),
                labelPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              );
            },
          ).toList(),
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20.0),
        const SizedBox(width: 10),
        Text(
          title,
          style: _titleStyle,
        ),
      ],
    );
  }
}

const TextStyle _titleStyle = TextStyle(fontSize: 18);

@immutable
class TimeControl {
  const TimeControl(this.time, this.increment);
  final int time;
  final int increment;

  @override
  toString() => '$time + $increment';
}

const timeControls = [
  TimeControl(3, 0),
  TimeControl(3, 2),
  TimeControl(5, 0),
  TimeControl(5, 3),
  TimeControl(10, 0),
  TimeControl(10, 5),
  TimeControl(15, 10),
  TimeControl(30, 0),
  TimeControl(30, 20),
];
