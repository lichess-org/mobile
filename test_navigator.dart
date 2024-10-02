import 'package:flutter/widgets.dart';

class TestNavigatorObserver extends NavigatorObserver {
  void Function(Route<dynamic> route, Route<dynamic>? previousRoute)? onPushed;
  void Function(Route<dynamic> route, Route<dynamic>? previousRoute)? onPopped;
  void Function(Route<dynamic> route, Route<dynamic>? previousRoute)? onRemoved;
  void Function(Route<dynamic>? route, Route<dynamic>? previousRoute)?
      onReplaced;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onPushed?.call(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onPopped?.call(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onRemoved?.call(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? oldRoute, Route<dynamic>? newRoute}) {
    onReplaced?.call(newRoute, oldRoute);
  }
}
