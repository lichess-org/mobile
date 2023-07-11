import 'package:flutter/widgets.dart';

class GlowingText extends StatefulWidget {
  final String data;
  final TextStyle? style;
  final Color? color;

  const GlowingText(
    this.data, {
    this.color,
    this.style,
    super.key,
  });

  @override
  State<GlowingText> createState() => _GlowingTextState();
}

class _GlowingTextState extends State<GlowingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 15.0, end: 40.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context).style.merge(widget.style);

    return Text(
      widget.data,
      style: style.copyWith(
        shadows: [
          Shadow(
            color: widget.color ?? style.color ?? const Color(0xFFFFFFFF),
            offset: const Offset(0, 1.0),
            blurRadius: _animation.value,
          ),
        ],
      ),
    );
  }
}
