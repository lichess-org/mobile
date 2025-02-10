import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

const _customOpacity = 0.6;
const _defaultStatFontSize = 12.0;
const _defaultValueFontSize = 18.0;

class StatCard extends StatelessWidget {
  const StatCard(
    this.stat, {
    this.child,
    this.value,
    this.contentPadding,
    this.opacity,
    this.statFontSize,
    this.valueFontSize,
    this.backgroundColor,
    this.elevation = 0,
  });

  final String stat;
  final Widget? child;
  final String? value;
  final EdgeInsets? contentPadding;
  final double? opacity;
  final double? statFontSize;
  final double? valueFontSize;
  final Color? backgroundColor;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final defaultStatStyle = TextStyle(
      color: textShade(context, opacity ?? _customOpacity),
      fontSize: statFontSize ?? _defaultStatFontSize,
    );

    final defaultValueStyle = TextStyle(fontSize: valueFontSize ?? _defaultValueFontSize);

    return PlatformCard(
      elevation: elevation,
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: contentPadding ?? EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.scaleDown,
              child: Text(stat, style: defaultStatStyle, textAlign: TextAlign.center),
            ),
            if (value != null)
              Text(value!, style: defaultValueStyle, textAlign: TextAlign.center)
            else if (child != null)
              child!
            else
              Text('?', style: defaultValueStyle),
          ],
        ),
      ),
    );
  }
}

class StatCardRow extends StatelessWidget {
  final List<StatCard> cards;

  const StatCardRow(this.cards);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _divideRow(cards).map((e) => Expanded(child: e)).toList(growable: false),
      ),
    );
  }
}

@allowedWidgetReturn
Iterable<Widget> _divideRow(Iterable<Widget> elements) {
  final list = elements.toList();

  if (list.isEmpty || list.length == 1) {
    return list;
  }

  Widget wrapElement(Widget el) {
    return Container(margin: const EdgeInsets.only(right: 8), child: el);
  }

  return <Widget>[...list.take(list.length - 1).map(wrapElement), list.last];
}
