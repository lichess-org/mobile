import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_controller.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/view/clock/clock_settings.dart';
import 'package:lichess_mobile/src/view/clock/clock_tile.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen>
    with RouteAware, ImmersiveMode {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      rootNavPageRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    rootNavPageRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: _Body(),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return const SafeArea(
      child: CupertinoPageScaffold(
        child: _Body(),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(clockControllerProvider);

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ClockTile(
            playerType: ClockPlayerType.top,
          ),
        ),
        ClockSettings(),
        Expanded(
          child: ClockTile(
            playerType: ClockPlayerType.bottom,
          ),
        ),
      ],
    );
  }
}
