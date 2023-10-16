import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A simple text field that adapts to the platform it's running on.
class AdaptiveTextField extends StatelessWidget {
  const AdaptiveTextField({
    this.placeholder,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.maxLines = 1,
    this.readOnly = false,
    this.enableSuggestions = false,
    this.autofocus = false,
    super.key,
  });

  final int? maxLines;
  final String? placeholder;
  final bool enableSuggestions;
  final bool readOnly;
  final bool autofocus;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return CupertinoTextField(
          decoration: const BoxDecoration(
            color: CupertinoColors.secondarySystemGroupedBackground,
            border: _kDefaultRoundedBorder,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          maxLines: maxLines,
          placeholder: placeholder,
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onTap: onTap,
          readOnly: readOnly,
          enableSuggestions: enableSuggestions,
          autofocus: autofocus,
        );
      default:
        return TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: placeholder,
          ),
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onTap: onTap,
          readOnly: readOnly,
          enableSuggestions: enableSuggestions,
          autofocus: autofocus,
        );
    }
  }
}

// taken from https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/cupertino/text_field.dart
// Value inspected from Xcode 11 & iOS 13.0 Simulator.
const BorderSide _kDefaultRoundedBorderSide = BorderSide(
  color: CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x33FFFFFF),
  ),
  width: 0.0,
);
const Border _kDefaultRoundedBorder = Border(
  top: _kDefaultRoundedBorderSide,
  bottom: _kDefaultRoundedBorderSide,
  left: _kDefaultRoundedBorderSide,
  right: _kDefaultRoundedBorderSide,
);
