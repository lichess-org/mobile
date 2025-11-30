import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A Wifi icon representing that the user is currently connected (online) or not.
class ConnectedIcon extends StatelessWidget {
  const ConnectedIcon({
    required this.isConnected,
    this.shouldShowIsOnGameLabels = false,
    this.size,
    super.key,
  });

  final bool isConnected;

  /// Whether to show "is on game" labels in tooltips.
  final bool shouldShowIsOnGameLabels;

  final double? size;

  @override
  Widget build(BuildContext context) {
    final label = isConnected
        ? (shouldShowIsOnGameLabels ? 'Joined the game' : 'Online')
        : (shouldShowIsOnGameLabels ? 'Left the game' : context.l10n.noNetwork);
    return Tooltip(
      message: label,
      child: Icon(
        isConnected ? Symbols.wifi : Symbols.wifi_off,
        color: isConnected ? null : textShade(context, 0.3),
        size: size,
      ),
    );
  }
}

/// A wing icon representing a Lichess patron with its chosen color.
class PatronIcon extends StatelessWidget {
  const PatronIcon({this.color, this.size, super.key});

  final int? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final textStyle = DefaultTextStyle.of(context).style;
    final brightness = Theme.of(context).brightness;
    return Icon(
      LichessIcons.patron,
      color: color != null
          ? brightness == Brightness.dark
                ? patronColorsDark[(color! - 1)]
                : patronColorsLight[(color! - 1)]
          : null,
      size: size ?? textStyle.fontSize,
      semanticLabel: context.l10n.patronLichessPatron,
    );
  }

  static final patronColorsDark = <Color>[
    const HSLColor.fromAHSL(1.0, 90, 0.52, 0.57).toColor(),
    const HSLColor.fromAHSL(1.0, 120, 0.32, 0.62).toColor(),
    const HSLColor.fromAHSL(1.0, 151.9, 0.62, 0.62).toColor(),
    const HSLColor.fromAHSL(1.0, 190, 0.52, 0.57).toColor(),
    const HSLColor.fromAHSL(1.0, 207, 0.63, 0.66).toColor(),
    const HSLColor.fromAHSL(1.0, 220, 0.62, 0.67).toColor(),
    const HSLColor.fromAHSL(1.0, 270, 0.72, 0.73).toColor(),
    const HSLColor.fromAHSL(1.0, 310, 0.52, 0.67).toColor(),
    const HSLColor.fromAHSL(1.0, 0, 0.52, 0.65).toColor(),
    const HSLColor.fromAHSL(1.0, 37, 0.74, 0.43).toColor(),
  ];

  static final patronColorsLight = <Color>[
    const HSLColor.fromAHSL(1.0, 90, 0.60, 0.43).toColor(),
    const HSLColor.fromAHSL(1.0, 120, 0.52, 0.52).toColor(),
    const HSLColor.fromAHSL(1.0, 162.9, 0.65, 0.44).toColor(),
    const HSLColor.fromAHSL(1.0, 190, 0.57, 0.48).toColor(),
    const HSLColor.fromAHSL(1.0, 207, 0.78, 0.49).toColor(),
    const HSLColor.fromAHSL(1.0, 220, 0.60, 0.57).toColor(),
    const HSLColor.fromAHSL(1.0, 270, 0.62, 0.67).toColor(),
    const HSLColor.fromAHSL(1.0, 310, 0.56, 0.57).toColor(),
    const HSLColor.fromAHSL(1.0, 0, 0.52, 0.60).toColor(),
    const HSLColor.fromAHSL(1.0, 37, 0.74, 0.43).toColor(),
  ];
}

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
    this.onTap,
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
    this.onTap,
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

  /// Callback when the user taps on the name.
  final VoidCallback? onTap;

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

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (user != null && shouldShowOnline == true)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: ConnectedIcon(isConnected: user?.isOnline == true),
          ),
        if (showPatron && user?.isPatron == true)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: PatronIcon(size: contextTextStyle.fontSize, color: user?.patronColor),
          ),
        if (user?.title != null) ...[
          Text(
            user!.title!,
            style: (style ?? const TextStyle()).copyWith(
              color: user?.title == 'BOT'
                  ? context.lichessColors.fancy
                  : context.lichessColors.brag,
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
          CachedHttpNetworkImage(
            lichessFlairSrc(user!.flair!),
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
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}
