import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';

class TimeControlModal extends ConsumerWidget {
  const TimeControlModal({
    required this.value,
    required this.onSelected,
    this.excludeUltraBullet = false,
    super.key,
  });

  final TimeIncrement value;
  final ValueSetter<TimeIncrement> onSelected;

  final bool excludeUltraBullet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSelected(TimeIncrement choice) {
      Navigator.pop(context);
      this.onSelected(choice);
    }

    return BottomSheetScrollableContainer(
      padding: Styles.bodyPadding,
      children: [
        Text(context.l10n.timeControl, style: Styles.title),
        const SizedBox(height: 26.0),
        _SectionChoices(
          value,
          choices: [
            if (!excludeUltraBullet) const TimeIncrement(0, 1),
            const TimeIncrement(60, 0),
            const TimeIncrement(60, 1),
            const TimeIncrement(120, 1),
          ],
          title: const _SectionTitle(title: 'Bullet', icon: LichessIcons.bullet),
          onSelected: onSelected,
        ),
        const SizedBox(height: 20.0),
        _SectionChoices(
          value,
          choices: const [
            TimeIncrement(180, 0),
            TimeIncrement(180, 2),
            TimeIncrement(300, 0),
            TimeIncrement(300, 3),
          ],
          title: const _SectionTitle(title: 'Blitz', icon: LichessIcons.blitz),
          onSelected: onSelected,
        ),
        const SizedBox(height: 20.0),
        _SectionChoices(
          value,
          choices: const [
            TimeIncrement(600, 0),
            TimeIncrement(600, 5),
            TimeIncrement(900, 0),
            TimeIncrement(900, 10),
          ],
          title: const _SectionTitle(title: 'Rapid', icon: LichessIcons.rapid),
          onSelected: onSelected,
        ),
        const SizedBox(height: 20.0),
        _SectionChoices(
          value,
          choices: const [
            TimeIncrement(1500, 0),
            TimeIncrement(1800, 0),
            TimeIncrement(1800, 20),
            TimeIncrement(3600, 0),
          ],
          title: const _SectionTitle(title: 'Classical', icon: LichessIcons.classical),
          onSelected: onSelected,
        ),
        const SizedBox(height: 20.0),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: _SectionTitle(title: context.l10n.custom, icon: Icons.tune),
            tilePadding: EdgeInsets.zero,
            minTileHeight: 0,
            children: [
              Builder(
                builder: (context) {
                  TimeIncrement custom = value;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: NonLinearSlider(
                                  value: custom.time,
                                  values: kAvailableTimesInSeconds,
                                  labelBuilder: clockLabelInMinutes,
                                  onChange:
                                      Theme.of(context).platform == TargetPlatform.iOS
                                          ? (num value) {
                                            setState(() {
                                              custom = TimeIncrement(
                                                value.toInt(),
                                                custom.increment,
                                              );
                                            });
                                          }
                                          : null,
                                  onChangeEnd: (num value) {
                                    setState(() {
                                      custom = TimeIncrement(value.toInt(), custom.increment);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: Center(
                                  child: Text(
                                    custom.display,
                                    style: Styles.timeControl.merge(Styles.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: NonLinearSlider(
                                  value: custom.increment,
                                  values: kAvailableIncrementsInSeconds,
                                  onChange:
                                      Theme.of(context).platform == TargetPlatform.iOS
                                          ? (num value) {
                                            setState(() {
                                              custom = TimeIncrement(custom.time, value.toInt());
                                            });
                                          }
                                          : null,
                                  onChangeEnd: (num value) {
                                    setState(() {
                                      custom = TimeIncrement(custom.time, value.toInt());
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SecondaryButton(
                            onPressed: custom.isInfinite ? null : () => onSelected(custom),
                            semanticsLabel: 'OK',
                            child: Text(context.l10n.mobileOkButton, style: Styles.bold),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionChoices extends StatelessWidget {
  const _SectionChoices(
    this.selected, {
    required this.title,
    required this.choices,
    required this.onSelected,
  });

  final TimeIncrement selected;
  final List<TimeIncrement> choices;
  final _SectionTitle title;
  final void Function(TimeIncrement choice) onSelected;

  @override
  Widget build(BuildContext context) {
    final choiceWidgets =
        choices
            .mapIndexed((index, choice) {
              return [
                Expanded(
                  child: _ChoiceChip(
                    key: ValueKey(choice),
                    label: Text(choice.paddedDisplay, style: Styles.bold),
                    selected: selected == choice,
                    onSelected: (bool selected) {
                      if (selected) onSelected(choice);
                    },
                  ),
                ),
                if (index < choices.length - 1) const SizedBox(width: 10),
              ];
            })
            .flattened
            .toList();

    if (choices.length < 4) {
      final placeHolders = [
        const [SizedBox(width: 10)],
        for (int i = choices.length; i < 4; i++)
          [const Expanded(child: SizedBox(width: 10)), if (i < 3) const SizedBox(width: 10)],
      ];
      choiceWidgets.addAll(placeHolders.flattened);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [title, const SizedBox(height: 10), Row(children: choiceWidgets)],
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final Widget label;
  final bool selected;
  final void Function(bool selected) onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: DefaultTextStyle.merge(
        style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
        child: label,
      ),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: false,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: CupertinoIconThemeData(color: CupertinoColors.systemGrey.resolveFrom(context)),
      child: Row(
        children: [
          Icon(icon, size: 20.0),
          const SizedBox(width: 10),
          Text(title, style: _titleStyle),
        ],
      ),
    );
  }
}

const TextStyle _titleStyle = TextStyle(fontSize: 16);
