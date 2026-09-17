import 'dart:ui';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:material_ui/material_ui.dart';

/// A simple widget that builds different things on different platforms.
class const PlatformWidget({
  super.key,
  required final WidgetBuilder androidBuilder,
  required final WidgetBuilder iosBuilder,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return iosBuilder(context);
    } else {
      return androidBuilder(context);
    }
  }
}

class const PlatformShareIcon({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (_) => const Icon(Icons.share),
      iosBuilder: (_) => const Icon(Icons.ios_share),
    );
  }
}

/// A platform-aware circular loading indicator to be used in [AppBar.actions].
class const PlatformAppBarLoadingIndicator({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 16),
      child: SizedBox(
        height: 24,
        width: 24,
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}

/// A wrapper around [Scaffold] that sets properties to handle app bar and bottom navigation bar
/// transparency on iOS.
///
/// Limitations:
/// - It does not work with a [CustomScrollView] and [SliverAppBar] as the body.
class const PlatformScaffold({
  super.key,
  final Widget? body,
  final PlatformAppBar? appBar,
  final Widget? floatingActionButton,
  final List<Widget>? persistentFooterButtons,
  final Widget? drawer,
  final Widget? bottomSheet,
  final Widget? bottomNavigationBar,
  final bool? extendBody,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if a parent Scaffold has extendBody set to true.
    // This is the case if this scaffold is built inside a root tab where the main scaffold holds
    // the bottom navigation bar.
    final hasExtendedBodyParentScaffold = MainTabScaffoldProperties.hasExtendedBody(context);

    return Scaffold(
      extendBodyBehindAppBar: Theme.of(context).platform == TargetPlatform.iOS,
      extendBody: extendBody ?? hasExtendedBodyParentScaffold,
      appBar: appBar,
      body: body,
      drawer: drawer,
      persistentFooterButtons: persistentFooterButtons,
      floatingActionButton: floatingActionButton,
      bottomSheet: bottomSheet,
      bottomNavigationBar:
          bottomNavigationBar ??
          (hasExtendedBodyParentScaffold
              ? Container(
                  color: Colors.transparent,
                  height: MediaQuery.paddingOf(context).bottom,
                  width: double.infinity,
                )
              : null),
    );
  }
}

class const PlatformAppBar({
  super.key,
  final Widget? leading,
  final Widget? title,
  final double? titleSpacing,
  final TextStyle? titleTextStyle,
  final List<Widget>? actions,
  final PreferredSizeWidget? bottom,
  final bool? centerTitle,
  final bool automaticallyImplyLeading = true,
}) extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => _PreferredAppBarSize(kToolbarHeight, bottom?.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final appBar = AppBar(
      titleSpacing: titleSpacing,
      title: title,
      titleTextStyle: titleTextStyle,
      leading: leading,
      actions: actions,
      bottom: bottom,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      animateColor: true,
    );

    return isIOS
        ? ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: kCupertinoBarBlurSigma,
                sigmaY: kCupertinoBarBlurSigma,
              ),
              child: appBar,
            ),
          )
        : appBar;
  }
}

class const _PreferredAppBarSize(final double? toolbarHeight, final double? bottomHeight)
    extends Size {
  this : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));
}
