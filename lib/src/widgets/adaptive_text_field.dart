import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A simple text field that adapts to the platform it's running on.
class AdaptiveTextField extends StatelessWidget {
  const AdaptiveTextField({
    this.placeholder,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.minLines,
    this.maxLines = 1,
    this.keyboardType,
    this.expands = false,
    this.readOnly = false,
    this.enableSuggestions = false,
    this.autofocus = false,
    super.key,
  });

  final int? minLines;
  final int? maxLines;
  final String? placeholder;
  final bool expands;
  final bool enableSuggestions;
  final bool readOnly;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return CupertinoTextField(
          minLines: minLines,
          maxLines: maxLines,
          expands: expands,
          placeholder: placeholder,
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onTap: onTap,
          readOnly: readOnly,
          enableSuggestions: enableSuggestions,
          autofocus: autofocus,
        );
      default:
        return TextField(
          minLines: minLines,
          maxLines: maxLines,
          expands: expands,
          decoration: InputDecoration(
            hintText: placeholder,
          ),
          controller: controller,
          keyboardType: keyboardType,
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
