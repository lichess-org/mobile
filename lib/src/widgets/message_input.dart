import 'package:material_ui/material_ui.dart';

/// Vertical padding around a message input field, at the bottom of a chat or conversation screen.
double messageInputVerticalPadding(BuildContext context, {required double fallback}) =>
    Theme.of(context).platform == TargetPlatform.iOS ? 12.0 : fallback;

/// The decoration of a message input field, at the bottom of a chat or conversation screen.
///
/// On iOS it is a slim capsule, like the Messages input.
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

  // The iOS input theme makes the field a capsule.
  return InputDecoration(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    suffixIcon: suffixIcon,
    // The suffix button would otherwise make the field at least 48pt high.
    suffixIconConstraints: const BoxConstraints(minWidth: 40.0, minHeight: 32.0, maxHeight: 32.0),
    hintText: hintText,
  );
}
