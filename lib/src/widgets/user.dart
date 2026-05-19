import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/http_network_image.dart';
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
          HttpNetworkImageWidget(
            lichessFlairSrc(user!.flair!),
            errorBuilder: (_, _, _) => kEmptyWidget,
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

/// A circular avatar for a Lichess user.
///
/// Shows the user's flair if available, otherwise their initials with a
/// deterministic background color derived from the first letter of their name.
class UserAvatar extends ConsumerStatefulWidget {
  const UserAvatar(this.user, {this.radius = 20.0, super.key});

  final LightUser user;
  final double radius;

  @override
  ConsumerState<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends ConsumerState<UserAvatar> {
  bool _errorLoadingFlair = false;

  @override
  Widget build(BuildContext context) {
    final client = ref.watch(defaultClientProvider);
    final user = widget.user;
    final initial = user.name[0].toUpperCase();
    final showFlair = user.flair != null && !_errorLoadingFlair;

    return CircleAvatar(
      radius: widget.radius,
      foregroundImage: showFlair ? HttpNetworkImage(lichessFlairSrc(user.flair!), client) : null,
      onForegroundImageError: user.flair != null
          ? (_, _) => setState(() => _errorLoadingFlair = true)
          : null,
      backgroundColor: showFlair
          ? ColorScheme.of(context).surfaceContainer
          : _colorForInitial(initial, Theme.of(context).brightness),
      child: showFlair ? null : Text(initial, style: const TextStyle(color: Colors.white)),
    );
  }
}

Color _colorForInitial(String initial, Brightness brightness) {
  // Palettes are sorted by hue (red → orange → lime → green → teal → cyan →
  // blue → indigo → purple → pink), with neutrals (blueGrey, brown) woven in.
  // All colors verified for WCAG AA white-text contrast (≥4.5:1).
  // Dark mode uses lighter shades where contrast still holds.
  //
  // Index formula: (codeUnit * 11) % 26.
  // 11 is coprime with 26, so it produces a permutation of 0‥25.
  // Each consecutive letter lands ~11 steps away in the hue-sorted palette,
  // i.e. ~152° apart on the color wheel — giving strong visual variety for
  // alphabetically close names (A/B, H/I, etc.).
  final colors = brightness == Brightness.dark
      ? [
          // ── reds / warm (~0–25°) ──────────────────────────────────────────
          Colors.red.shade700,
          Colors.redAccent.shade700,
          Colors.deepOrange.shade900,
          Colors.brown.shade600,
          // ── yellow-greens (~65–130°) ──────────────────────────────────────
          Colors.lime.shade900,
          Colors.lightGreen.shade900,
          Colors.green.shade800,
          // ── teals / cyans (~170–200°) ─────────────────────────────────────
          Colors.teal.shade700,
          Colors.teal.shade900,
          Colors.cyan.shade900,
          Colors.lightBlue.shade900,
          // ── blue-greys (desaturated ~200°) ────────────────────────────────
          Colors.blueGrey.shade600,
          Colors.blueGrey.shade800,
          // ── blues (~215°) ─────────────────────────────────────────────────
          Colors.blue.shade800,
          Colors.blue.shade900,
          // ── indigos (~230–245°) ───────────────────────────────────────────
          Colors.indigo.shade500,
          Colors.indigo.shade600,
          Colors.indigo.shade800,
          Colors.indigoAccent.shade700,
          // ── deep purples (~265–275°) ──────────────────────────────────────
          Colors.deepPurple.shade500,
          Colors.deepPurple.shade700,
          Colors.deepPurpleAccent.shade700,
          // ── purples (~285–295°) ───────────────────────────────────────────
          Colors.purple.shade500,
          Colors.purple.shade800,
          // ── pinks (~330–350°) ─────────────────────────────────────────────
          Colors.pink.shade700,
          Colors.pinkAccent.shade700,
        ]
      : [
          // ── reds / warm (~0–25°) ──────────────────────────────────────────
          Colors.red.shade800,
          Colors.redAccent.shade700,
          Colors.deepOrange.shade900,
          Colors.brown.shade700,
          // ── yellow-greens (~65–130°) ──────────────────────────────────────
          Colors.lime.shade900,
          Colors.lightGreen.shade900,
          Colors.green.shade800,
          // ── teals / cyans (~170–200°) ─────────────────────────────────────
          Colors.teal.shade700,
          Colors.teal.shade900,
          Colors.cyan.shade900,
          Colors.lightBlue.shade900,
          // ── blue-greys (desaturated ~200°) ────────────────────────────────
          Colors.blueGrey.shade700,
          Colors.blueGrey.shade900,
          // ── blues (~215°) ─────────────────────────────────────────────────
          Colors.blue.shade800,
          Colors.blue.shade900,
          // ── indigos (~230–245°) ───────────────────────────────────────────
          Colors.indigo.shade600,
          Colors.indigo.shade700,
          Colors.indigo.shade900,
          Colors.indigoAccent.shade700,
          // ── deep purples (~265–275°) ──────────────────────────────────────
          Colors.deepPurple.shade700,
          Colors.deepPurple.shade800,
          Colors.deepPurpleAccent.shade700,
          // ── purples (~285–295°) ───────────────────────────────────────────
          Colors.purple.shade700,
          Colors.purple.shade900,
          // ── pinks (~330–350°) ─────────────────────────────────────────────
          Colors.pink.shade800,
          Colors.pinkAccent.shade700,
        ];
  // Multiply by 11 (coprime with 26) so consecutive letters jump ~152° in hue.
  return colors[(initial.codeUnitAt(0) * 11) % colors.length];
}
