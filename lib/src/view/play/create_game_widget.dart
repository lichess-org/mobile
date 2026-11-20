import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/icon_extensions.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/view/play/common_play_widgets.dart';
import 'package:lichess_mobile/src/view/play/playban.dart';
import 'package:lichess_mobile/src/view/play/time_control_modal.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:lichess_mobile/src/widgets/variant_app_bar_title.dart';
import 'package:material_ui/material_ui.dart';

class const CreateGameWidget({
  /// The navigator where the game is pushed, by default the navigator of the widget: in a sheet on
  /// the root navigator, the navigator of the screen that presents it.
  final NavigatorState? navigator,
  super.key,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playPrefs = ref.watch(gameSetupPreferencesProvider);
    final connectionStatus = ref.watch(lichessConnectionStatusProvider);
    final account = ref.watch(accountProvider).value;
    final userPerf = account?.perfs[playPrefs.realTimePerf];
    final canUseRatingRange = userPerf != null && userPerf.provisional != true;

    final labelStyle = Theme.of(context).textTheme.labelMedium
        ?.copyWith(color: textShade(context, 0.5), height: 1.0);

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: Semantics(
                container: true,
                button: true,
                label: '${context.l10n.timeControl}: ${playPrefs.timeIncrement.display}',
                excludeSemantics: true,
                child: Column(
                  crossAxisAlignment: .stretch,
                  mainAxisSize: .min,
                  children: [
                    Text(context.l10n.timeControl, style: labelStyle),
                    _PickerButton(
                      icon: playPrefs.timeIncrement.speed.icon,
                      label: Text(
                        playPrefs.timeIncrement.display,
                        style: const TextStyle(letterSpacing: 2.0),
                      ),
                      onPressed: () {
                        final double screenHeight = MediaQuery.heightOf(context);
                        showAdaptiveBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          constraints: BoxConstraints(
                            maxHeight: screenHeight - (screenHeight / 10),
                          ),
                          builder: (BuildContext context) {
                            return TimeControlModal(
                              timeIncrement: playPrefs.timeIncrement,
                              onSelected: (choice) {
                                ref
                                    .read(gameSetupPreferencesProvider.notifier)
                                    .setTimeIncrement(choice);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Semantics(
                container: true,
                button: true,
                label: '${context.l10n.variant}: ${playPrefs.customVariant.label(context.l10n)}',
                excludeSemantics: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.l10n.variant, style: labelStyle),
                    _PickerButton(
                      icon: playPrefs.customVariant != Variant.standard
                          ? playPrefs.customVariant.icon
                          : null,
                      label: Text(playPrefs.customVariant.label(context.l10n)),
                      onPressed: () {
                        showChoicePicker(
                          context,
                          title: Text(context.l10n.variant),
                          choices: playSupportedVariants
                              .where((v) => v != Variant.fromPosition)
                              .toList(),
                          selectedItem: playPrefs.customVariant,
                          labelBuilder: (variant) => VariantLabel(variant),
                          onSelectedItemChanged: (Variant variant) {
                            ref
                                .read(gameSetupPreferencesProvider.notifier)
                                .setCustomVariant(variant);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (account != null) ...[
          const SizedBox(height: 6.0),
          Row(
            children: [
              Expanded(
                child: Semantics(
                  container: true,
                  button: true,
                  label:
                      '${context.l10n.gameMode}: ${playPrefs.customRated ? context.l10n.rated : context.l10n.casual}',
                  excludeSemantics: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(context.l10n.gameMode, style: labelStyle),
                      _PickerButton(
                        onPressed: () {
                          showChoicePicker(
                            context,
                            title: Text(context.l10n.gameMode),
                            choices: [context.l10n.casual, context.l10n.rated],
                            selectedItem: playPrefs.customRated
                                ? context.l10n.rated
                                : context.l10n.casual,
                            labelBuilder: (String label) => Text(label),
                            onSelectedItemChanged: (String label) {
                              ref
                                  .read(gameSetupPreferencesProvider.notifier)
                                  .setCustomRated(label == context.l10n.rated);
                            },
                          );
                        },
                        label: Text(
                          playPrefs.customRated ? context.l10n.rated : context.l10n.casual,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Semantics(
                  container: true,
                  button: true,
                  label:
                      '${context.l10n.ratingFilter}: ${canUseRatingRange ? '${playPrefs.customRatingDelta.$1 == 0 ? '-' : ''}${playPrefs.customRatingDelta.$1} / +${playPrefs.customRatingDelta.$2}' : '-500 / +500'}',
                  excludeSemantics: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: canUseRatingRange
                            ? null
                            : () => _showDisabledRatingRangeExplanation(context),
                        child: Row(
                          mainAxisSize: .min,
                          children: [
                            Text(context.l10n.ratingFilter, style: labelStyle),
                            if (!canUseRatingRange)
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Icon(
                                  Icons.info_outline,
                                  size: 16.0,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                      _PickerButton(
                        enabled: canUseRatingRange,
                        onPressed: canUseRatingRange
                            ? () {
                                showAdaptiveBottomSheet<void>(
                                  context: context,
                                  constraints: BoxConstraints(
                                    minHeight: MediaQuery.heightOf(context) * 0.4,
                                  ),
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return BottomSheetScrollableContainer(
                                      children: [
                                        PlayRatingRange(
                                          perf: userPerf,
                                          ratingDelta: playPrefs.customRatingDelta,
                                          onRatingDeltaChange: (int subtract, int add) {
                                            ref
                                                .read(gameSetupPreferencesProvider.notifier)
                                                .setCustomRatingRange(subtract, add);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            : () => _showDisabledRatingRangeExplanation(context),
                        label: canUseRatingRange
                            ? Text(
                                '${playPrefs.customRatingDelta.$1 == 0 ? '-' : ''}${playPrefs.customRatingDelta.$1} / +${playPrefs.customRatingDelta.$2}',
                              )
                            : const Text('-500 / +500'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
        FilledButton(
          onPressed: connectionStatus == LichessConnectionStatus.online
              ? () {
                  // Pops the play bottom sheet
                  Navigator.of(context).popUntil((route) => route is! PopupRoute);

                  final playban = ref.read(accountProvider).value?.playban;
                  if (playban != null) {
                    showPlaybanDialog(context, playban);
                    return;
                  }

                  (navigator ?? Navigator.of(context)).pushHidingTabBar(
                    GameScreen.buildRoute(source: LobbySource(GameSeek.custom(playPrefs, account))),
                  );
                }
              : null,
          child: Text(context.l10n.createAGame),
        ),
      ],
    );
  }

  void _showDisabledRatingRangeExplanation(BuildContext context) {
    showAdaptiveDialog<void>(
      context: context,
      builder: (context) => PlatformAlertDialog(
        content: Text(context.l10n.cannotFilterByUnstableRating),
        actions: [
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.mobileOkButton),
          ),
        ],
      ),
    );
  }
}

/// A button that shows the value of a setting and opens a picker to change it.
///
/// Like the iOS pop-up buttons, the value is content rather than an action, so it is in the text
/// color instead of the accent one, with a chevron telling that it opens a picker.
class const _PickerButton({
  required final Widget label,
  required final VoidCallback onPressed,
  final IconData? icon,

  /// Whether the setting can be changed: when it cannot, the button is still tappable (e.g. to
  /// explain why) but looks disabled.
  final bool enabled = true,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = enabled ? theme.colorScheme.onSurface : theme.disabledColor;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: theme.dividerColor),
        foregroundColor: foregroundColor,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: .min,
        spacing: 8.0,
        children: [
          if (icon != null) Icon(icon),
          Flexible(child: label),
          Icon(
            theme.platform == .iOS ? CupertinoIcons.chevron_up_chevron_down : Icons.unfold_more,
            size: 14.0,
            color: foregroundColor.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
