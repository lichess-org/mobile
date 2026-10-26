import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_search_bar.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassContainer, LiquidRoundedSuperellipse;
import 'package:material_ui/material_ui.dart';

/// Space above a message input field on iOS, and below it the minimum space when the bottom safe
/// area is smaller (e.g. above the keyboard), like a [BottomSearchBar].
const double _kIOSMessageInputVerticalPadding = 8.0;

/// Corner radius of the liquid glass background of a [MessageInputBar] on iOS: a capsule around
/// a single line field, and rounded corners around several lines, like the Messages input.
const double _kGlassMessageInputRadius = 18.0;

/// The decoration of a message input field, at the bottom of a chat or conversation screen.
///
/// On iOS it is a slim capsule, like the Messages input. On iOS 26 and later ([useLiquidGlass]),
/// the field has no fill nor border: its background is the glass of its [MessageInputBar].
InputDecoration messageInputDecoration(
  BuildContext context, {
  required Widget suffixIcon,
  String? hintText,
}) {
  if (Theme.of(context).platform != TargetPlatform.iOS) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      suffixIcon: suffixIcon,
      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      hintText: hintText,
    );
  }

  final glass = useLiquidGlass(context);
  // The iOS input theme makes the field a capsule.
  return InputDecoration(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    suffixIcon: suffixIcon,
    // The suffix button would otherwise make the field at least 48pt high.
    suffixIconConstraints: const BoxConstraints(minWidth: 40.0, minHeight: 32.0, maxHeight: 32.0),
    hintText: hintText,
    filled: glass ? false : null,
    border: glass ? InputBorder.none : null,
    enabledBorder: glass ? InputBorder.none : null,
    focusedBorder: glass ? InputBorder.none : null,
    disabledBorder: glass ? InputBorder.none : null,
  );
}

/// The message input bar of a chat or conversation screen, around a [field] decorated with
/// [messageInputDecoration], that takes care of the bottom safe area.
///
/// On iOS it is laid out like a [BottomSearchBar]. On iOS 26 and later ([useLiquidGlass]), the
/// field floats over the messages in a liquid glass capsule, like the Messages input. Elsewhere,
/// [fallbackVerticalPadding] is the space above and below the field.
class const MessageInputBar({
  required final Widget field,
  required final double fallbackVerticalPadding,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform != TargetPlatform.iOS) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: fallbackVerticalPadding),
          child: field,
        ),
      );
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16.0,
          _kIOSMessageInputVerticalPadding,
          16.0,
          math.max(MediaQuery.paddingOf(context).bottom, _kIOSMessageInputVerticalPadding),
        ),
        child: useLiquidGlass(context)
            ? Stack(
                children: [
                  Positioned.fill(
                    child: GlassContainer(
                      shape: const LiquidRoundedSuperellipse(
                        borderRadius: _kGlassMessageInputRadius,
                      ),
                      // Like the bottom search fields.
                      settings: ios27GlassSettings(context),
                      // Floats over the content, there is no parent glass layer to share.
                      useOwnLayer: true,
                      child: const SizedBox.expand(),
                    ),
                  ),
                  field,
                ],
              )
            : field,
      ),
    );
  }
}

/// The [messages] of a chat or conversation screen, above its message [input] bar (a
/// [MessageInputBar]), or with no input bar when null.
///
/// On iOS the messages scroll under the input bar, which floats over them at the bottom of the
/// screen ([BottomBarScrollEdgeEffect]). Before iOS 26 ([useLiquidGlass]), the bar is translucent instead
/// ([BlurredBarBackground]). The bottom padding of the [MediaQuery] of [messages] is the height of
/// the bar, that their scroll view must apply.
class const MessageInputLayout({required final Widget messages, final Widget? input, super.key})
    extends StatefulWidget {
  @override
  State<MessageInputLayout> createState() => _MessageInputLayoutState();
}

class _MessageInputLayoutState() extends State<MessageInputLayout> {
  /// The height of the input bar floating over the messages on iOS, safe area included.
  double _inputHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    final input = widget.input;
    if (input == null) return widget.messages;

    if (Theme.of(context).platform != TargetPlatform.iOS) {
      return Column(
        children: [
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: widget.messages,
            ),
          ),
          input,
        ],
      );
    }

    final mediaQuery = MediaQuery.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: BottomBarScrollEdgeEffect(
            barHeight: _inputHeight,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: MediaQuery(
              data: mediaQuery.copyWith(padding: mediaQuery.padding.copyWith(bottom: _inputHeight)),
              child: widget.messages,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _HeightReporter(
            onHeightChanged: (height) {
              if (mounted && height != _inputHeight) setState(() => _inputHeight = height);
            },
            child: useLiquidGlass(context)
                ? input
                : BlurredBarBackground(atBottom: true, child: input),
          ),
        ),
      ],
    );
  }
}

/// Reports the height of [child] after each layout that changes it, in a post frame callback.
class const _HeightReporter({
  required final ValueChanged<double> onHeightChanged,
  required super.child,
}) extends SingleChildRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderHeightReporter(onHeightChanged: onHeightChanged);

  @override
  void updateRenderObject(BuildContext context, _RenderHeightReporter renderObject) {
    renderObject.onHeightChanged = onHeightChanged;
  }
}

class _RenderHeightReporter({required ValueChanged<double> onHeightChanged})
    extends RenderProxyBox {
  ValueChanged<double> onHeightChanged = onHeightChanged;

  double? _reportedHeight;

  @override
  void performLayout() {
    super.performLayout();
    final height = size.height;
    if (height == _reportedHeight) return;
    _reportedHeight = height;
    WidgetsBinding.instance.addPostFrameCallback((_) => onHeightChanged(height));
  }
}
