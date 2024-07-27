import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

const kMasterVolumeValues = [
  0.0,
  0.1,
  0.2,
  0.3,
  0.4,
  0.5,
  0.6,
  0.7,
  0.8,
  0.9,
  1.0,
];

class VolumeScreen extends StatelessWidget {
  const VolumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Volume')),
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
    final volume = ref.watch(
      generalPreferencesProvider.select((state) => state.masterVolume),
    );

    return SafeArea(
      child: ListView(
        children: [
          ListSection(
            children: [
              SliderSettingsTile(
                value: volume,
                values: kMasterVolumeValues,
                onChangeEnd: (value) {
                  ref
                      .read(generalPreferencesProvider.notifier)
                      .setMasterVolume(value);
                },
                labelBuilder: (value) => '${(value * 100).round()}%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
