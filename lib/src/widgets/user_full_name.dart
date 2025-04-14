import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';

/// Displays a user name, title, flair (optional) with an optional rating.
class UserFullNameWidget extends ConsumerWidget {
  const UserFullNameWidget({
    required this.user,
    this.aiLevel,
    this.rating,
    this.provisional,
    this.shouldShowOnline = false,
    this.showFlair = true,
    this.showPatron = true,
    this.style,
    super.key,
  });

  const UserFullNameWidget.player({
    required this.user,
    required this.aiLevel,
    this.rating,
    this.provisional,
    this.shouldShowOnline = false,
    this.showFlair = true,
    this.showPatron = true,
    this.style,
    super.key,
  });

  final LightUser? user;
  final int? rating;

  /// The AI level, if the user is lichess AI.
  final int? aiLevel;

  /// Whether the rating is provisional.
  final bool? provisional;
  final TextStyle? style;

  /// Whether to show the online status.
  final bool? shouldShowOnline;

  /// Whether to show the user's flair. Defaults to `true`.
  final bool showFlair;

  /// If the user is a patron, show the patron icon in front of their name. Defaults to `true`.
  final bool showPatron;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provisionalStr = provisional == true ? '?' : '';
    final ratingStr = rating != null ? '$rating$provisionalStr' : null;
    final showRatingAsync = ref.watch(showRatingsPrefProvider);
    final shouldShowRating = switch (showRatingAsync) {
      AsyncData(:final value) => value != ShowRatings.no,
      _ => true,
    };

    final displayName =
        user?.name ??
        (aiLevel != null
            ? context.l10n.aiNameLevelAiLevel('Stockfish', aiLevel.toString())
            : context.l10n.anonymous);

    final contextTextStyle = style ?? DefaultTextStyle.of(context).style;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (user != null && shouldShowOnline == true)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(
              user?.isOnline == true ? Icons.cloud : Icons.cloud_off,
              size: contextTextStyle.fontSize,
              color: user?.isOnline == true ? context.lichessColors.good : null,
            ),
          ),
        if (showPatron && user?.isPatron == true)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(
              LichessIcons.patron,
              size: contextTextStyle.fontSize,
              color: contextTextStyle.color,
              semanticLabel: context.l10n.patronLichessPatron,
            ),
          ),
        if (user?.title != null) ...[
          Text(
            user!.title!,
            style: (style ?? const TextStyle()).copyWith(
              color:
                  user?.title == 'BOT' ? context.lichessColors.fancy : context.lichessColors.brag,
              fontWeight: user?.title == 'BOT' ? null : FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
        ],
        Flexible(
          child: Text(displayName, maxLines: 1, overflow: TextOverflow.ellipsis, style: style),
        ),
        if (showFlair && user?.flair != null) ...[
          const SizedBox(width: 5),
          CachedNetworkImage(
            imageUrl: lichessFlairSrc(user!.flair!),
            errorWidget: (_, _, _) => kEmptyWidget,
            width: contextTextStyle.fontSize ?? 16.0,
            height: contextTextStyle.fontSize ?? 16.0,
          ),
        ],
        if (shouldShowRating && ratingStr != null) ...[
          const SizedBox(width: 5),
          Text(
            ratingStr,
            style: contextTextStyle.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: contextTextStyle.fontSize != null ? contextTextStyle.fontSize! - 3 : 13,
              color: textShade(context, 0.8),
            ),
          ),
        ],
      ],
    );
  }
}
