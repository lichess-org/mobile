import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A simple text field that adapts to the platform it's running on.
class AdaptiveTextField extends StatelessWidget {
  const AdaptiveTextField({
    this.placeholder,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.expands = false,
    this.readOnly = false,
    this.enableSuggestions = false,
    this.autofocus = false,
    this.suffix,
    this.cupertinoDecoration,
    this.materialDecoration,
    super.key,
  });

  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final String? placeholder;
  final bool expands;
  final bool enableSuggestions;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final GestureTapCallback? onTap;
  final Widget? suffix; //used only for iOS, suffix should be put in InputDecoration for android

  final BoxDecoration? cupertinoDecoration;
  final InputDecoration? materialDecoration;

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        return CupertinoTextField(
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          expands: expands,
          placeholder: placeholder,
          controller: controller,
          focusNode: focusNode,
          textInputAction: textInputAction,
          decoration: cupertinoDecoration,
          keyboardType: keyboardType,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onTap: onTap,
          readOnly: readOnly,
          enableSuggestions: enableSuggestions,
          autofocus: autofocus,
          suffix: suffix,
        );
      default:
        return TextField(
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          expands: expands,
          decoration: materialDecoration ?? InputDecoration(hintText: placeholder),
          controller: controller,
          focusNode: focusNode,
          textInputAction: textInputAction,
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
