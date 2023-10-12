import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A simple text field that adapts to the platform it's running on.
class AdaptiveTextField extends StatelessWidget {
  const AdaptiveTextField({
    this.maxLines,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.enableSuggestions = false,
    super.key,
  });

  final int? maxLines;
  final String? placeholder;
  final bool enableSuggestions;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

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
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          enableSuggestions: enableSuggestions,
        );
      default:
        return TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: placeholder,
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          enableSuggestions: enableSuggestions,
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
