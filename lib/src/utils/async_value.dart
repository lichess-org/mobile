import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/feedback.dart';

extension AsyncValueUI on AsyncValue<Object?> {
  void showSnackbarOnError(BuildContext context) {
    if (!isRefreshing && hasError) {
      showAdaptiveSnackBar(context, content: Text(error.toString()));
    }
  }
}
