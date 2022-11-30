import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/lichess_icons.dart';
import './providers.dart';

class TimeControlModal extends ConsumerWidget {
  const TimeControlModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeControlPref = ref.watch(timeControlPrefProvider);
    void onSelected(TimeControl choice) {
      Navigator.pop(context);
      ref.read(timeControlPrefProvider.notifier).set(choice);
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _SectionChoices(timeControlPref,
              choices: const [
                TimeControl.blitz1,
                TimeControl.blitz2,
                TimeControl.blitz3,
                TimeControl.blitz4
              ],
              title:
                  const _SectionTitle(title: 'Blitz', icon: LichessIcons.blitz),
              onSelected: onSelected),
          const SizedBox(height: 30.0),
          _SectionChoices(timeControlPref,
              choices: const [
                TimeControl.rapid1,
                TimeControl.rapid2,
                TimeControl.rapid3
              ],
              title:
                  const _SectionTitle(title: 'Rapid', icon: LichessIcons.rapid),
              onSelected: onSelected),
          const SizedBox(height: 30.0),
          _SectionChoices(timeControlPref,
              choices: const [TimeControl.classical1, TimeControl.classical2],
              title: const _SectionTitle(
                  title: 'Classical', icon: LichessIcons.classical),
              onSelected: onSelected),
        ],
      ),
    );
  }
}

class _SectionChoices extends StatelessWidget {
  const _SectionChoices(this.selected,
      {required this.title, required this.choices, required this.onSelected});

  final TimeControl selected;
  final List<TimeControl> choices;
  final _SectionTitle title;
  final void Function(TimeControl choice) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 10),
        Wrap(
          spacing: 10.0,
          children: choices.map((choice) {
            return ChoiceChip(
              label: Text(choice.value.toString()),
              selected: selected == choice,
              onSelected: (bool selected) {
                if (selected) onSelected(choice);
              },
              labelStyle: const TextStyle(fontSize: 16),
              labelPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            );
          }).toList(),
        ),
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
