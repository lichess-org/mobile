import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';

/// A widget that displays a variant [Icon] followed by [variant.label], sized and colored to match
/// the surrounding text style, with a description below. Intended for use as a [labelBuilder] in
/// [showChoicePicker].
class VariantLabel extends StatelessWidget {
  const VariantLabel(this.variant, {super.key});

  final Variant variant;

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context).style;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(variant.icon, size: style.fontSize, color: style.color),
              ),
              const WidgetSpan(child: SizedBox(width: 8)),
              TextSpan(text: variant.label),
            ],
          ),
        ),
        Text(
          variant.description(context.l10n),
          style: Styles.subtitle.copyWith(
                        color: textShade(context, Styles.subtitleOpacity),
                      ),
        ),
      ],
    );
  }
}

/// A widget that displays a [AppBarTitleText] preceded by an icon based on the variant type.
class VariantAppBarTitle extends StatelessWidget {
  const VariantAppBarTitle({super.key, required this.variant, required this.title});

  final Variant variant;
  final String title;

  static const excludedIcons = [Variant.standard, Variant.fromPosition];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!excludedIcons.contains(variant)) ...[Icon(variant.icon), const SizedBox(width: 5.0)],
        Flexible(child: AppBarTitleText(title)),
      ],
    );
  }
}
