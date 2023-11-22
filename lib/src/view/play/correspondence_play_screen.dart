import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/expanded_section.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/settings/play_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

import 'common_play_widgets.dart';

class CorrespondencePlayScreen extends StatelessWidget {
  const CorrespondencePlayScreen();

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: _CupertinoBody(),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return const _AndroidBody();
  }
}

class _AndroidBody extends StatefulWidget {
  const _AndroidBody();

  @override
  State<_AndroidBody> createState() => _AndroidBodyState();
}

class _AndroidBodyState extends State<_AndroidBody>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.correspondence),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: context.l10n.createAGame),
            Tab(text: context.l10n.preferencesNotifyChallenge),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          _CreateGameBody(),
          _ChallengesBody(),
        ],
      ),
    );
  }
}

enum View { create, challenges }

class _CupertinoBody extends StatefulWidget {
  const _CupertinoBody();

  @override
  _CupertinoBodyState createState() => _CupertinoBodyState();
}

class _CupertinoBodyState extends State<_CupertinoBody> {
  View _selectedSegment = View.create;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: Styles.bodyPadding,
            child: CupertinoSlidingSegmentedControl<View>(
              groupValue: _selectedSegment,
              children: {
                View.create: Text(context.l10n.createAGame),
                View.challenges: Text(context.l10n.preferencesNotifyChallenge),
              },
              onValueChanged: (View? view) {
                if (view != null) {
                  setState(() {
                    _selectedSegment = view;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: _selectedSegment == View.create
                ? const _CreateGameBody()
                : const _ChallengesBody(),
          ),
        ],
      ),
    );
  }
}

class _ChallengesBody extends ConsumerStatefulWidget {
  const _ChallengesBody();

  @override
  ConsumerState<_ChallengesBody> createState() => _ChallengesBodyState();
}

class _ChallengesBodyState extends ConsumerState<_ChallengesBody> {
  @override
  Widget build(BuildContext context) {
    final seeksAsync = ref.watch(correspondenceSeeksProvider);
    final session = ref.watch(authSessionProvider);

    return seeksAsync.when(
      data: (seeks) {
        return ListView.separated(
          itemCount: seeks.length,
          separatorBuilder: (context, index) =>
              const PlatformDivider(height: 1, cupertinoHasLeading: true),
          itemBuilder: (context, index) {
            final seek = seeks[index];
            final time = seek.days == null
                ? '∞'
                : '${context.l10n.daysPerTurn}: ${seek.days}';
            final subtitle = seek.rated
                ? '${context.l10n.rated} • $time'
                : '${context.l10n.casual} • $time';
            final isMySeek =
                UserId.fromUserName(seek.username) == session?.user.id;

            return Container(
              color: isMySeek ? LichessColors.green.withOpacity(0.2) : null,
              child: Slidable(
                endActionPane: isMySeek
                    ? ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.3,
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) async {},
                            backgroundColor: LichessColors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.cancel,
                            label: context.l10n.cancel,
                          ),
                        ],
                      )
                    : ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.3,
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) async {},
                            backgroundColor: LichessColors.green,
                            foregroundColor: Colors.white,
                            icon: Icons.check,
                            label: context.l10n.accept,
                          ),
                        ],
                      ),
                child: PlatformListTile(
                  padding: Styles.bodyPadding,
                  leading: Icon(seek.perf.icon),
                  trailing: Icon(
                    seek.side == null
                        ? LichessIcons.adjust
                        : seek.side == Side.white
                            ? LichessIcons.circle
                            : LichessIcons.circle_empty,
                  ),
                  title: PlayerTitle(
                    userName: seek.username,
                    title: seek.title,
                    rating: seek.rating,
                    provisional: seek.provisional,
                  ),
                  subtitle: Text(subtitle),
                  onTap: isMySeek ? null : () {},
                ),
              ),
            );
          },
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator.adaptive());
      },
      error: (error, stack) =>
          const Center(child: Text('Could not load challenges.')),
    );
  }
}

class _CreateGameBody extends ConsumerWidget {
  const _CreateGameBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    final preferences = ref.watch(playPreferencesProvider);
    final session = ref.watch(authSessionProvider);

    final UserPerf? userPerf = account.maybeWhen(
      data: (data) {
        if (data == null) {
          return null;
        }
        return data.perfs[Perf.correspondence];
      },
      orElse: () => null,
    );

    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Builder(
            builder: (context) {
              int daysPerTurn = preferences.correspondenceDaysPerTurn ?? -1;
              return StatefulBuilder(
                builder: (context, setState) {
                  return PlatformListTile(
                    harmonizeCupertinoTitleStyle: true,
                    title: Text.rich(
                      TextSpan(
                        text: '${context.l10n.daysPerTurn}: ',
                        children: [
                          TextSpan(
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            text: _daysLabel(daysPerTurn),
                          ),
                        ],
                      ),
                    ),
                    subtitle: NonLinearSlider(
                      value: daysPerTurn,
                      values: kAvailableDaysPerTurn,
                      labelBuilder: _daysLabel,
                      onChange: defaultTargetPlatform == TargetPlatform.iOS
                          ? (num value) {
                              setState(() {
                                daysPerTurn = value.toInt();
                              });
                            }
                          : null,
                      onChangeEnd: (num value) {
                        setState(() {
                          daysPerTurn = value.toInt();
                        });
                        ref
                            .read(playPreferencesProvider.notifier)
                            .setCorrespondenceDaysPerTurn(
                              value == -1 ? null : value.toInt(),
                            );
                      },
                    ),
                  );
                },
              );
            },
          ),
          PlatformListTile(
            harmonizeCupertinoTitleStyle: true,
            title: Text(context.l10n.variant),
            trailing: AdaptiveTextButton(
              onPressed: () {
                showChoicePicker(
                  context,
                  choices: [Variant.standard, Variant.chess960],
                  selectedItem: preferences.correspondenceVariant,
                  labelBuilder: (Variant variant) => Text(variant.label),
                  onSelectedItemChanged: (Variant variant) {
                    ref
                        .read(playPreferencesProvider.notifier)
                        .setCorrespondenceVariant(variant);
                  },
                );
              },
              child: Text(preferences.correspondenceVariant.label),
            ),
          ),
          ExpandedSection(
            expand: preferences.correspondenceRated == false,
            child: PlatformListTile(
              harmonizeCupertinoTitleStyle: true,
              title: Text(context.l10n.side),
              trailing: AdaptiveTextButton(
                onPressed: () {
                  showChoicePicker<PlayableSide>(
                    context,
                    choices: PlayableSide.values,
                    selectedItem: preferences.correspondenceSide,
                    labelBuilder: (PlayableSide side) =>
                        Text(_customSideLabel(context, side)),
                    onSelectedItemChanged: (PlayableSide side) {
                      ref
                          .read(playPreferencesProvider.notifier)
                          .setCorrespondenceSide(side);
                    },
                  );
                },
                child: Text(
                  _customSideLabel(context, preferences.correspondenceSide),
                ),
              ),
            ),
          ),
          if (session != null)
            PlatformListTile(
              harmonizeCupertinoTitleStyle: true,
              title: Text(context.l10n.rated),
              trailing: Switch.adaptive(
                value: preferences.correspondenceRated,
                onChanged: (bool value) {
                  ref
                      .read(playPreferencesProvider.notifier)
                      .setCorrespondenceRated(value);
                },
              ),
            ),
          if (userPerf != null)
            PlayRatingRange(
              perf: userPerf,
              ratingRange: preferences.correspondenceRatingRange,
              setRatingRange: (int subtract, int add) {
                ref
                    .read(playPreferencesProvider.notifier)
                    .setCorrespondenceRatingRange(subtract, add);
              },
            ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FatButton(
              semanticsLabel: context.l10n.createAGame,
              onPressed: () {},
              child: Text(context.l10n.createAGame),
            ),
          ),
        ],
      ),
    );
  }
}

String _daysLabel(num days) {
  return days == -1 ? '∞' : days.toString();
}

String _customSideLabel(BuildContext context, PlayableSide side) {
  switch (side) {
    case PlayableSide.white:
      return context.l10n.white;
    case PlayableSide.black:
      return context.l10n.black;
    case PlayableSide.random:
      return context.l10n.randomColor;
  }
}
