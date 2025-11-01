import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/computer/computer_controller.dart';
import 'package:lichess_mobile/src/model/computer/computer_game.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

void showConfigureGameSheet(BuildContext context, {required bool isDismissible}) {
  final double screenHeight = MediaQuery.sizeOf(context).height;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    isDismissible: isDismissible,
    constraints: BoxConstraints(maxHeight: screenHeight - (screenHeight / 10)),
    builder: (BuildContext context) {
      return const _ConfigureComputerGameSheet();
    },
  );
}

class _ConfigureComputerGameSheet extends ConsumerStatefulWidget {
  const _ConfigureComputerGameSheet();

  @override
  ConsumerState<_ConfigureComputerGameSheet> createState() => _ConfigureComputerSheetState();
}

class _ConfigureComputerSheetState extends ConsumerState<_ConfigureComputerGameSheet> {
  late StockfishLevel chosenLevel;
  late Variant chosenVariant;
  late SideChoice chosenSideChoice;

  @override
  void initState() {
    final gameState = ref.read(computerGameControllerProvider);
    chosenLevel = gameState.game.level;
    chosenVariant = gameState.game.meta.variant;
    chosenSideChoice = gameState.game.sideChoice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetScrollableContainer(
      children: [
        ListSection(
          materialFilledCard: true,
          children: [
            SettingsListTile(
              settingsLabel: Text(context.l10n.opponent),
              settingsValue: chosenLevel.label(context.l10n),
              onTap: () {
                showChoicePicker<StockfishLevel>(
                  context,
                  choices: StockfishLevel.values,
                  selectedItem: chosenLevel,
                  labelBuilder: (level) => Text(level.label(context.l10n)),
                  onSelectedItemChanged: (level) => setState(() {
                    chosenLevel = level;
                  }),
                );
              },
            ),
            SettingsListTile(
              settingsLabel: Text(context.l10n.side),
              settingsValue: chosenSideChoice.label(context.l10n),
              onTap: () {
                showChoicePicker<SideChoice>(
                  context,
                  choices: SideChoice.values,
                  selectedItem: chosenSideChoice,
                  labelBuilder: (sideChoice) => Text(sideChoice.label(context.l10n)),
                  onSelectedItemChanged: (sideChoice) => setState(() {
                    chosenSideChoice = sideChoice;
                  }),
                );
              },
            ),
            SettingsListTile(
              settingsLabel: Text(context.l10n.variant),
              settingsValue: chosenVariant.label,
              onTap: () {
                showChoicePicker<Variant>(
                  context,
                  choices: [Variant.standard, Variant.chess960],
                  selectedItem: chosenVariant,
                  labelBuilder: (Variant variant) => Text(variant.label),
                  onSelectedItemChanged: (Variant variant) => setState(() {
                    chosenVariant = variant;
                  }),
                );
              },
            ),
          ],
        ),

        Padding(
          padding: Styles.horizontalBodyPadding,
          child: FilledButton(
            onPressed: () {
              ref
                  .read(computerGameControllerProvider.notifier)
                  .startNewGame(chosenLevel, chosenSideChoice, chosenVariant);
              Navigator.pop(context);
            },
            child: Text(context.l10n.play, style: Styles.bold),
          ),
        ),
      ],
    );
  }
}
