import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/play/create_custom_game_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

const _kMatrixSpacing = 4.0;

class QuickGameMatrix extends StatelessWidget {
  const QuickGameMatrix({required this.showMatrixTitle});

  final bool showMatrixTitle;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final logoColor = brightness == Brightness.light
        ? const Color(0x0F000000)
        : const Color(0x80FFFFFF);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showMatrixTitle) ...[
          Text(context.l10n.quickPairing),
          const SizedBox(height: 6.0),
        ],
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(logoColor, BlendMode.modulate),
              image: const AssetImage('assets/images/logo-transp.png'),
              fit: BoxFit.contain,
            ),
          ),
          child: const Column(
            children: [
              _SectionChoices(
                choices: [
                  TimeIncrement(60, 0),
                  TimeIncrement(120, 1),
                  TimeIncrement(180, 0),
                ],
              ),
              SizedBox(height: _kMatrixSpacing),
              _SectionChoices(
                choices: [
                  TimeIncrement(180, 2),
                  TimeIncrement(300, 0),
                  TimeIncrement(300, 3),
                ],
              ),
              SizedBox(height: _kMatrixSpacing),
              _SectionChoices(
                choices: [
                  TimeIncrement(600, 0),
                  TimeIncrement(600, 5),
                  TimeIncrement(900, 10),
                ],
              ),
              SizedBox(height: _kMatrixSpacing),
              _SectionChoices(
                choices: [
                  TimeIncrement(1800, 0),
                  TimeIncrement(1800, 20),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionChoices extends ConsumerWidget {
  const _SectionChoices({required this.choices});

  final List<TimeIncrement> choices;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final choiceWidgets = choices
        .mapIndexed((index, choice) {
          return [
            Expanded(
              child: _ChoiceChip(
                key: ValueKey(choice),
                label: Text(
                  choice.display,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                ),
                speed: choice.speed,
                onSelected: (bool selected) {
                  pushPlatformRoute(
                    context,
                    rootNavigator: true,
                    builder: (_) => GameScreen(
                      seek: GameSeek.fastPairing(choice, session),
                    ),
                  );
                },
              ),
            ),
            if (index < choices.length - 1)
              const SizedBox(width: _kMatrixSpacing),
          ];
        })
        .flattened
        .toList();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...choiceWidgets,
          if (choices.length < 3) ...[
            const SizedBox(width: _kMatrixSpacing),
            Expanded(
              child: _ChoiceChip(
                label: Text(context.l10n.custom),
                onSelected: (bool selected) {
                  pushPlatformRoute(
                    context,
                    builder: (_) => const CreateCustomGameScreen(),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChoiceChip extends StatefulWidget {
  const _ChoiceChip({
    required this.label,
    this.speed,
    required this.onSelected,
    super.key,
  });

  final Widget label;
  final Speed? speed;
  final void Function(bool selected) onSelected;

  @override
  State<_ChoiceChip> createState() => _ChoiceChipState();
}

class _ChoiceChipState extends State<_ChoiceChip> {
  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).platform == TargetPlatform.iOS
        ? Styles.cupertinoCardColor.resolveFrom(context).withOpacity(0.7)
        : Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.7);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
      ),
      child: AdaptiveInkWell(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        onTap: () => widget.onSelected(true),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Center(child: widget.label),
        ),
      ),
    );
  }
}
