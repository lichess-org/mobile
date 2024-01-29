import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';

/// Displays a user name, title, flair with an optional rating.
class UserFullNameWidget extends ConsumerWidget {
  const UserFullNameWidget({
    required this.user,
    this.aiLevel,
    this.rating,
    this.provisional,
    this.style,
    super.key,
  });

  const UserFullNameWidget.player({
    required this.user,
    required this.aiLevel,
    this.rating,
    this.provisional,
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provisionalStr = provisional == true ? '?' : '';
    final ratingStr = rating != null ? '($rating$provisionalStr)' : null;
    final showRatingAsync = ref.watch(showRatingsPrefProvider);
    final shouldShowRating = showRatingAsync.maybeWhen(
      data: (showRating) => showRating,
      orElse: () => false,
    );

    final displayName = user?.name ??
        (aiLevel != null
            ? context.l10n.aiNameLevelAiLevel(
                'Stockfish',
                aiLevel.toString(),
              )
            : context.l10n.anonymous);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (user?.isPatron == true)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(
              LichessIcons.patron,
              size: DefaultTextStyle.of(context).style.fontSize,
              color: DefaultTextStyle.of(context).style.color,
            ),
          ),
        if (user?.title != null) ...[
          Text(
            user!.title!,
            style: (style ?? const TextStyle()).copyWith(
              color: user?.title == 'BOT'
                  ? LichessColors.fancy
                  : LichessColors.brag,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
        ],
        Flexible(
          child: Text(
            displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        if (user?.flair != null) ...[
          const SizedBox(width: 5),
          CachedNetworkImage(
            imageUrl: lichessFlairSrc(user!.flair!),
            errorWidget: (_, __, ___) => kEmptyWidget,
            width:
                style?.fontSize ?? DefaultTextStyle.of(context).style.fontSize,
            height:
                style?.fontSize ?? DefaultTextStyle.of(context).style.fontSize,
          ),
        ],
        if (shouldShowRating && ratingStr != null) ...[
          const SizedBox(width: 5),
          Text(ratingStr),
        ],
      ],
    );
  }
}
