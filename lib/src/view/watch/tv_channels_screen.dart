import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/tv/tv_repository.dart';

part 'tv_channels_screen.g.dart';

@riverpod
Future<TvChannels> tvChannels(TvChannelsRef ref) {
  final repo = ref.watch(tvRepositoryProvider);
  return Result.release(repo.channels());
}

class TvChannelsScreen extends ConsumerStatefulWidget {
  const TvChannelsScreen({super.key});

  @override
  ConsumerState<TvChannelsScreen> createState() => _TvChannelsScreenState();
}

class _TvChannelsScreenState extends ConsumerState<TvChannelsScreen> {
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lichess TV'),
      ),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(
    BuildContext context,
  ) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Lichess TV'),
      ),
      child: _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channels = ref.watch(tvChannelsProvider);

    return const Center(
      child: Text('Lichess TV'),
    );
  }
}
