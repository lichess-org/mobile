import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassButton, LiquidRoundedRectangle;
import 'package:material_ui/material_ui.dart';

/// Height of a variation button with liquid glass.
const double _kGlassButtonHeight = 40.0;

/// Space around and between the variation buttons with liquid glass.
const double _kGlassSpacing = 8.0;

/// A bar showing the variations branching out of the current position, if there is more than one variation.
///
/// Each variation is shown as a button with the move SAN, and if annotations are enabled, the move
/// annotation is also shown (e.g. "!" or "?")
///
/// With liquid glass ([useLiquidGlass]), the buttons are thick, tinted glass capsules, the mainline
/// in the primary container color, so that they stand out like the bottom bar buttons below them.
///
/// Laid out below the moves by [MovesWithVariationsBar].
class const VariationsBar({
  super.key,
  required final ViewNode currentNode,
  required final UciPath currentPath,
  required final bool showAnnotations,
  required final void Function(UciPath) onJump,
}) extends StatelessWidget {
  static const maxVarSize = 55;

  /// The number of variation buttons in a row of a bar of [width].
  static int _crossAxisCount(double width, {required bool glass}) =>
      (width / (glass ? maxVarSize + _kGlassSpacing : maxVarSize)).floor().clamp(1, 8);

  /// The height of the bar with liquid glass, of [width], for [variationCount] variations.
  static double _glassHeight(int variationCount, double width) {
    final rows = (variationCount / _crossAxisCount(width, glass: true)).ceil();
    return rows * _kGlassButtonHeight + (rows + 1) * _kGlassSpacing;
  }

  @override
  Widget build(BuildContext context) {
    final variations = currentNode.children;

    if (variations.length <= 1) {
      return const SizedBox.shrink();
    }

    final glass = useLiquidGlass(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _crossAxisCount(constraints.maxWidth, glass: glass);

        final chunkedRows = <Widget>[];
        for (var i = 0; i < variations.length; i += crossAxisCount) {
          final chunk = variations.skip(i).take(crossAxisCount).toList();

          chunkedRows.add(
            Row(
              spacing: glass ? _kGlassSpacing : 0.0,
              children: chunk.map((child) {
                final isMainline = child == variations.first;
                final theme = Theme.of(context);
                final borderColor = theme.dividerColor;
                final backgroundColor = isMainline
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.secondaryContainer;
                final textColor = isMainline
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSecondaryContainer;

                final annotation = showAnnotations && child.nags != null && child.nags!.isNotEmpty
                    ? moveAnnotationChar(child.nags!)
                    : '';

                final displayText = '${child.sanMove.san}$annotation';
                final label = FittedBox(
                  fit: .scaleDown,
                  child: Text(displayText, style: TextStyle(fontSize: 14, color: textColor)),
                );

                return Expanded(
                  child: glass
                      ? GlassButton.custom(
                          onTap: () => onJump(currentPath + child.id),
                          label: displayText,
                          // The clear body mode keeps the exact color, which the adaptive one
                          // darkens over a dark background.
                          settings: thickGlassSettings(context).copyWith(
                            glassColor: backgroundColor.withValues(alpha: 0.8),
                            bodyMode: .clear,
                          ),
                          shape: const LiquidRoundedRectangle(borderRadius: 100),
                          // The bar has no glass layer to share.
                          useOwnLayer: true,
                          width: double.infinity,
                          height: _kGlassButtonHeight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(child: label),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color: borderColor, width: 1),
                              bottom: BorderSide(color: borderColor, width: 1),
                            ),
                          ),
                          child: Material(
                            color: backgroundColor,
                            child: InkWell(
                              onTap: () => onJump(currentPath + child.id),
                              child: Container(
                                constraints: const BoxConstraints(
                                  minHeight: kMinInteractiveDimension,
                                ),
                                alignment: .center,
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: label,
                              ),
                            ),
                          ),
                        ),
                );
              }).toList(),
            ),
          );
        }

        return glass
            ? Padding(
                padding: const EdgeInsets.all(_kGlassSpacing),
                child: Column(
                  crossAxisAlignment: .stretch,
                  spacing: _kGlassSpacing,
                  children: chunkedRows,
                ),
              )
            : Column(crossAxisAlignment: .stretch, children: chunkedRows);
      },
    );
  }
}

/// The moves of an analysis tab view, with the [VariationsBar] of the [currentNode] at the bottom,
/// above a bar floating over the tab view (its height is the bottom `MediaQuery` padding).
///
/// With liquid glass ([useLiquidGlass]), the variations bar floats over the moves, like the bottom
/// bar below it. Otherwise, it is laid out below them.
class const MovesWithVariationsBar({
  required final ViewNode currentNode,
  required final UciPath currentPath,
  required final bool showAnnotations,
  required final void Function(UciPath) onJump,

  /// Builds the scroll view of the moves, which applies [bottomPadding] to scroll clear of the bars
  /// floating over it.
  required final Widget Function(BuildContext context, double bottomPadding) movesBuilder,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final variationCount = currentNode.children.length;
    final hasVariations = variationCount > 1;
    final variationsBar = VariationsBar(
      currentNode: currentNode,
      currentPath: currentPath,
      showAnnotations: showAnnotations,
      onJump: onJump,
    );

    if (!useLiquidGlass(context)) {
      return Column(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(child: movesBuilder(context, hasVariations ? 0.0 : bottomInset)),
          if (hasVariations)
            Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: variationsBar,
            ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final barHeight = hasVariations
            ? VariationsBar._glassHeight(variationCount, constraints.maxWidth)
            : 0.0;
        return Stack(
          children: [
            Positioned.fill(child: movesBuilder(context, bottomInset + barHeight)),
            if (hasVariations)
              Positioned(left: 0, right: 0, bottom: bottomInset, child: variationsBar),
          ],
        );
      },
    );
  }
}
