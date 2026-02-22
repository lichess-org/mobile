import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';

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
