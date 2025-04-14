import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveAutoComplete<T extends Object> extends StatelessWidget {
  const AdaptiveAutoComplete({
    this.initialValue,
    required this.optionsBuilder,
    this.textInputAction,
    this.onSelected,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.cupertinoDecoration,
    super.key,
  });

  final TextEditingValue? initialValue;
  final TextInputAction? textInputAction;
  final Iterable<T> Function(TextEditingValue) optionsBuilder;
  final String Function(T) displayStringForOption;
  final void Function(T)? onSelected;

  final BoxDecoration? cupertinoDecoration;

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
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
              textInputAction: textInputAction,
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
                color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                child: SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final T option = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          onSelected(option);
                        },
                        child: ListTile(title: Text(displayStringForOption(option))),
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
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextField(
              controller: textEditingController,
              textInputAction: textInputAction,
              focusNode: focusNode,
              onSubmitted: (String value) {
                onFieldSubmitted();
              },
            );
          },
        );
  }
}
