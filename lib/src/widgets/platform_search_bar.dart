import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassSearchBar;
import 'package:material_ui/material_ui.dart';

/// Displays a [SearchBar] with platform adaptations.
///
/// On iOS, a search bar placed in the app bar ([inAppBar]) is a liquid glass search field.
class const PlatformSearchBar({
  /// See [SearchBar.controller].
  final TextEditingController? controller,

  /// Text that suggests what sort of input the field accepts.
  ///
  /// Displayed at the same location on the screen where text may be entered
  /// when the input is empty.
  final String? hintText,

  /// Whether this the search should focus itself if nothing else is already focused.
  ///
  /// Defaults to false.
  final bool autoFocus = false,

  /// Callback when the clear button is pressed.
  ///
  /// Defaults to clearing the text in the [controller].
  final VoidCallback? onClear,

  /// Called when the user taps this search bar.
  final GestureTapCallback? onTap,

  /// Callback when the search term is submitted.
  final void Function(String term)? onSubmitted,

  /// Callback when the search term changes.
  final void Function(String term)? onChanged,

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode,

  /// Whether the search bar is placed in the app bar, like in its `bottom`.
  ///
  /// On iOS it is then a liquid glass search field, part of the glass navigation bar. That field
  /// has no [onTap], and calls [onClear] whenever its text becomes empty, after [onChanged].
  final bool inAppBar = false,
}) extends StatefulWidget {
  @override
  State<PlatformSearchBar> createState() => _PlatformSearchBarState();
}

class _PlatformSearchBarState() extends State<PlatformSearchBar> {
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
    if (widget.inAppBar && Theme.of(context).platform == TargetPlatform.iOS) {
      return GlassSearchBar(
        controller: widget.controller,
        focusNode: widget.focusNode,
        placeholder: widget.hintText ?? MaterialLocalizations.of(context).searchFieldLabel,
        autofocus: widget.autoFocus,
        onSubmitted: widget.onSubmitted,
        onChanged: (term) {
          widget.onChanged?.call(term);
          if (term.isEmpty) widget.onClear?.call();
        },
        // Floats alone in the app bar, there is no parent glass layer to share.
        useOwnLayer: true,
      );
    }

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
