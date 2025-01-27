import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/board_background_theme.dart';
import 'package:lichess_mobile/src/widgets/cupertino.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

const kCupertinoAppBarWithActionPadding = EdgeInsetsDirectional.only(start: 16.0, end: 8.0);

/// Displays an [AppBar] for Android and a [CupertinoNavigationBar] for iOS.
///
/// Intended to be passed to [PlatformScaffold].
class PlatformAppBar extends StatelessWidget {
  const PlatformAppBar({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.leading,
    this.actions = const [],
    this.androidTitleSpacing,
  });

  /// Widget to place at the start of the navigation bar
  ///
  /// See [AppBar.leading] and [CupertinoNavigationBar.leading] for details
  final Widget? leading;

  /// The title displayed in the middle of the bar.
  ///
  /// On Android, this is [AppBar.title], on iOS [CupertinoNavigationBar.middle]
  final Widget title;

  /// On Android, this is passed directly to [AppBar.centerTitle]. Has no effect on iOS.
  final bool centerTitle;

  /// Action widgets to place at the end of the navigation bar.
  ///
  /// On Android, this is passed directlty to [AppBar.actions].
  /// On iOS, this is wrapped in a [Row] and passed to [CupertinoNavigationBar.trailing]
  final List<Widget> actions;

  /// Will be passed to [AppBar.titleSpacing] on Android. Has no effect on iOS.
  final double? androidTitleSpacing;

  AppBar _androidBuilder(BuildContext context) {
    return AppBar(
      titleSpacing: androidTitleSpacing,
      leading: leading,
      title: title,
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  CupertinoNavigationBar _iosBuilder(BuildContext context) {
    return CupertinoNavigationBar(
      padding: actions.isNotEmpty ? kCupertinoAppBarWithActionPadding : null,
      middle: title,
      trailing: Row(mainAxisSize: MainAxisSize.min, children: actions),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _androidBuilder, iosBuilder: _iosBuilder);
  }
}

/// A platform-aware circular loading indicator to be used in [PlatformAppBar.actions].
class PlatformAppBarLoadingIndicator extends StatelessWidget {
  const PlatformAppBarLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      iosBuilder: (_) => const CircularProgressIndicator.adaptive(),
      androidBuilder:
          (_) => const Padding(
            padding: EdgeInsets.only(right: 16),
            child: SizedBox(
              height: 24,
              width: 24,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
    );
  }
}

class _CupertinoNavBarWrapper extends StatelessWidget implements ObstructingPreferredSizeWidget {
  const _CupertinoNavBarWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;

  @override
  Size get preferredSize => const Size.fromHeight(kMinInteractiveDimensionCupertino);

  /// True if the navigation bar's background color has no transparency.
  @override
  bool shouldFullyObstruct(BuildContext context) {
    final Color backgroundColor = CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.a == 0xFF;
  }
}

/// A screen with a navigation bar and a body that adapts to the platform.
///
/// On Android, this is a [Scaffold] with an [AppBar],
/// on iOS a [CupertinoPageScaffold] with a [CupertinoNavigationBar].
///
/// See [PlatformAppBar] for an app bar that adapts to the platform and needs to be passed to this widget.
class PlatformScaffold extends StatelessWidget {
  const PlatformScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.resizeToAvoidBottomInset = true,
  });

  /// Acts as the [AppBar] for Android and as the [CupertinoNavigationBar] for iOS.
  ///
  /// Usually an instance of [PlatformAppBar].
  final Widget? appBar;

  /// The main content of the screen, displayed below the navigation bar.
  final Widget body;

  /// See [Scaffold.resizeToAvoidBottomInset] and [CupertinoPageScaffold.resizeToAvoidBottomInset]
  final bool resizeToAvoidBottomInset;

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar:
          appBar != null
              ? PreferredSize(preferredSize: const Size.fromHeight(kToolbarHeight), child: appBar!)
              : null,
      body: body,
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoMaterialWrapper(
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        navigationBar: appBar != null ? _CupertinoNavBarWrapper(child: appBar!) : null,
        child: body,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _androidBuilder, iosBuilder: _iosBuilder);
  }
}

class PlatformBoardThemeScaffold extends StatelessWidget {
  const PlatformBoardThemeScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.resizeToAvoidBottomInset = true,
  });

  /// Acts as the [AppBar] for Android and as the [CupertinoNavigationBar] for iOS.
  ///
  /// Usually an instance of [PlatformAppBar].
  final Widget? appBar;

  /// The main content of the screen, displayed below the navigation bar.
  final Widget body;

  /// See [Scaffold.resizeToAvoidBottomInset] and [CupertinoPageScaffold.resizeToAvoidBottomInset]
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return BoardBackgroundThemeWidget(
      child: PlatformScaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: appBar,
        body: body,
      ),
    );
  }
}
