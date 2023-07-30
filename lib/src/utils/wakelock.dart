import 'package:flutter/widgets.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final RouteObserver<PageRoute<void>> wakelockRouteObserver =
    RouteObserver<PageRoute<void>>();

/// State mixin that enables wakelock when the route is active.
mixin Wakelock<T extends StatefulWidget> on State<T> implements RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      wakelockRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    wakelockRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    WakelockPlus.enable();
  }

  @override
  void didPush() {
    WakelockPlus.enable();
  }

  @override
  void didPop() {
    WakelockPlus.disable();
  }

  @override
  void didPushNext() {
    WakelockPlus.disable();
  }
}
