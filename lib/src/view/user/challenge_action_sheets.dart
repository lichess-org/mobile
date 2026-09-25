import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_service.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:material_ui/material_ui.dart';

/// Action sheets for incoming challenges.
///
/// They live in the view layer because they need a [BuildContext], which the model layer must not
/// reach for. The service exposes the operations they trigger ([ChallengeService.acceptChallenge]
/// and [ChallengeService.declineChallenge]).
extension ChallengeActionSheets on ChallengeService {
  void showDeclineDialog(BuildContext context, ChallengeId id) {
    showAdaptiveActionSheet<ChallengeDeclineReason>(
      context: context,
      title: Text(context.l10n.decline),
      actions: ChallengeDeclineReason.values
          .map(
            (reason) => BottomSheetAction(
              makeLabel: (context) => Text(reason.label(context.l10n)),
              leading: Icon(Icons.close, color: context.lichessColors.error),
              isDestructiveAction: true,
              onPressed: () {
                declineChallenge(id, reason: reason);
              },
            ),
          )
          .toList(),
    );
  }

  void showConfirmDialog(
    BuildContext context,
    Challenge challenge, {
    String? title,
    bool fromLink = false,
  }) {
    showAdaptiveActionSheet<void>(
      context: context,
      title: challenge.challenger != null && challenge.variant.isPlaySupported
          ? Text(
              title ??
                  '${challenge.challenger!.user.name} challenges you: ${challenge.description(context.l10n)}',
            )
          : null,
      actions: [
        if (challenge.variant.isPlaySupported)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.accept),
            leading: Icon(Icons.check, color: context.lichessColors.good),
            isDefaultAction: true,
            onPressed: () async => await acceptChallenge(challenge.id),
          ),
        if (fromLink && Theme.of(context).platform != TargetPlatform.iOS)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.cancel),
            leading: const Icon(Icons.close),
            onPressed: () {},
          )
        else if (!fromLink)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.decline),
            leading: Icon(Icons.clear, color: context.lichessColors.error),
            isDestructiveAction: true,
            onPressed: () => showDeclineDialog(context, challenge.id),
          ),
      ],
    );
  }
}
