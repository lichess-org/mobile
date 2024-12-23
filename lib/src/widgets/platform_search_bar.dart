import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

/// Displays a [SearchBar] on Android and a [CupertinoSearchTextField] on iOS.
class PlatformSearchBar extends StatelessWidget {
  const PlatformSearchBar({
    this.controller,
    this.hintText,
    this.autoFocus = false,
    this.onClear,
    this.onTap,
    this.onSubmitted,
    this.focusNode,
  });

  /// See [SearchBar.controller] and [CupertinoSearchTextField.controller].
  final TextEditingController? controller;

  /// Text that suggests what sort of input the field accepts.
  ///
  /// Displayed at the same location on the screen where text may be entered
  /// when the input is empty.
  final String? hintText;

  /// Whether this the search should focus itself if nothing else is already focused.
  ///
  /// Defaults to false.
  final bool autoFocus;

  /// Called when the user taps this search bar.
  final GestureTapCallback? onTap;

  /// Callback when the clear button is pressed.
  ///
  /// Defaults to clearing the text in the [controller].
  final VoidCallback? onClear;

  /// Callback when the search term is submitted.
  final void Function(String term)? onSubmitted;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder:
          (context) => SearchBar(
            controller: controller,
            leading: const Icon(Icons.search),
            trailing: [
              if (controller?.text.isNotEmpty == true)
                IconButton(
                  onPressed: onClear ?? () => controller?.clear(),
                  tooltip: 'Clear',
                  icon: const Icon(Icons.close),
                ),
            ],
            onTap: onTap,
            focusNode: focusNode,
            onSubmitted: onSubmitted,
            hintText: hintText,
            autoFocus: autoFocus,
          ),
      iosBuilder:
          (context) => CupertinoSearchTextField(
            controller: controller,
            onTap: onTap,
            focusNode: focusNode,
            onSuffixTap: onClear,
            onSubmitted: onSubmitted,
            placeholder: hintText,
            autofocus: autoFocus,
          ),
    );
  }
}
