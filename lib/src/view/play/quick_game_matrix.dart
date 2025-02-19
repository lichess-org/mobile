import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/play/create_custom_game_screen.dart';
import 'package:lichess_mobile/src/view/play/playban.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

const _kMatrixSpacing = 8.0;

class QuickGameMatrix extends ConsumerWidget {
  const QuickGameMatrix();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playban = ref.watch(accountProvider).valueOrNull?.playban;
    final brightness = Theme.of(context).brightness;
    final logoColor =
        brightness == Brightness.light ? const Color(0x0F000000) : const Color(0x80FFFFFF);

    if (playban != null) {
      return PlaybanMessage(playban: playban);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.quickPairing, style: Styles.sectionTitle),
        const SizedBox(height: 6.0),
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
                choices: [TimeIncrement(60, 0), TimeIncrement(120, 1), TimeIncrement(180, 0)],
              ),
              SizedBox(height: _kMatrixSpacing),
              _SectionChoices(
                choices: [TimeIncrement(180, 2), TimeIncrement(300, 0), TimeIncrement(300, 3)],
              ),
              SizedBox(height: _kMatrixSpacing),
              _SectionChoices(
                choices: [TimeIncrement(600, 0), TimeIncrement(600, 5), TimeIncrement(900, 10)],
              ),
              SizedBox(height: _kMatrixSpacing),
              _SectionChoices(choices: [TimeIncrement(1800, 0), TimeIncrement(1800, 20)]),
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
    final isOnline = ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? false;
    final choiceWidgets =
        choices
            .mapIndexed((index, choice) {
              return [
                Expanded(
                  child: _ChoiceChip(
                    key: ValueKey(choice),
                    label: Text(
                      choice.display,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                    ),
                    speed: choice.speed,
                    onTap:
                        isOnline
                            ? () {
                              Navigator.of(context, rootNavigator: true).push(
                                GameScreen.buildRoute(
                                  context,
                                  seek: GameSeek.fastPairing(choice, session),
                                ),
                              );
                            }
                            : null,
                  ),
                ),
                if (index < choices.length - 1) const SizedBox(width: _kMatrixSpacing),
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
                onTap:
                    isOnline
                        ? () {
                          Navigator.of(context).push(CreateCustomGameScreen.buildRoute(context));
                        }
                        : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({required this.label, this.speed, required this.onTap, super.key});

  final Widget label;
  final Speed? speed;
  final void Function()? onTap;

  static const BorderRadius _kBorderRadius = BorderRadius.all(Radius.circular(6.0));

  @override
  Widget build(BuildContext context) {
    final bgColor =
        Theme.of(context).brightness == Brightness.dark ? Colors.white10 : const Color(0xCCFFFFFF);

    return Opacity(
      opacity: onTap != null ? 1.0 : 0.5,
      child: Container(
        decoration: BoxDecoration(color: bgColor, borderRadius: _kBorderRadius),
        child: AdaptiveInkWell(
          borderRadius: _kBorderRadius,
          onTap: onTap,
          splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: Theme.of(context).textTheme.labelMedium?.color?.withValues(alpha: 0.8),
              ),
              child: Center(child: label),
            ),
          ),
        ),
      ),
    );
  }
}
