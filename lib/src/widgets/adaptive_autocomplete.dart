import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

class AdaptiveAutoComplete<T extends Object> extends StatelessWidget {
  const AdaptiveAutoComplete({
    this.initialValue,
    required this.optionsBuilder,
    this.onSelected,
    this.displayStringForOption = defaultStringForOption,
    this.cupertinoDecoration,
    super.key,
  });

  final TextEditingValue? initialValue;
  final Iterable<T> Function(TextEditingValue) optionsBuilder;
  final String Function(T) displayStringForOption;
  final void Function(T)? onSelected;

  final BoxDecoration? cupertinoDecoration;

  /// The default way to convert an option to a string in
  /// [displayStringForOption].
  ///
  /// Uses the `toString` method of the given `option`.
  static String defaultStringForOption(Object? option) {
    return option.toString();
  }

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.iOS
        ? RawAutocomplete<T>(
            initialValue: initialValue,
            optionsBuilder: optionsBuilder,
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
            ) {
              return CupertinoTextField(
                controller: textEditingController,
                decoration: cupertinoDecoration,
                focusNode: focusNode,
                onSubmitted: (String value) {
                  onFieldSubmitted();
                },
              );
            },
            optionsViewBuilder: (
              BuildContext context,
              AutocompleteOnSelected<T> onSelected,
              Iterable<T> options,
            ) {
              return Align(
                alignment: Alignment.topLeft,
                child: ColoredBox(
                  color: CupertinoColors.secondarySystemGroupedBackground
                      .resolveFrom(context),
                  child: SizedBox(
                    height: 200.0,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final T option = options.elementAt(index);
                        return AdaptiveInkWell(
                          onTap: () {
                            onSelected(option);
                          },
                          child: ListTile(
                            title: Text(displayStringForOption(option)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
            onSelected: onSelected,
          )
        : Autocomplete<T>(
            initialValue: initialValue,
            optionsBuilder: optionsBuilder,
            onSelected: onSelected,
            displayStringForOption: displayStringForOption,
          );
  }
}
