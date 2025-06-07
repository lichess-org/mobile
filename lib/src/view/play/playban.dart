import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/clock.dart' show CountdownClockBuilder;

class PlaybanMessage extends StatelessWidget {
  const PlaybanMessage({required this.playban, this.centerText = false, super.key});

  final TemporaryBan playban;
  final bool centerText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: centerText ? Alignment.center : Alignment.topLeft,
          child: Text(
            context.l10n.sorry,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22.0),
          ),
        ),
        const SizedBox(height: 6.0),
        Align(
          alignment: centerText ? Alignment.center : Alignment.topLeft,
          child: Text(context.l10n.weHadToTimeYouOutForAWhile),
        ),
        const SizedBox(height: 16.0),
        CountdownClockBuilder(
          timeLeft: playban.duration,
          clockUpdatedAt: playban.date,
          active: true,
          tickInterval: const Duration(seconds: 1),
          builder: (BuildContext context, Duration timeleft) => Center(
            child: Text(
              context.l10n.timeagoNbMinutesRemaining(timeleft.inMinutes),
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Align(
          alignment: centerText ? Alignment.center : Alignment.topLeft,
          child: Text(context.l10n.why, style: const TextStyle(fontSize: 20.0)),
        ),
        const SizedBox(height: 6.0),
        Text(context.l10n.pleasantChessExperience),
        Text(context.l10n.goodPractice),
        Text(context.l10n.potentialProblem),
        const SizedBox(height: 6.0),
        Align(
          alignment: centerText ? Alignment.center : Alignment.topLeft,
          child: Text(context.l10n.howToAvoidThis, style: const TextStyle(fontSize: 20.0)),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: '\u2022', style: TextStyle(height: 1.25, fontSize: 20.0)),
              const TextSpan(text: ' '),
              TextSpan(text: context.l10n.playEveryGame, style: const TextStyle(height: 1.25)),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: '\u2022', style: TextStyle(height: 1.25, fontSize: 20.0)),
              const TextSpan(text: ' '),
              TextSpan(text: context.l10n.tryToWin, style: const TextStyle(height: 1.25)),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: '\u2022', style: TextStyle(height: 1.25, fontSize: 20.0)),
              const TextSpan(text: ' '),
              TextSpan(text: context.l10n.resignLostGames, style: const TextStyle(height: 1.25)),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        Text.rich(
          TextSpan(
            text: context.l10n.temporaryInconvenience,
            children: [
              const TextSpan(text: ' '),
              TextSpan(text: context.l10n.wishYouGreatGames),
              const TextSpan(text: ' '),
              TextSpan(text: context.l10n.thankYouForReading),
            ],
          ),
        ),
      ],
    );
  }
}
