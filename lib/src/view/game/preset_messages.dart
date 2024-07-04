import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/message_presets.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

class PresetMessages extends ConsumerWidget {
  final GameFullId gameId;
  final List<PresetMessage> alreadySaid;
  final PresetMessageGroup? presetMessageGroup;
  final Map<PresetMessageGroup, List<PresetMessage>> presetMessages;
  final void Function(PresetMessage presetMessage) sendChatPreset;

  const PresetMessages({
    required this.gameId,
    required this.alreadySaid,
    required this.presetMessageGroup,
    required this.presetMessages,
    required this.sendChatPreset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = presetMessages[presetMessageGroup] ?? [];

    if (messages.isEmpty || alreadySaid.length >= 2) {
      return const SizedBox.shrink();
    }

    final notAlreadySaid =
        messages.where((message) => !alreadySaid.contains(message));

    return Row(
      children: notAlreadySaid
          .map((preset) => _renderPresetMessageButton(preset, ref))
          .toList(),
    );
  }

  Widget _renderPresetMessageButton(PresetMessage preset, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SecondaryButton(
        semanticsLabel: preset.label,
        onPressed: () {
          sendChatPreset(preset);
        },
        child: Text(
          preset.label,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
