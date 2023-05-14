import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';

class TvChannelSelector extends ConsumerWidget {
  const TvChannelSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tvChannel = ref.watch(currentTvChannelProvider);
    return GestureDetector(
      onTap: () => showChoicePicker<TvChannel>(
        context,
        choices: TvChannel.values,
        selectedItem: tvChannel,
        labelBuilder: (value) => Text("$value"),
        onSelectedItemChanged: (choice) =>
            ref.read(currentTvChannelProvider.notifier).state = choice,
      ),
      child: Text('$tvChannel'),
    );
  }
}
