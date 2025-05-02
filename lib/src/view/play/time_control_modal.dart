import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

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

  static const _horizontalPadding = EdgeInsets.symmetric(horizontal: 16.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSelected(TimeIncrement choice) {
      Navigator.pop(context);
      this.onSelected(choice);
    }

    return BottomSheetScrollableContainer(
      children: [
        Padding(padding: _horizontalPadding, child: SettingsSectionTitle(context.l10n.timeControl)),
        const SizedBox(height: 4.0),
        Card.filled(
          margin: Styles.horizontalBodyPadding.add(Styles.sectionBottomPadding),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
              ],
            ),
          ),
        ),
        Card.filled(
          margin: _horizontalPadding.add(Styles.sectionBottomPadding),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
            child: Theme(
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
                                      onChange: (num value) {
                                        setState(() {
                                          custom = TimeIncrement(value.toInt(), custom.increment);
                                        });
                                      },
                                      onChangeEnd: (num value) {
                                        setState(() {
                                          custom = TimeIncrement(value.toInt(), custom.increment);
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: Center(
                                      child: Text(
                                        clockLabelInMinutes(custom.time),
                                        style: Styles.timeControl.merge(Styles.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Row(
                                children: [
                                  Spacer(),
                                  SizedBox(width: 60, child: Center(child: Text('+'))),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: NonLinearSlider(
                                      value: custom.increment,
                                      values: kAvailableIncrementsInSeconds,
                                      onChange: (num value) {
                                        setState(() {
                                          custom = TimeIncrement(custom.time, value.toInt());
                                        });
                                      },
                                      onChangeEnd: (num value) {
                                        setState(() {
                                          custom = TimeIncrement(custom.time, value.toInt());
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: Center(
                                      child: Text(
                                        custom.increment.toString(),
                                        style: Styles.timeControl.merge(Styles.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              FilledButton(
                                onPressed: custom.isInfinite ? null : () => onSelected(custom),
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

  static const spacing = SizedBox(width: 8.0);

  @override
  Widget build(BuildContext context) {
    final choiceWidgets =
        choices
            .mapIndexed((index, choice) {
              return [
                Expanded(
                  child: _ChoiceChip(
                    key: ValueKey(choice),
                    label: Text(choice.display, style: Styles.bold),
                    selected: selected == choice,
                    onSelected: (bool selected) {
                      if (selected) onSelected(choice);
                    },
                  ),
                ),
                if (index < choices.length - 1) spacing,
              ];
            })
            .flattened
            .toList();

    if (choices.length < 4) {
      final placeHolders = [
        const [SizedBox(width: 10)],
        for (int i = choices.length; i < 4; i++)
          [const Expanded(child: spacing), if (i < 3) spacing],
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
    return Container(
      decoration: BoxDecoration(
        color:
            selected
                ? ColorScheme.of(context).primaryContainer
                : ColorScheme.of(context).surfaceContainerLow,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        border: Border.fromBorderSide(
          BorderSide(
            color: selected ? ColorScheme.of(context).primary : Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        onTap: () => onSelected(true),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Center(
            child: DefaultTextStyle.merge(
              style: Styles.timeControl.copyWith(
                color:
                    selected
                        ? ColorScheme.of(context).onPrimaryContainer
                        : ColorScheme.of(context).onSurfaceVariant,
              ),
              child: label,
            ),
          ),
        ),
      ),
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
        Text(title, style: _titleStyle),
      ],
    );
  }
}

const TextStyle _titleStyle = TextStyle(fontSize: 16);
