import 'package:flutter/widgets.dart';

import 'package:lichess_mobile/src/constants.dart';

class const RatingWidget({
  required final num rating,
  required final num deviation,
  final bool? provisional,
  final TextStyle? style,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '${rating.floor()}${provisional == true || deviation > kProvisionalDeviation ? '?' : ''}',
      style: style,
    );
  }
}
