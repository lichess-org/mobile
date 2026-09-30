import 'package:flutter/widgets.dart';

class const ExpandedSection({final bool expand = false, required final Widget child})
    extends StatefulWidget {
  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState() extends State<ExpandedSection> with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    expandController = AnimationController(
      vsync: this,
      value: widget.expand ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(parent: expandController, curve: Curves.fastOutSlowIn);
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      alignment: Alignment.bottomLeft,
      sizeFactor: animation,
      child: widget.child,
    );
  }
}
