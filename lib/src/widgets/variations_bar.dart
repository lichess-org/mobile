import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

/// A bar showing the variations branching out of the current position, if there is more than one variation.
///
/// Each variation is shown as a button with the move SAN, and if annotations are enabled, the move
/// annotation is also shown (e.g. "!" or "?")
class VariationsBar extends StatelessWidget {
  const VariationsBar({
    super.key,
    required this.currentNode,
    required this.currentPath,
    required this.showAnnotations,
    required this.onJump,
  });

  final ViewNode currentNode;
  final UciPath currentPath;
  final bool showAnnotations;
  final void Function(UciPath) onJump;

  static const maxVarSize = 55;

  @override
  Widget build(BuildContext context) {
    final variations = currentNode.children;

    if (variations.length <= 1) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth / maxVarSize).floor().clamp(1, 8);

        final chunkedRows = <Widget>[];
        for (var i = 0; i < variations.length; i += crossAxisCount) {
          final chunk = variations.skip(i).take(crossAxisCount).toList();

          chunkedRows.add(
            Row(
              children: chunk.map((child) {
                final isMainline = child == variations.first;
                final theme = Theme.of(context);
                final borderColor = theme.dividerColor;

                final annotation = showAnnotations && child.nags != null && child.nags!.isNotEmpty
                    ? moveAnnotationChar(child.nags!)
                    : '';

                final displayText = '${child.sanMove.san}$annotation';

                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: borderColor, width: 1),
                        bottom: BorderSide(color: borderColor, width: 1),
                      ),
                    ),
                    child: Material(
                      color: isMainline
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.secondaryContainer,
                      child: InkWell(
                        onTap: () => onJump(currentPath + child.id),
                        child: Container(
                          constraints: const BoxConstraints(minHeight: kMinInteractiveDimension),
                          alignment: .center,
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: FittedBox(
                            fit: .scaleDown,
                            child: Text(
                              displayText,
                              style: TextStyle(
                                fontSize: 14,
                                color: isMainline
                                    ? theme.colorScheme.onPrimaryContainer
                                    : theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }

        return Column(crossAxisAlignment: .stretch, children: chunkedRows);
      },
    );
  }
}
