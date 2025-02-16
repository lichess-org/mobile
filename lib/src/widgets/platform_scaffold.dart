import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

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
    this.appBarAndroidTitleSpacing,
    required this.body,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
    this.enableBackgroundFilterBlur = true,
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

  /// Action widgets to place at the end of the navigation bar.
  ///
  /// On Android, this is passed directlty to [AppBar.actions].
  /// On iOS, this is wrapped in a [Row] and passed to [CupertinoNavigationBar.trailing]
  final List<Widget> appBarActions;

  /// Will be passed to [AppBar.titleSpacing] on Android. Has no effect on iOS.
  final double? appBarAndroidTitleSpacing;

  /// The main content of the screen, displayed below the navigation bar.
  final Widget body;

  /// See [Scaffold.resizeToAvoidBottomInset] and [CupertinoPageScaffold.resizeToAvoidBottomInset]
  final bool resizeToAvoidBottomInset;

  /// The background color of the screen. If null, the default background color of the theme is used.
  final Color? backgroundColor;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.enableBackgroundFilterBlur}
  ///
  /// Has no effect on Android.
  final bool enableBackgroundFilterBlur;

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        titleSpacing: appBarAndroidTitleSpacing,
        leading: appBarLeading,
        title: appBarTitle,
        centerTitle: appBarCenterTitle,
        actions: appBarActions,
      ),
      body: body,
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      navigationBar: CupertinoNavigationBar(
        padding: appBarActions.isNotEmpty ? kCupertinoAppBarWithActionPadding : null,
        middle: appBarTitle,
        leading: appBarLeading,
        trailing:
            appBarActions.isNotEmpty
                ? Row(mainAxisSize: MainAxisSize.min, children: appBarActions)
                : null,
        enableBackgroundFilterBlur: enableBackgroundFilterBlur,
      ),
      backgroundColor: backgroundColor,
      child: body,
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
