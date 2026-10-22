import 'dart:math' as math;

import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassButton, LiquidRoundedSuperellipse;
import 'package:material_ui/material_ui.dart';

/// Height of the search field and the action button of a [BottomSearchBar].
const double _kBottomSearchBarControlHeight = 44.0;

/// Space above and below the controls of a [BottomSearchBar] (below them, the minimum space when
/// the bottom safe area is smaller, e.g. above the keyboard).
const double _kBottomSearchBarVerticalPadding = 8.0;

/// A search field floating at the bottom of the screen over the content, with an optional action
/// button next to it, like the search toolbars of iOS 26. Meant for iOS only.
///
/// It is laid out at the bottom of a [Stack] above the scrolling content, which adds
/// [BottomSearchBar.heightOf] to its bottom padding. In the body of a [PlatformScaffold], it moves
/// up with the keyboard.
///
/// The [searchField] is a [PlatformSearchBar] with `inAppBar: true`, and the [action] a
/// [BottomSearchBarButton]: glass controls floating over the content. Before iOS 26
/// ([useLiquidGlass]), the bar is translucent instead ([BlurredBarBackground]), with plain controls.
class const BottomSearchBar({required final Widget searchField, final Widget? action, super.key})
    extends StatelessWidget {
  /// The height the bar covers at the bottom of the screen, safe area included.
  static double heightOf(BuildContext context) =>
      _kBottomSearchBarVerticalPadding +
      _kBottomSearchBarControlHeight +
      math.max(MediaQuery.paddingOf(context).bottom, _kBottomSearchBarVerticalPadding);

  @override
  Widget build(BuildContext context) {
    final bar = Padding(
      padding: EdgeInsets.fromLTRB(
        16.0,
        _kBottomSearchBarVerticalPadding,
        16.0,
        math.max(MediaQuery.paddingOf(context).bottom, _kBottomSearchBarVerticalPadding),
      ),
      child: Row(
        spacing: 12.0,
        children: [
          Expanded(child: searchField),
          ?action,
        ],
      ),
    );
    if (!useLiquidGlass(context)) {
      return BlurredBarBackground(atBottom: true, child: bar);
    }
    return bar;
  }
}

/// The action button of a [BottomSearchBar]: a liquid glass circle on iOS 26 and later, like the
/// search field next to it, otherwise an [IconButton].
class const BottomSearchBarButton({
  required final Widget icon,
  required final String semanticsLabel,
  required final VoidCallback onPressed,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!useLiquidGlass(context)) {
      return IconButton(onPressed: onPressed, tooltip: semanticsLabel, icon: icon);
    }

    final foregroundColor = ColorScheme.of(context).onSurface;
    return Semantics(
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: GlassButton.custom(
        onTap: onPressed,
        label: semanticsLabel,
        // The glass of the search field next to it.
        settings: appBarButtonGlassSettings(context),
        width: _kBottomSearchBarControlHeight,
        height: _kBottomSearchBarControlHeight,
        shape: const LiquidRoundedSuperellipse(borderRadius: _kBottomSearchBarControlHeight / 2),
        // Floats over the content, there is no parent glass layer to share.
        useOwnLayer: true,
        child: IconTheme.merge(
          data: IconThemeData(color: foregroundColor),
          child: icon,
        ),
      ),
    );
  }
}
