import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/common/styles.dart';

const _customOpacity = 0.6;
const _defaultStatFontSize = 12.0;
const _defaultValueFontSize = 18.0;

class CustomPlatformCard extends StatelessWidget {
  const CustomPlatformCard(
    this.stat, {
    this.child,
    this.value,
    this.padding,
  });

  final String stat;
  final Widget? child;
  final String? value;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final defaultStatStyle = TextStyle(
      color: textShade(context, _customOpacity),
      fontSize: _defaultStatFontSize,
    );

    const defaultValueStyle = TextStyle(fontSize: _defaultValueFontSize);

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
                child: Text(
                  stat,
                  style: defaultStatStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              if (value != null)
                Text(
                  value!,
                  style: defaultValueStyle,
                  textAlign: TextAlign.center,
                )
              else if (child != null)
                child!
              else
                const Text('?', style: defaultValueStyle)
            ],
          ),
        ),
      ),
    );
  }
}

class CustomPlatformCardRow extends StatelessWidget {
  final List<CustomPlatformCard> cards;

  const CustomPlatformCardRow(this.cards);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.horizontalBodyPadding,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _divideRow(cards)
              .map((e) => Expanded(child: e))
              .toList(growable: false),
        ),
      ),
    );
  }
}

Iterable<Widget> _divideRow(Iterable<Widget> elements) {
  final list = elements.toList();

  if (list.isEmpty || list.length == 1) {
    return list;
  }

  Widget wrapElement(Widget el) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: el,
    );
  }

  return <Widget>[
    ...list.take(list.length - 1).map(wrapElement),
    list.last,
  ];
}
