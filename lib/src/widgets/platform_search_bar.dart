import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/bottom_search_bar.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:material_ui/material_ui.dart';

/// Displays a [SearchBar] with platform adaptations.
///
/// On iOS, a search bar placed in the app bar ([inAppBar]) is a liquid glass search field, and a
/// search bar in the content is flat, like the iOS controls there: the same field, on a
/// [GlassControlBackground]. The `bottom` of an app bar with a large title is in the content until
/// it sticks below the app bar buttons ([AppBarBottomGlassScope]).
///
/// On iOS, the clear button clears the text, then calls [onChanged] and [onClear].
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

  /// Whether the search bar is placed in a bar floating over the content: the app bar, like in its
  /// `bottom`, or a [BottomSearchBar].
  ///
  /// On iOS it is then a liquid glass search field, part of the glass bar, which calls [onClear]
  /// whenever its text becomes empty, after [onChanged].
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
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // The glass search field of the iOS navigation bar is taller than the theme's search bar.
      final height = widget.inAppBar ? 44.0 : 40.0;
      final iconColor = ColorScheme.of(context).onSurface.withValues(alpha: 0.6);
      return GlassControlBackground(
        glass: widget.inAppBar && (AppBarBottomGlassScope.maybeOf(context) ?? true),
        height: height,
        child: SearchBar(
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          constraints: BoxConstraints(minHeight: height, maxHeight: height),
          controller: widget.controller,
          leading: Icon(CupertinoIcons.search, size: 20, color: iconColor),
          trailing: [
            if (widget.controller?.text.isNotEmpty == true)
              IconButton(
                onPressed: () {
                  widget.controller?.clear();
                  widget.onChanged?.call('');
                  widget.onClear?.call();
                },
                tooltip: 'Clear',
                icon: Icon(CupertinoIcons.clear_circled_solid, size: 18, color: iconColor),
              ),
          ],
          onTap: widget.onTap,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          focusNode: widget.focusNode,
          onSubmitted: widget.onSubmitted,
          onChanged: (term) {
            widget.onChanged?.call(term);
            if (widget.inAppBar && term.isEmpty) widget.onClear?.call();
          },
          hintText: widget.hintText ?? MaterialLocalizations.of(context).searchFieldLabel,
          autoFocus: widget.autoFocus,
          textInputAction: TextInputAction.search,
        ),
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

/// An app bar action that opens a search screen.
///
/// The button morphs into the search field of that screen, wrapped in a [SearchFieldHero] with the
/// same [heroTag].
class const SearchHeroButton({
  required final Object heroTag,
  required final VoidCallback onPressed,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      flightShuttleBuilder: _searchHeroFlightShuttleBuilder,
      child: IconButton(
        onPressed: onPressed,
        tooltip: context.l10n.searchSearch,
        icon: const Icon(Icons.search),
      ),
    );
  }
}

/// The search field of a search screen, which a [SearchHeroButton] with the same [tag] turns into.
class const SearchFieldHero({required final Object tag, required final Widget child, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(tag: tag, flightShuttleBuilder: _searchHeroFlightShuttleBuilder, child: child);
  }
}

/// A search field shape growing from the search button: the real field is a text field, which
/// must not be built twice during the flight.
Widget _searchHeroFlightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final colorScheme = ColorScheme.of(flightContext);
  return DecoratedBox(
    decoration: BoxDecoration(
      color: colorScheme.surfaceContainerHigh,
      borderRadius: const BorderRadius.all(Radius.circular(28.0)),
    ),
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 12.0),
        child: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
      ),
    ),
  );
}
