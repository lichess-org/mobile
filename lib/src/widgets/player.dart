import 'package:flutter/material.dart';

import '../constants.dart';
import './countdown_clock.dart';

class Player extends StatelessWidget {
  final String name;
  final int? rating;
  final String? title;
  final Duration clock;
  final bool active;

  const Player(
      {required this.name,
      this.title,
      this.rating,
      required this.active,
      required this.clock,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget nameW = Text(name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600));
    final Widget ratingW = rating != null
        ? Text(rating.toString(), style: const TextStyle(fontSize: 13))
        : kEmptyWidget;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: title != null
                ? [
                    Text(title!,
                        style: const TextStyle(
                            fontSize: 20, color: Colors.orange)),
                    const SizedBox(width: 5),
                    nameW,
                    const SizedBox(width: 3),
                    ratingW,
                  ]
                : [
                    nameW,
                    const SizedBox(width: 3),
                    ratingW,
                  ],
          ),
          CountdownClock(
            duration: clock,
            active: active,
          ),
        ],
      ),
    );
  }
}
