import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kCupertinoAppBarWithActionPadding = EdgeInsetsDirectional.only(start: 16.0, end: 8.0);

/// A screen with a navigation bar and a body that adapts to the platform.
///
/// On Android, this is a [Scaffold] with an [AppBar],
/// on iOS a [CupertinoPageScaffold] with a [CupertinoNavigationBar].
///
/// This widget is voluntary limited to the most common use cases. For more advanced use cases,
/// consider using [Scaffold] and [CupertinoPageScaffold] directly.
class PlatformScaffold extends StatelessWidget {
  const PlatformScaffold({
    super.key,
    this.appBarLeading,
    required this.appBarTitle,
    this.appBarCenterTitle = false,
    this.appBarActions = const [],
    this.appBarBottom,
    this.appBarAndroidTitleSpacing,
    this.appBarEnableBackgroundFilterBlur = true,
    this.appBarAutomaticBackgroundVisibility = true,
    required this.body,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
  });

  /// Widget to place at the start of the navigation bar
  ///
  /// See [AppBar.leading] and [CupertinoNavigationBar.leading] for details
  final Widget? appBarLeading;

  /// The title displayed in the middle of the bar.
  ///
  /// On Android, this is [AppBar.title], on iOS [CupertinoNavigationBar.middle]
  final Widget appBarTitle;

  /// On Android, this is passed directly to [AppBar.centerTitle]. Has no effect on iOS.
  final bool appBarCenterTitle;

  /// A widget to place at the bottom of the navigation bar.
  final PreferredSizeWidget? appBarBottom;

  /// Action widgets to place at the end of the navigation bar.
  ///
  /// On Android, this is passed directlty to [AppBar.actions].
  /// On iOS, this is wrapped in a [Row] and passed to [CupertinoNavigationBar.trailing]
  final List<Widget> appBarActions;

  /// Will be passed to [AppBar.titleSpacing] on Android. Has no effect on iOS.
  final double? appBarAndroidTitleSpacing;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.enableBackgroundFilterBlur}
  ///
  /// Has no effect on Android.
  final bool appBarEnableBackgroundFilterBlur;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.automaticBackgroundVisibility}
  ///
  /// Has no effect on Android.
  final bool appBarAutomaticBackgroundVisibility;

  /// The main content of the screen, displayed below the navigation bar.
  final Widget body;

  /// See [Scaffold.resizeToAvoidBottomInset] and [CupertinoPageScaffold.resizeToAvoidBottomInset]
  final bool resizeToAvoidBottomInset;

  /// The background color of the screen. If null, the default background color of the theme is used.
  final Color? backgroundColor;

  /// A widget to place at the bottom of the screen, below the body.
  ///
  /// Typically used for a [BottomNavigationBar].
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        titleSpacing: appBarAndroidTitleSpacing,
        leading: appBarLeading,
        title: appBarTitle,
        centerTitle: appBarCenterTitle,
        actions: appBarActions,
        bottom: appBarBottom,
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

/// A platform-aware circular loading indicator to be used in [PlatformAppBar.actions].
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
