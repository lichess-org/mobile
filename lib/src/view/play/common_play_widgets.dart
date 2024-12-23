import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/rating.dart';

class PlayRatingRange extends StatefulWidget {
  const PlayRatingRange({
    required this.perf,
    required this.ratingDelta,
    required this.onRatingDeltaChange,
    super.key,
  });

  final UserPerf perf;
  final (int, int) ratingDelta;
  final void Function(int, int) onRatingDeltaChange;

  @override
  State<PlayRatingRange> createState() => _PlayRatingRangeState();
}

class _PlayRatingRangeState extends State<PlayRatingRange> {
  late int _subtract;
  late int _add;

  @override
  void initState() {
    super.initState();
    final (subtract, add) = widget.ratingDelta;
    _subtract = subtract;
    _add = add;
  }

  @override
  void didUpdateWidget(PlayRatingRange oldWidget) {
    super.didUpdateWidget(oldWidget);
    final (subtract, add) = widget.ratingDelta;
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
        title: Text(context.l10n.ratingRange),
        subtitle: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Column(
                children: [
                  NonLinearSlider(
                    value: _subtract,
                    values: kSubtractingRatingRange,
                    onChange:
                        Theme.of(context).platform == TargetPlatform.iOS
                            ? (num value) {
                              setState(() {
                                _subtract = value.toInt();
                              });
                            }
                            : null,
                    onChangeEnd:
                        isRatingRangeAvailable
                            ? (num value) {
                              widget.onRatingDeltaChange(
                                value.toInt(),
                                value == 0 && _add == 0 ? kAddingRatingRange[1] : _add,
                              );
                            }
                            : null,
                  ),
                  Center(child: Text('${_subtract == 0 ? '-' : ''}$_subtract')),
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
                    onChange:
                        Theme.of(context).platform == TargetPlatform.iOS
                            ? (num value) {
                              setState(() {
                                _add = value.toInt();
                              });
                            }
                            : null,
                    onChangeEnd:
                        isRatingRangeAvailable
                            ? (num value) {
                              widget.onRatingDeltaChange(
                                value == 0 && _subtract == 0
                                    ? kSubtractingRatingRange[kSubtractingRatingRange.length - 2]
                                    : _subtract,
                                value.toInt(),
                              );
                            }
                            : null,
                  ),
                  Center(child: Text('+$_add')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
