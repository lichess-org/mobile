import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/rating.dart';
import 'package:lichess_mobile/src/model/settings/play_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

class PlayRatingRange extends StatefulWidget {
  const PlayRatingRange({
    required this.perf,
    required this.ratingRange,
    required this.setRatingRange,
    super.key,
  });

  final UserPerf perf;
  final (int, int) ratingRange;
  final void Function(int, int) setRatingRange;

  @override
  State<PlayRatingRange> createState() => _PlayRatingRangeState();
}

class _PlayRatingRangeState extends State<PlayRatingRange> {
  late int _subtract;
  late int _add;

  @override
  void initState() {
    super.initState();
    final (subtract, add) = widget.ratingRange;
    _subtract = subtract;
    _add = add;
  }

  @override
  Widget build(BuildContext context) {
    final isRatingRangeAvailable = widget.perf.provisional != true;
    return Opacity(
      opacity: isRatingRangeAvailable ? 1 : 0.5,
      child: PlatformListTile(
        harmonizeCupertinoTitleStyle: true,
        title: Text(
          context.l10n.ratingRange,
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Column(
                children: [
                  NonLinearSlider(
                    value: _subtract,
                    values: kSubtractingRatingRange,
                    onChange: defaultTargetPlatform == TargetPlatform.iOS
                        ? (num value) {
                            setState(() {
                              _subtract = value.toInt();
                            });
                          }
                        : null,
                    onChangeEnd: isRatingRangeAvailable
                        ? (num value) {
                            widget.setRatingRange(value.toInt(), _add);
                          }
                        : null,
                  ),
                  Center(
                    child: Text('$_subtract'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            RatingWidget(
              rating: widget.perf.rating,
              deviation: widget.perf.ratingDeviation,
              provisional: widget.perf.provisional,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Column(
                children: [
                  NonLinearSlider(
                    value: _add,
                    values: kAddingRatingRange,
                    onChange: defaultTargetPlatform == TargetPlatform.iOS
                        ? (num value) {
                            setState(() {
                              _add = value.toInt();
                            });
                          }
                        : null,
                    onChangeEnd: isRatingRangeAvailable
                        ? (num value) {
                            widget.setRatingRange(_subtract, value.toInt());
                          }
                        : null,
                  ),
                  Center(
                    child: Text('+$_add'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
