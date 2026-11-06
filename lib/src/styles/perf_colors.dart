import 'dart:math' as math;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:material_ui/material_ui.dart';

/// HCT hue of each [Perf] icon color.
///
/// The hues are spread all around the wheel but clear of the lichess brag gold (HCT hue 73), the
/// color of tournament and top games icons shown next to perf icons. The time controls, often shown
/// together, are the farthest apart: bullet leans towards crimson and blitz towards orange, so that
/// they stay apart in the light theme, where the dark tone makes red hues hard to tell apart.
double _perfHue(Perf perf) => switch (perf) {
  .ultraBullet => 318,
  .bullet => 354,
  .blitz => 46,
  .rapid => 128,
  .classical => 200,
  .correspondence => 272,
  .fromPosition => 182,
  .chess960 => 218,
  .antichess => 344,
  .kingOfTheHill => 110,
  .threeCheck => 20,
  .atomic => 290,
  .horde => 164,
  .racingKings => 254,
  .crazyhouse => 146,
  .puzzle => 236,
  .storm => 308,
  .streak => 92,
};

/// HCT chroma of all the perf colors.
const double _kPerfColorChroma = 44;

/// HCT tone of the perf colors in [brightness].
double _perfColorTone(Brightness brightness) => brightness == Brightness.light ? 45 : 74;

/// Icon colors of each [Perf] for a theme color scheme.
@immutable
class const PerfColors(final IMap<Perf, Color> colors) extends ThemeExtension<PerfColors> {
  /// Builds the perf colors for [colorScheme]: same chroma and tone for all of them, so that none
  /// stands out, and a tone readable on the scheme surfaces.
  factory fromColorScheme(ColorScheme colorScheme) {
    final tone = _perfColorTone(colorScheme.brightness);
    return PerfColors(
      IMap({
        for (final perf in Perf.values)
          perf: Color(Hct.from(_perfHue(perf), _kPerfColorChroma, tone).toInt()),
      }),
    );
  }

  Color of(Perf perf) => colors[perf]!;

  @override
  PerfColors copyWith({IMap<Perf, Color>? colors}) => PerfColors(colors ?? this.colors);

  @override
  PerfColors lerp(ThemeExtension<PerfColors>? other, double t) {
    if (other is! PerfColors) {
      return this;
    }
    return PerfColors(
      IMap({for (final perf in Perf.values) perf: Color.lerp(of(perf), other.of(perf), t)!}),
    );
  }
}

extension PerfColorsBuildContext on BuildContext {
  /// The icon colors of each [Perf] for the current theme.
  PerfColors get perfColors =>
      Theme.of(this).extension<PerfColors>() ?? PerfColors.fromColorScheme(ColorScheme.of(this));

  /// [color] toned down to the chroma and tone of the perf colors, keeping its hue, so that an icon
  /// of this color does not stand out next to perf icons (e.g. the brag color of a tournament cup).
  Color perfToned(Color color) {
    final hct = Hct.fromInt(color.toARGB32());
    return Color(
      Hct.from(
        hct.hue,
        math.min(hct.chroma, _kPerfColorChroma),
        _perfColorTone(Theme.of(this).brightness),
      ).toInt(),
    );
  }
}

extension PerfColor on Perf {
  /// The color of this perf icon in the current theme.
  Color color(BuildContext context) => context.perfColors.of(this);
}

extension TvChannelColor on TvChannel {
  /// The color of this channel icon in the current theme: the perf color of its games, the toned
  /// brag color for the top games channel, and the toned color of the BOT title for the bot and
  /// computer channels.
  Color color(BuildContext context) => switch (this) {
    .best => context.perfToned(context.lichessColors.brag),
    .bot || .computer => context.perfToned(context.lichessColors.fancy),
    _ => perf!.color(context),
  };
}
