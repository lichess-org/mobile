import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';

/// A simple widget that builds different things on different platforms.
class PlatformWidget extends StatelessWidget {
  const PlatformWidget({
    super.key,
    required this.androidBuilder,
    required this.iosBuilder,
  });

  final WidgetBuilder androidBuilder;
  final WidgetBuilder iosBuilder;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return iosBuilder(context);
    } else {
      return androidBuilder(context);
    }
  }
}

class PlatformShareIcon extends StatelessWidget {
  const PlatformShareIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (_) => const Icon(Icons.share),
      iosBuilder: (_) => const Icon(Icons.ios_share),
    );
  }
}

/// A platform-aware circular loading indicator to be used in [AppBar.actions].
class PlatformAppBarLoadingIndicator extends StatelessWidget {
  const PlatformAppBarLoadingIndicator({super.key});

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
class PlatformScaffold extends StatelessWidget {
  const PlatformScaffold({
    super.key,
    this.body,
    this.appBar,
    this.floatingActionButton,
    this.persistentFooterButtons,
    this.drawer,
    this.bottomSheet,
    this.bottomNavigationBar,
    this.extendBody,
  });

  final PlatformAppBar? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final bool? extendBody;

  @override
  Widget build(BuildContext context) {
    // Check if a parent Scaffold has extendBody set to true.
    // This is the case if this scaffold is built inside a root tab where the main scaffold holds
    // the bottom navigation bar.
    final hasExtendedBodyParentScaffold =
        MainTabScaffoldProperties.hasExtendedBody(context);

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

class PlatformAppBar extends StatelessWidget implements PreferredSizeWidget {
  PlatformAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.bottom,
    this.centerTitle,
    this.automaticallyImplyLeading = true,
  }) : preferredSize = _PreferredAppBarSize(
         kToolbarHeight,
         bottom?.preferredSize.height,
       );

  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;
  final bool automaticallyImplyLeading;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final appBar = AppBar(
      title: title,
      leading: leading,
      actions: actions,
      bottom: bottom,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
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

class _PreferredAppBarSize extends Size {
  const _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
    : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}
