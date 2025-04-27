import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/emoji_picker/emoji_picker_configuration.dart';

class EmojiSearchBar extends StatefulWidget {
  const EmojiSearchBar({super.key, required this.configuration, required this.onKeywordChanged});

  final EmojiPickerConfiguration configuration;
  final void Function(String keyword) onKeywordChanged;

  @override
  State<EmojiSearchBar> createState() => _EmojiSearchBarState();
}

class _EmojiSearchBarState extends State<EmojiSearchBar> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4.0),
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Row(
        children: [
          // search bar
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, size: 20),
                hintText: context.l10n.searchSearch,
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 15),
              onChanged: widget.onKeywordChanged,
            ),
          ),
          // clear button
          IconButton(
            tooltip: context.l10n.mobileClearButton,
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.clear();
              widget.onKeywordChanged('');
            },
          ),
        ],
      ),
    );
  }
}
