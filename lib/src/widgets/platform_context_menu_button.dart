import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:popover/popover.dart';

const _kMenuWidth = 250.0;
const Color _kBorderColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFA9A9AF),
  darkColor: Color(0xFF57585A),
);

/// A platform agnostic context menu button.
///
/// Typically used in the [AppBar] to show a context menu.
class PlatformContextMenuButton extends StatelessWidget {
  const PlatformContextMenuButton({
    required this.icon,
    required this.semanticsLabel,
    required this.actions,
    super.key,
  });

  final Widget icon;
  final String semanticsLabel;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return AppBarIconButton(
        onPressed: () {
          showPopover(
            context: context,
            bodyBuilder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: _kMenuWidth,
                  child: IntrinsicHeight(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(13.0)),
                      child: ColoredBox(
                        color: CupertinoDynamicColor.resolve(
                          CupertinoContextMenu.kBackgroundColor,
                          context,
                        ),
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: CupertinoScrollbar(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  actions.first,
                                  for (final Widget action in actions.skip(1))
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: CupertinoDynamicColor.resolve(
                                              _kBorderColor,
                                              context,
                                            ),
                                            width: 0.4,
                                          ),
                                        ),
                                      ),
                                      position: DecorationPosition.foreground,
                                      child: action,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            arrowWidth: 0.0,
            arrowHeight: 0.0,
            direction: PopoverDirection.top,
            width: _kMenuWidth,
            backgroundColor: Colors.transparent,
          );
        },
        semanticsLabel: semanticsLabel,
        icon: icon,
      );
    }

    return MenuAnchor(
      crossAxisUnconstrained: false,
      consumeOutsideTap: true,
      style: MenuStyle(
        maximumSize: WidgetStatePropertyAll(
          Size(MediaQuery.sizeOf(context).width * 0.6, MediaQuery.sizeOf(context).height * 0.8),
        ),
      ),
      menuChildren: actions,
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return AppBarIconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          semanticsLabel: semanticsLabel,
          icon: icon,
        );
      },
    );
  }
}

class PlatformContextMenuAction extends StatelessWidget {
  const PlatformContextMenuAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.dismissOnPress = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  /// Whether the modal should be dismissed when an action is pressed.
  ///
  /// Default to true.
  final bool dismissOnPress;

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoContextMenuAction(
          onPressed: () {
            if (dismissOnPress) {
              Navigator.of(context).pop();
            }
            onPressed?.call();
          },
          trailingIcon: icon,
          child: Text(label),
        )
        : MenuItemButton(
          closeOnActivate: dismissOnPress,
          leadingIcon: Icon(icon),
          semanticsLabel: label,
          onPressed: onPressed,
          child: Text(label),
        );
  }
}
