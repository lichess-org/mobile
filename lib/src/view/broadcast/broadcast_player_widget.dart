import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/styles/styles.dart';

class BroadcastPlayerWidget extends ConsumerWidget {
  const BroadcastPlayerWidget({
    super.key,
    this.federation,
    required this.title,
    required this.name,
    this.rating,
    this.textStyle,
  });

  final String? federation;
  final String? title;
  final int? rating;
  final String name;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        if (federation != null) ...[
          Image.asset('assets/images/fide-fed/$federation.png', height: 12),
          const SizedBox(width: 5),
        ],
        if (title != null) ...[
          Text(
            title!,
            style: TextStyle(
              color: (title == 'BOT') ? context.lichessColors.fancy : context.lichessColors.brag,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
        ],
        Flexible(child: Text(name, style: textStyle, overflow: TextOverflow.ellipsis)),
        if (rating != null) ...[
          const SizedBox(width: 5),
          Text(rating.toString(), overflow: TextOverflow.ellipsis),
        ],
      ],
    );
  }
}
