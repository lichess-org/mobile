import 'package:lichess_mobile/src/widgets/platform_choice_chip.dart';
import 'package:material_ui/material_ui.dart';

enum FilterType() {
  /// Only one choice is intended to be selected at a time ([ChoiceChip] on Android).
  singleChoice,

  /// Multiple choices can be selected at the same time ([FilterChip] on Android).
  multipleChoice,
}

/// Displays a group of choices that can be selected or deselected, under an optional title.
///
/// This is the layout of every group of chips in a sheet: [FilterTitle], then the chips.
class const Filter<T>({
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

  /// Determines the tooltip of the given choice, if any.
  final String? Function(T choice)? choiceTooltip,

  /// Called when a choice is selected or deselected.
  required final void Function(T value, bool selected) onSelected,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (filterName != null) FilterTitle(filterName!),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 8.0,
            // The glass chips have no tap target margin, unlike the Material ones.
            runSpacing: Theme.of(context).platform == TargetPlatform.iOS ? 8.0 : 0.0,
            children: choices
                .map(
                  (choice) => PlatformChoiceChip(
                    label: choiceLabel(choice),
                    selected: choiceSelected(choice),
                    onSelected: (value) => onSelected(choice, value),
                    multiple: filterType == FilterType.multipleChoice,
                    showCheckmark: showCheckmark,
                    tooltip: choiceTooltip?.call(choice),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}

/// The title of a group of chips (see [Filter]), for groups that don't fit in a [Filter].
class const FilterTitle(final String title, {super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(title, style: const TextStyle(fontSize: 18)),
    );
  }
}
