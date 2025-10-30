import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

const kSettingsTileTitleMaxLines = 3;

/// A platform agnostic tappable list tile that represents a settings value.
class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    this.icon,
    required this.settingsLabel,
    required this.settingsValue,
    required this.onTap,
    this.explanation,
    this.enabled = true,
    super.key,
  });

  /// The icon of the settings value.
  final Widget? icon;

  /// The label of the settings value.
  final Text settingsLabel;

  final String settingsValue;

  final bool enabled;

  final void Function()? onTap;

  /// The optional explanation of the settings.
  final String? explanation;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: '$settingsLabel: $settingsValue',
      excludeSemantics: true,
      child: ListTile(
        leading: icon,
        title: _SettingsTitle(title: settingsLabel),
        subtitle: explanation != null
            ? Text(
                explanation!,
                maxLines: 5,
                style: ListTileTheme.of(context).subtitleTextStyle?.copyWith(
                  fontSize: TextTheme.of(context).bodySmall?.fontSize,
                ),
              )
            : null,
        enabled: enabled,
        onTap: onTap,
        trailing: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.25,
          ),
          child: Text(
            settingsValue,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            maxLines: kSettingsTileTitleMaxLines,
            style: TextStyle(color: textShade(context, Styles.subtitleOpacity)),
          ),
        ),
      ),
    );
  }
}

class SwitchSettingTile extends StatelessWidget {
  const SwitchSettingTile({
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.leading,
    super.key,
  });

  final Text title;
  final Widget? subtitle;
  final bool value;
  final void Function(bool value)? onChanged;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: _SettingsTitle(title: title),
      subtitle: subtitle != null
          ? DefaultTextStyle.merge(
              style: ListTileTheme.of(context).subtitleTextStyle?.copyWith(
                fontSize: TextTheme.of(context).bodySmall?.fontSize,
              ),
              child: subtitle!,
            )
          : null,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        padding: const EdgeInsets.only(left: 8.0),
      ),
    );
  }
}

class SliderSettingsTile extends StatefulWidget {
  const SliderSettingsTile({
    this.icon,
    this.title,
    required this.value,
    required this.values,
    required this.onChangeEnd,
    this.labelBuilder,
  });

  final Widget? icon;
  final Widget? title;
  final double value;
  final List<double> values;
  final void Function(double value) onChangeEnd;
  final String Function(double)? labelBuilder;

  @override
  State<SliderSettingsTile> createState() => _SliderSettingsTileState();
}

class _SliderSettingsTileState extends State<SliderSettingsTile> {
  late int _index = widget.values.indexOf(widget.value);

  @override
  Widget build(BuildContext context) {
    final slider = Slider.adaptive(
      value: _index.toDouble(),
      min: 0,
      max: widget.values.length.toDouble() - 1,
      divisions: widget.values.length - 1,
      label:
          widget.labelBuilder?.call(widget.values[_index]) ??
          widget.values[_index].toString(),
      onChanged: (value) {
        final newIndex = value.toInt();
        setState(() {
          _index = newIndex;
        });
      },
      onChangeEnd: (value) {
        widget.onChangeEnd(widget.values[_index]);
      },
    );

    return ListTile(
      leading: widget.icon,
      title: widget.title ?? slider,
      subtitle: widget.title != null ? slider : null,
      trailing: widget.labelBuilder != null
          ? Text(widget.labelBuilder!.call(widget.values[_index]))
          : null,
    );
  }
}

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textShade(context, 0.5),
      ),
    );
  }
}

class _SettingsTitle extends StatelessWidget {
  const _SettingsTitle({required this.title});

  final Text title;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      maxLines: kSettingsTileTitleMaxLines,
      overflow: TextOverflow.ellipsis,
      child: Text.rich(
        TextSpan(children: [title.textSpan ?? TextSpan(text: title.data)]),
      ),
    );
  }
}

/// A platform agnostic choice picker.
///
/// It is best used for settings where the user can choose between a relatively
/// small number of options.
class ChoicePicker<T> extends StatelessWidget {
  const ChoicePicker({
    super.key,
    required this.choices,
    required this.selectedItem,
    required this.titleBuilder,
    this.subtitleBuilder,
    this.leadingBuilder,
    required this.onSelectedItemChanged,
    this.tileContentPadding,
    this.margin,
    this.notchedTile = true,
  });

  final List<T> choices;
  final T selectedItem;
  final Widget Function(T choice) titleBuilder;
  final Widget Function(T choice)? subtitleBuilder;
  final Widget Function(T choice)? leadingBuilder;
  final void Function(T choice)? onSelectedItemChanged;

  /// Android tiles content padding.
  final EdgeInsetsGeometry? tileContentPadding;

  /// iOS margin.
  final EdgeInsetsGeometry? margin;

  /// iOS only, for choosing the style of the tile.
  final bool notchedTile;

  @override
  Widget build(BuildContext context) {
    return ListSection(
      children: [
        for (final value in choices)
          ListTile(
            enabled: onSelectedItemChanged != null,
            selected: selectedItem == value,
            trailing: selectedItem == value ? const Icon(Icons.check) : null,
            contentPadding: tileContentPadding,
            title: titleBuilder(value),
            subtitle: subtitleBuilder?.call(value),
            leading: leadingBuilder?.call(value),
            onTap: onSelectedItemChanged != null
                ? () => onSelectedItemChanged!(value)
                : null,
          ),
      ],
    );
  }
}
