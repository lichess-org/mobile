import 'package:flutter/widgets.dart';

import 'package:lichess_mobile/src/utils/rate_limit.dart';

/// A widget that debounces changes of its child.
class Debounced<T extends Widget> extends StatefulWidget {
  final T child;
  final Duration delay;

  const Debounced({
    required this.child,
    required this.delay,
    super.key,
  });

  @override
  _DebouncedState createState() => _DebouncedState<T>();
}

class _DebouncedState<T extends Widget> extends State<Debounced<T>> {
  late final Debouncer _debounce;
  late T _widget;

  @override
  void initState() {
    super.initState();
    _widget = widget.child;
    _debounce = Debouncer(widget.delay);
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Debounced<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _debounce(() {
      _widget = widget.child;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _widget;
  }
}
