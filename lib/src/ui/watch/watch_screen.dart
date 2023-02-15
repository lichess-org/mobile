import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/common/styles.dart';

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch'),
      ),
      body: _WatchScaffold(
        child: ListView(
          padding: Styles.verticalBodyPadding,
          children: const [Text('TODO')],
        ),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      child: _WatchScaffold(
        child: const CustomScrollView(
          slivers: const [
            CupertinoNavigationBar(
              middle: Text('Watch'),
            )
          ],
        ),
      ),
    );
  }
}

class _WatchScaffold extends StatelessWidget {
  const _WatchScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}
