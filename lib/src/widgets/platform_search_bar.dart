import 'package:flutter/material.dart';

/// Displays a [SearchBar] with platform adaptations.
class PlatformSearchBar extends StatefulWidget {
  const PlatformSearchBar({
    this.controller,
    this.hintText,
    this.autoFocus = false,
    this.onClear,
    this.onTap,
    this.onSubmitted,
    this.onChanged,
    this.focusNode,
  });

  /// See [SearchBar.controller].
  final TextEditingController? controller;

  /// Text that suggests what sort of input the field accepts.
  ///
  /// Displayed at the same location on the screen where text may be entered
  /// when the input is empty.
  final String? hintText;

  /// Whether this the search should focus itself if nothing else is already focused.
  ///
  /// Defaults to false.
  final bool autoFocus;

  /// Called when the user taps this search bar.
  final GestureTapCallback? onTap;

  /// Callback when the clear button is pressed.
  ///
  /// Defaults to clearing the text in the [controller].
  final VoidCallback? onClear;

  /// Callback when the search term is submitted.
  final void Function(String term)? onSubmitted;

  /// Callback when the search term changes.
  final void Function(String term)? onChanged;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  @override
  State<PlatformSearchBar> createState() => _PlatformSearchBarState();
}

class _PlatformSearchBarState extends State<PlatformSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      elevation: const WidgetStatePropertyAll(0),
      controller: widget.controller,
      leading: const Icon(Icons.search),
      trailing: [
        if (widget.controller?.text.isNotEmpty == true)
          IconButton(
            onPressed: widget.onClear ?? () => widget.controller?.clear(),
            tooltip: 'Clear',
            icon: const Icon(Icons.close),
          ),
      ],
      onTap: widget.onTap,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      focusNode: widget.focusNode,
      onSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      hintText: widget.hintText,
      autoFocus: widget.autoFocus,
      textInputAction: TextInputAction.search,
    );
  }
}
