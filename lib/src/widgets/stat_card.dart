import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:material_ui/material_ui.dart';

const _customOpacity = 0.6;
const _defaultStatFontSize = 12.0;
const _defaultValueFontSize = 18.0;

class const StatCard(
  final String stat, {
  final Widget? child,
  final String? value,
  final EdgeInsets? contentPadding,
  final double? opacity,
  final double? statFontSize,
  final double? valueFontSize,
  final Color? backgroundColor,
  final double elevation = 0,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final defaultStatStyle = TextStyle(
      color: textShade(context, opacity ?? _customOpacity),
      fontSize: statFontSize ?? _defaultStatFontSize,
    );

    final defaultValueStyle = TextStyle(fontSize: valueFontSize ?? _defaultValueFontSize);

    return Card(
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

class const StatCardRow(final List<StatCard> cards) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: cards.map((e) => Expanded(child: e)).toList(growable: false),
      ),
    );
  }
}
