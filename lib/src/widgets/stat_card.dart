import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

const _customOpacity = 0.6;
const _defaultStatFontSize = 12.0;
const _defaultValueFontSize = 18.0;

class StatCard extends StatelessWidget {
  const StatCard(
    this.stat, {super.key, 
    this.child,
    this.value,
    this.padding,
    this.opacity,
    this.statFontSize,
    this.valueFontSize,
  });

  final String stat;
  final Widget? child;
  final String? value;
  final EdgeInsets? padding;
  final double? opacity;
  final double? statFontSize;
  final double? valueFontSize;

  @override
  Widget build(BuildContext context) {
    final defaultStatStyle = TextStyle(
      color: textShade(context, opacity ?? _customOpacity),
      fontSize: statFontSize ?? _defaultStatFontSize,
    );

    final defaultValueStyle = TextStyle(fontSize: valueFontSize ?? _defaultValueFontSize);

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: PlatformCard(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
      ),
    );
  }
}

class StatCardRow extends StatelessWidget {
  final List<StatCard> cards;

  const StatCardRow(this.cards, {super.key});

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
