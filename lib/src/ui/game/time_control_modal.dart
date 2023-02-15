import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/model/board/play_preferences.dart';

class DefaultGameClockModal extends StatelessWidget {
  const DefaultGameClockModal({super.key});

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
    final timeControlPref = ref.watch(timeControlPrefProvider);
    void onSelected(DefaultGameClock choice) {
      Navigator.pop(context);
      ref.read(timeControlPrefProvider.notifier).set(choice);
    }

    return SafeArea(
      child: Padding(
        padding: Styles.bodyPadding,
        child: Column(
          children: [
            _SectionChoices(
              timeControlPref,
              choices: const [
                DefaultGameClock.blitz3_0,
                DefaultGameClock.blitz3_2,
                DefaultGameClock.blitz5_0,
                DefaultGameClock.blitz5_3
              ],
              title: const _SectionTitle(
                title: 'Blitz',
                icon: LichessIcons.blitz,
              ),
              onSelected: onSelected,
            ),
            const SizedBox(height: 30.0),
            _SectionChoices(
              timeControlPref,
              choices: const [
                DefaultGameClock.rapid10_0,
                DefaultGameClock.rapid10_5,
                DefaultGameClock.rapid15_10
              ],
              title: const _SectionTitle(
                title: 'Rapid',
                icon: LichessIcons.rapid,
              ),
              onSelected: onSelected,
            ),
            const SizedBox(height: 30.0),
            _SectionChoices(
              timeControlPref,
              choices: const [
                DefaultGameClock.classical30_0,
                DefaultGameClock.classical30_20
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

  final DefaultGameClock selected;
  final List<DefaultGameClock> choices;
  final _SectionTitle title;
  final void Function(DefaultGameClock choice) onSelected;

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
            return ChoiceChip(
              key: ValueKey(choice),
              label: Text(choice.value.display),
              selected: selected == choice,
              onSelected: (bool selected) {
                if (selected) onSelected(choice);
              },
              labelStyle: const TextStyle(fontSize: 16),
              labelPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
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
