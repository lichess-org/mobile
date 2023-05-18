import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/settings/user_screen_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/perf_reorderable.dart';

import 'package:lichess_mobile/src/widgets/platform.dart';

List<Perf> newList = [];

class PerfOrderScreen extends ConsumerWidget {
  const PerfOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Performance Card Order',
          style: TextStyle(fontSize: 18),
        ),
        actions: [_SaveButton()],
      ),
      body: _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: _SaveButton(),
      ),
      child: _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: PerfReorderable(
        onChange: (List<Perf> list) {
          newList = list;
        },
      ),
    );
  }
}

class _SaveButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      icon: const Icon(Icons.check),
      label: Text(context.l10n.save),
      onPressed: () {
        ref.read(userScreenPreferencesProvider.notifier).setPerfOrder(newList);
      },
    );
  }
}
