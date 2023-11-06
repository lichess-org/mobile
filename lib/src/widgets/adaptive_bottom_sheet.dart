import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

/// A modal bottom sheet that adapts to the platform (Android/iOS).
Future<T?> showAdaptiveBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool useRootNavigator = true,
  bool useSafeArea = true,
  bool isScrollControlled = false,
  bool? showDragHandle,
  BoxConstraints? constraints,
}) async {
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    showDragHandle: showDragHandle,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    useSafeArea: useSafeArea,
    shape: defaultTargetPlatform == TargetPlatform.iOS
        ? const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0),
            ),
          )
        : null,
    constraints: constraints,
    backgroundColor: defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoDynamicColor.resolve(
            CupertinoColors.tertiarySystemGroupedBackground,
            context,
          )
        : null,
    elevation: defaultTargetPlatform == TargetPlatform.iOS ? 0 : null,
    builder: builder,
  );
}

/// A full-screen modal bottom sheet widget with an header and a body.
///
/// This is typically used with [showAdaptiveBottomSheet].
///
/// The [child] widget can be a scrollable widget, in that case you must set
/// `isScrollControlled` to true when calling [showAdaptiveBottomSheet].
class ModalSheetScaffold extends StatelessWidget {
  const ModalSheetScaffold({
    required this.title,
    required this.child,
    super.key,
  });

  final Widget title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (defaultTargetPlatform == TargetPlatform.iOS)
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                color: CupertinoTheme.of(context).barBackgroundColor,
              ),
              height: kMinInteractiveDimensionCupertino,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoDynamicColor.resolve(
                        CupertinoColors.separator,
                        context,
                      ),
                      width: 0.0,
                    ),
                  ),
                ),
                child: NavigationToolbar(
                  leading: CupertinoIconButton(
                    semanticsLabel: context.l10n.close,
                    icon: const Icon(CupertinoIcons.clear),
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  middle: DefaultTextStyle.merge(
                    child: title,
                    style:
                        CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: kToolbarHeight,
              child: NavigationToolbar(
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  color: Theme.of(context).iconTheme.color,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                middle: DefaultTextStyle.merge(
                  child: title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
