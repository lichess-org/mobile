import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' hide Tuple2;
import 'package:tuple/tuple.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/async_value.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/list_tile_choice.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/features/user/model/user.dart';
import 'package:lichess_mobile/src/features/auth/ui/auth_widget.dart';
import 'package:lichess_mobile/src/features/auth/ui/auth_widget_notifier.dart';
import 'package:lichess_mobile/src/features/auth/data/auth_repository.dart';
import 'package:lichess_mobile/src/features/user/data/user_repository.dart';
import '../../data/play_preferences.dart';
import '../../model/game.dart';
import '../../model/computer_opponent.dart';
import '../board/board_screen.dart';
import './time_control_modal.dart';
import './play_action_notifier.dart';

const _stockfishName = 'Fairy-Stockfish 14';

final maiaBotsProvider =
    FutureProvider.autoDispose<List<Tuple2<User, UserStatus>>>((ref) async {
  final userRepo = ref.watch(userRepositoryProvider);
  final maiaBotsTask = TaskEither.sequenceList([
    userRepo.getUserTask('maia1'),
    userRepo.getUserTask('maia5'),
    userRepo.getUserTask('maia9'),
  ]);
  final maiaStatusesTask =
      userRepo.getUsersStatusTask(['maia1', 'maia5', 'maia9']);
  final task = maiaBotsTask.flatMap((bots) => maiaStatusesTask.map(
        (statuses) => bots
            .map((bot) => Tuple2<User, UserStatus>(
                bot, statuses.firstWhere((s) => s.id == bot.id)))
            .toList(),
      ));
  final either = await task.run();
  // retry on error, cache indefinitely on success
  return either.match((error) => throw error, (data) {
    ref.keepAlive();
    return data;
  });
});

class PlayScreen extends ConsumerWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformWidget(
      androidBuilder: _androidBuilder(ref),
      iosBuilder: _iosBuilder(ref),
    );
  }

  Widget Function(BuildContext context) _androidBuilder(WidgetRef ref) {
    return (BuildContext context) {
      final authState = ref.watch(authStateChangesProvider);
      return Scaffold(
        appBar: AppBar(title: const Text('lichess.org'), actions: const [
          AuthWidget(),
        ]),
        body: Center(
          child: authState.maybeWhen(
            data: (account) => PlayForm(account: account),
            orElse: () => const CircularProgressIndicator.adaptive(),
          ),
        ),
      );
    };
  }

  Widget Function(BuildContext context) _iosBuilder(WidgetRef ref) {
    return (BuildContext context) {
      final authState = ref.watch(authStateChangesProvider);
      return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(trailing: AuthWidget()),
        child: Center(
          child: authState.maybeWhen(
            data: (account) => PlayForm(account: account),
            orElse: () => const CircularProgressIndicator.adaptive(),
          ),
        ),
      );
    };
  }
}

class PlayForm extends ConsumerWidget {
  const PlayForm({this.account, super.key});

  final User? account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maiaBots = ref.watch(maiaBotsProvider);
    final opponentPref = ref.watch(computerOpponentPrefProvider);
    final maiaStrength = ref.watch(maiaStrengthProvider);
    final stockfishLevel = ref.watch(stockfishLevelProvider);
    final timeControlPref = ref.watch(timeControlPrefProvider);
    final authActionsAsync = ref.watch(authWidgetProvider);
    final playActionAsync = ref.watch(playActionProvider);

    ref.listen<AsyncValue<Game?>>(playActionProvider, (_, state) {
      state.showSnackbarOnError(context);

      if (state.valueOrNull is Game && account != null) {
        ref.invalidate(playActionProvider);
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute<void>(
              builder: (context) =>
                  BoardScreen(game: state.value!, account: account!)),
        );
      }
    });

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(
            context.l10n.playWithTheMachine,
            style: const TextStyle(fontSize: 20),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          CupertinoSlidingSegmentedControl<ComputerOpponent>(
            onValueChanged: (opponent) {
              if (opponent != null) {
                ref.read(computerOpponentPrefProvider.notifier).set(opponent);
              }
            },
            groupValue: opponentPref,
            children: const {
              ComputerOpponent.maia: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Maia'),
              ),
              ComputerOpponent.stockfish: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Stockfish 14'),
              ),
            },
          ),
          const SizedBox(height: 10),
          Builder(builder: (BuildContext context) {
            if (opponentPref == ComputerOpponent.maia) {
              return maiaBots.when(
                data: (bots) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                          'Maia is a human-like neural network chess engine. It was trained by learning from over 10 million Lichess games. It is an ongoing research project aiming to make a more human-friendly, useful, and fun chess AI. For more information go to maiachess.com. '),
                      const SizedBox(height: 10),
                      ListTileChoice(
                        choices: MaiaStrength.values,
                        selectedItem: maiaStrength,
                        titleBuilder: (ms) => Text(ms.name),
                        subtitleBuilder: (ms) => Row(
                          children:
                              [Perf.blitz, Perf.rapid, Perf.classical].map((p) {
                            final bot = bots
                                .firstWhere((b) => b.item1.id == ms.name)
                                .item1;
                            return Semantics(
                              label: p.name,
                              child: Row(children: [
                                Icon(p.icon, size: 18.0),
                                const SizedBox(width: 3.0),
                                Text(bot.perfs[p]!.rating.toString()),
                                const SizedBox(width: 12.0),
                              ]),
                            );
                          }).toList(),
                        ),
                        onSelectedItemChanged: (value) {
                          ref.read(maiaStrengthProvider.notifier).set(value);
                        },
                      ),
                    ],
                  );
                },
                error: (err, st) {
                  debugPrint(
                      'SEVERE [PlayScreen] could not load bot info: ${err.toString()}\n$st');
                  return const Text('Could not load bot ratings.');
                },
                loading: () => const ButtonLoadingIndicator(),
              );
            }

            int value = stockfishLevel;
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  const Text(
                      'Stockfish is a strong open source engine, 13-time winner of the Top Chess Engine Championship.'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(context.l10n.strength),
                      Expanded(
                        child: Slider(
                          value: value.toDouble(),
                          min: 1,
                          max: 8,
                          divisions: 7,
                          label: '${context.l10n.level} $value',
                          semanticFormatterCallback: (double newValue) {
                            return '${context.l10n.level} ${newValue.round()}';
                          },
                          onChanged: opponentPref != ComputerOpponent.stockfish
                              ? null
                              : (double newVal) {
                                  setState(() {
                                    value = newVal.round();
                                  });
                                },
                          onChangeEnd: (double value) {
                            ref
                                .read(stockfishLevelProvider.notifier)
                                .set(value.round());
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            });
          }),
          const SizedBox(height: 20),
          SemanticsButton(
            label:
                '${context.l10n.timeControl} ${timeControlPref.perf.name} ${timeControlPref.value.toString()}',
            child: OutlinedButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return const TimeControlModal();
                  },
                );
              },
              style: _buttonStyle,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(timeControlPref.perf.icon, size: 20),
                          const SizedBox(width: 5),
                          Text(timeControlPref.value.toString())
                        ],
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 28.0),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: account == null
                ? authActionsAsync.isLoading
                    ? null
                    : () => ref.read(authWidgetProvider.notifier).signIn()
                : playActionAsync.isLoading
                    ? null
                    : () => ref
                        .read(playActionProvider.notifier)
                        .createGame(account: account!),
            style: _buttonStyle,
            child: authActionsAsync.isLoading || playActionAsync.isLoading
                ? const ButtonLoadingIndicator()
                : Text(account == null
                    // TODO translate
                    ? 'Sign in to start playing'
                    : context.l10n.play),
          ),
        ],
      ),
    );
  }
}

final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
  textStyle: const TextStyle(fontSize: 20),
);
