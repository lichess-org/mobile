import 'package:material_ui/material_ui.dart';

enum FilterType() {
  /// Only one choice is intended to be selected at a time. Uses [ChoiceChip] to display choices.
  singleChoice,

  /// Multiple choices can be selected at the same time. Uses [FilterChip] to display choices.
  multipleChoice,
}

/// Displays a row of choices that can be selected or deselected.
class const Filter<T extends Enum>({
  /// Will be displayed above the choices as a title.
  final String? filterName,

  /// Controls how choices in a [Filter] are displayed.
  required final FilterType filterType,

  /// The choices that will be displayed.
  required final Iterable<T> choices,

  /// Whether to show a checkmark next to selected choices.
  final bool showCheckmark = true,

  /// Called to determine whether a choice is currently selected.
  required final bool Function(T choice) choiceSelected,

  /// Determines label to display for the given choice.
  required final Widget Function(T choice) choiceLabel,

  /// Called when a choice is selected or deselected.
  required final void Function(T value, bool selected) onSelected,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (filterName != null) ...[
          Text(filterName!, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
        ],
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 8.0,
            children: choices
                .map(
                  (choice) => switch (filterType) {
                    FilterType.singleChoice => ChoiceChip(
                      label: choiceLabel(choice),
                      selected: choiceSelected(choice),
                      onSelected: (value) => onSelected(choice, value),
                      showCheckmark: showCheckmark,
                    ),
                    FilterType.multipleChoice => FilterChip(
                      label: choiceLabel(choice),
                      selected: choiceSelected(choice),
                      onSelected: (value) => onSelected(choice, value),
                      showCheckmark: showCheckmark,
                    ),
                  },
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}
