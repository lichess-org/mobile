import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/account/home_preferences.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/view/play/play_bottom_sheet.dart';
import 'package:lichess_mobile/src/view/play/playban.dart';

const _kMatrixSpacing = 8.0;

class QuickGameMatrix extends ConsumerWidget {
  const QuickGameMatrix({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playban = ref.watch(accountProvider).value?.playban;
    final brightness = Theme.of(context).brightness;
    final logoColor = brightness == Brightness.light
        ? const Color(0x0F000000)
        : const Color(0x80FFFFFF);
    final scaffoldOpacity = Theme.of(context).scaffoldBackgroundColor.a;

    if (playban != null) {
      return PlaybanMessage(playban: playban);
    }

    final homePrefs = ref.watch(homePreferencesProvider);
    final enabledControls = TimeIncrement.matrixPresets
        .where((tc) => !homePrefs.disabledTimeControls.contains(tc))
        .toList();
    final showCustom = homePrefs.customButtonEnabled;

    final rows = <List<TimeIncrement>>[];
    for (var i = 0; i < enabledControls.length; i += 3) {
      rows.add(enabledControls.sublist(i, (i + 3).clamp(0, enabledControls.length)));
    }
    if (rows.isEmpty && showCustom) {
      rows.add([]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.quickPairing, style: Styles.sectionTitle),
        const SizedBox(height: 6.0),
        Container(
          decoration: scaffoldOpacity != 0
              ? BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(logoColor, BlendMode.modulate),
                    image: const AssetImage('assets/images/logo-transp.png'),
                    fit: BoxFit.contain,
                  ),
                )
              : null,
          child: Column(
            children: [
              for (final (index, row) in rows.indexed) ...[
                if (index > 0) const SizedBox(height: _kMatrixSpacing),
                _SectionChoices(
                  choices: row,
                  showCustom: showCustom && index == rows.length - 1 && row.length < 3,
                ),
              ],
              if (showCustom && rows.every((r) => r.length >= 3)) ...[
                const SizedBox(height: _kMatrixSpacing),
                const _SectionChoices(choices: [], showCustom: true),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionChoices extends ConsumerWidget {
  const _SectionChoices({required this.choices, this.showCustom = false});

  final List<TimeIncrement> choices;
  final bool showCustom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authControllerProvider);
    final isOnline = ref.watch(connectivityChangesProvider).value?.isOnline ?? false;
    final choiceWidgets = choices
        .mapIndexed((index, choice) {
          return [
            Expanded(
              child: _ChoiceChip(
                key: ValueKey(choice),
                title: Text(
                  choice.display,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                ),
                subtitle: Text(choice.speed.label, style: const TextStyle(fontSize: 14.0)),
                speed: choice.speed,
                onTap: isOnline
                    ? () {
                        Navigator.of(context, rootNavigator: true).push(
                          GameScreen.buildRoute(
                            context,
                            source: LobbySource(GameSeek.fastPairing(choice, authUser)),
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
          if (showCustom) ...[
            if (choices.isNotEmpty) const SizedBox(width: _kMatrixSpacing),
            Expanded(
              child: _ChoiceChip(
                title: Text(context.l10n.custom, textAlign: TextAlign.center),
                onTap: isOnline
                    ? () {
                        showModalBottomSheet<void>(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          builder: (context) {
                            return const PlayBottomSheet();
                          },
                        );
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
  const _ChoiceChip({
    required this.title,
    this.subtitle,
    this.speed,
    required this.onTap,
    super.key,
  });

  final Widget title;
  final Widget? subtitle;
  final Speed? speed;
  final void Function()? onTap;

  static const BorderRadius _kBorderRadius = BorderRadius.all(Radius.circular(6.0));

  @override
  Widget build(BuildContext context) {
    final scaffoldOpacity = Theme.of(context).scaffoldBackgroundColor.a;
    final bgColor = Theme.of(context).brightness == Brightness.dark
        ? scaffoldOpacity > 0
              ? Colors.white10
              : ColorScheme.of(context).surfaceContainerLow
        : ColorScheme.of(context).surfaceContainerHighest.withValues(alpha: 0.50);

    return Opacity(
      opacity: onTap != null ? 1.0 : 0.5,
      child: Container(
        decoration: BoxDecoration(color: bgColor, borderRadius: _kBorderRadius),
        child: InkWell(
          borderRadius: _kBorderRadius,
          onTap: onTap,
          splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: Theme.of(context).textTheme.labelMedium?.color?.withValues(alpha: 0.8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [title, if (subtitle != null) subtitle!],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showTimeControlPicker(BuildContext context, WidgetRef ref) {
  final homePrefs = ref.read(homePreferencesProvider);
  final disabledControls = Set<TimeIncrement>.from(homePrefs.disabledTimeControls);
  var customEnabled = homePrefs.customButtonEnabled;

  final grouped = groupBy(TimeIncrement.matrixPresets, (tc) => tc.speed);

  return showAdaptiveDialog<void>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final enabledCount =
              TimeIncrement.matrixPresets.length -
              disabledControls.length +
              (customEnabled ? 1 : 0);

          return AlertDialog.adaptive(
            title: Text(context.l10n.quickPairing),
            contentPadding: const EdgeInsets.only(top: 12),
            scrollable: true,
            content: Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final speed in grouped.keys) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          speed.label,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                        ),
                      ),
                    ),
                    for (final tc in grouped[speed]!)
                      CheckboxListTile.adaptive(
                        title: Text(tc.display),
                        value: !disabledControls.contains(tc),
                        onChanged: !disabledControls.contains(tc) && enabledCount <= 1
                            ? null
                            : (value) {
                                setState(() {
                                  if (value!) {
                                    disabledControls.remove(tc);
                                  } else {
                                    disabledControls.add(tc);
                                  }
                                });
                              },
                      ),
                  ],
                  const Divider(),
                  CheckboxListTile.adaptive(
                    title: Text(context.l10n.custom),
                    value: customEnabled,
                    onChanged: customEnabled && enabledCount <= 1
                        ? null
                        : (value) {
                            setState(() {
                              customEnabled = value!;
                            });
                          },
                  ),
                ],
              ),
            ),
            actions: Theme.of(context).platform == TargetPlatform.iOS
                ? [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(context.l10n.cancel),
                    ),
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () {
                        ref
                            .read(homePreferencesProvider.notifier)
                            .setTimeControlConfig(
                              disabledTimeControls: IList(disabledControls),
                              customButtonEnabled: customEnabled,
                            );
                        Navigator.of(context).pop();
                      },
                      child: Text(context.l10n.mobileOkButton),
                    ),
                  ]
                : [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(context.l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(homePreferencesProvider.notifier)
                            .setTimeControlConfig(
                              disabledTimeControls: IList(disabledControls),
                              customButtonEnabled: customEnabled,
                            );
                        Navigator.of(context).pop();
                      },
                      child: Text(context.l10n.mobileOkButton),
                    ),
                  ],
          );
        },
      );
    },
  );
}
