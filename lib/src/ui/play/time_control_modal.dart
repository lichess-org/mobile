import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/settings/play_preferences.dart';

class TimeControlModal extends StatelessWidget {
  const TimeControlModal({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.l10n.timeControl),
        actions: [
          IconButton(
            tooltip: context.l10n.close,
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: EdgeInsetsDirectional.zero,
        automaticallyImplyLeading: false,
        middle: Text(context.l10n.timeControl),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(CupertinoIcons.clear),
        ),
      ),
      child: _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeControlPref = ref
        .watch(playPreferencesProvider.select((prefs) => prefs.timeIncrement));

    void onSelected(TimeIncrement choice) {
      Navigator.pop(context);
      ref.read(playPreferencesProvider.notifier).setTimeControl(choice);
    }

    return SafeArea(
      child: Padding(
        padding: Styles.bodyPadding,
        child: Column(
          children: [
            _SectionChoices(
              timeControlPref,
              choices: const [
                TimeIncrement(1, 0),
                TimeIncrement(2, 1),
              ],
              title: const _SectionTitle(
                title: 'Bullet',
                icon: LichessIcons.bullet,
              ),
              onSelected: onSelected,
            ),
            const SizedBox(height: 20.0),
            _SectionChoices(
              timeControlPref,
              choices: const [
                TimeIncrement(3, 0),
                TimeIncrement(3, 2),
                TimeIncrement(5, 0),
                TimeIncrement(5, 3),
              ],
              title: const _SectionTitle(
                title: 'Blitz',
                icon: LichessIcons.blitz,
              ),
              onSelected: onSelected,
            ),
            const SizedBox(height: 20.0),
            _SectionChoices(
              timeControlPref,
              choices: const [
                TimeIncrement(10, 0),
                TimeIncrement(10, 5),
                TimeIncrement(15, 10),
              ],
              title: const _SectionTitle(
                title: 'Rapid',
                icon: LichessIcons.rapid,
              ),
              onSelected: onSelected,
            ),
            const SizedBox(height: 20.0),
            _SectionChoices(
              timeControlPref,
              choices: const [
                TimeIncrement(30, 0),
                TimeIncrement(30, 20),
              ],
              title: const _SectionTitle(
                title: 'Classical',
                icon: LichessIcons.classical,
              ),
              onSelected: onSelected,
            ),
          ],
        ),
      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 10),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: choices.map((choice) {
            return _ChoiceChip(
              key: ValueKey(choice),
              label: Text(choice.display),
              selected: selected == choice,
              onSelected: (bool selected) {
                if (selected) onSelected(choice);
              },
            );
          }).toList(),
        ),
      ],
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
    final cupertinoBrightness =
        CupertinoTheme.maybeBrightnessOf(context) ?? Brightness.light;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return ChoiceChip(
          label: label,
          selected: selected,
          onSelected: onSelected,
          labelStyle: const TextStyle(fontSize: 16),
        );
      case TargetPlatform.iOS:
        return GestureDetector(
          onTap: () => onSelected(true),
          child: Container(
            decoration: BoxDecoration(
              color: cupertinoBrightness == Brightness.light
                  ? CupertinoColors.systemBackground
                  : CupertinoColors.secondarySystemBackground
                      .resolveFrom(context),
              borderRadius: BorderRadius.circular(5.0),
              border: selected
                  ? Border.all(
                      color: CupertinoColors.activeBlue.resolveFrom(context),
                      width: 2.0,
                    )
                  : Border.all(
                      color: Colors.transparent,
                      width: 2.0,
                    ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: label,
            ),
          ),
        );
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: CupertinoIconThemeData(
        color: CupertinoColors.systemGrey.resolveFrom(context),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.0),
          const SizedBox(width: 10),
          Text(
            title,
            style: _titleStyle,
          ),
        ],
      ),
    );
  }
}

const TextStyle _titleStyle = TextStyle(fontSize: 18);
