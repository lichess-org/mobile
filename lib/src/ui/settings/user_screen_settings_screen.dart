import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/ui/settings/perf_order_screen.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/perf_reorderable.dart';

import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class UserScreenSettingsScreen extends StatelessWidget {
  const UserScreenSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Screen')),
      body: _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ListView(
        children: [
          ListSection(
            hasLeading: true,
            showDivider: true,
            children: [
              PlatformListTile(
                leading: const Icon(Icons.sort),
                title: const Text('Performance Card Order'),
                onTap: () {
                  pushPlatformRoute(
                    context,
                    title: 'Performance Card Order',
                    builder: (context) => const PerfOrderScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
