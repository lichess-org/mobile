import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class CreateCustomTimeControlScreen extends StatelessWidget {
  final void Function(TimeIncrement playerTop, TimeIncrement playerBottom) onSubmit;
  final TimeIncrement defaultTime;

  const CreateCustomTimeControlScreen({
    required this.onSubmit,
    required this.defaultTime,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.custom)),
      body: _Body(onSubmit: onSubmit, defaultTime: defaultTime),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _Body(onSubmit: onSubmit, defaultTime: defaultTime),
    );
  }
}

class _Body extends StatefulWidget {
  final void Function(TimeIncrement timeTopPlayer, TimeIncrement timeBottomPlayer) onSubmit;
  final TimeIncrement defaultTime;

  const _Body({
    required this.onSubmit,
    required this.defaultTime,
  });

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late int timeTopPlayer;
  late int incrementTopPlayer;
  late int timeBottomPlayer;
  late int incrementBottomPlayer;

  @override
  void initState() {
    timeTopPlayer = timeBottomPlayer = widget.defaultTime.time;
    incrementTopPlayer = incrementBottomPlayer = widget.defaultTime.increment;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onSubmit(TimeIncrement topPlayer, TimeIncrement bottomPlayer) {
      Navigator.pop(context);
      Navigator.pop(context);
      widget.onSubmit(topPlayer, bottomPlayer);
    }

    return Padding(
      padding: Styles.bodyPadding,
      child: ListView(
        children: [
          _PlayerTimeSlider(
            playerNr: 1,
            time: timeTopPlayer,
            increment: incrementTopPlayer,
            updateTime: (int time) => setState(() => timeTopPlayer = time),
            updateIncrement: (int increment) => setState(() => incrementTopPlayer = increment),
          ),
          _PlayerTimeSlider(
            playerNr: 2,
            time: timeBottomPlayer,
            increment: incrementBottomPlayer,
            updateTime: (int time) => setState(() => timeBottomPlayer = time),
            updateIncrement: (int increment) => setState(() => incrementBottomPlayer = increment),
          ),
          FatButton(
            semanticsLabel: context.l10n.apply,
            child: Text(context.l10n.apply),
            onPressed: () => onSubmit(
              TimeIncrement(timeTopPlayer, incrementTopPlayer),
              TimeIncrement(timeBottomPlayer, incrementBottomPlayer),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerTimeSlider extends StatelessWidget {
  const _PlayerTimeSlider({
    required this.playerNr,
    required this.time,
    required this.increment,
    required this.updateTime,
    required this.updateIncrement,
  });

  final int playerNr;
  final int time;
  final int increment;
  final void Function(int time) updateTime;
  final void Function(int time) updateIncrement;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Text(
          '${context.l10n.player} $playerNr',
          style: Styles.title,
        ),
        PlatformListTile(
          padding: EdgeInsets.zero,
          title: Text(
            '${context.l10n.time}: ${context.l10n.nbMinutes(secToMin(time))}',
          ),
          subtitle: NonLinearSlider(
            value: time,
            values: kAvailableTimesInSeconds,
            labelBuilder: _clockTimeLabel,
            onChange: Theme.of(context).platform == TargetPlatform.iOS
                ? (num value) {
                    updateTime(value.toInt());
                  }
                : null,
            onChangeEnd: (num value) {
              updateTime(value.toInt());
            },
          ),
        ),
        PlatformListTile(
          padding: EdgeInsets.zero,
          title: Text(
            '${context.l10n.increment}: ${context.l10n.nbSeconds(increment)}',
          ),
          subtitle: NonLinearSlider(
            value: increment,
            values: kAvailableIncrementsInSeconds,
            labelBuilder: (num sec) => sec.toString(),
            onChange: Theme.of(context).platform == TargetPlatform.iOS
                ? (num value) {
                    updateIncrement(value.toInt());
                  }
                : null,
            onChangeEnd: (num value) {
              updateIncrement(value.toInt());
            },
          ),
        ),
      ],
    );
  }
}

int secToMin(num sec) => sec ~/ 60;

String _clockTimeLabel(num seconds) {
  switch (seconds) {
    case 0:
      return '0';
    case 45:
      return '¾';
    case 30:
      return '½';
    case 15:
      return '¼';
    default:
      return secToMin(seconds).toString();
  }
}
