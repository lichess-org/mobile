import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Whether the home screen is in widget-customization (edit) mode.
///
/// Content widgets read this to suppress their own section header in edit
/// mode, since the edit-mode row already shows the widget's stable label.
class const IsEditingHome({required super.child, required final bool isEditingWidgets})
    extends InheritedWidget {
  @override
  bool updateShouldNotify(IsEditingHome oldWidget) {
    return isEditingWidgets != oldWidget.isEditingWidgets;
  }

  static IsEditingHome? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<IsEditingHome>();
  }

  /// Whether the home screen is in widget-customization (edit) mode.
  static bool isEditing(BuildContext context) {
    return maybeOf(context)?.isEditingWidgets ?? false;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isEditingWidgets', isEditingWidgets));
  }
}
