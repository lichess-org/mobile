import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

extension AsyncValueUI on AsyncValue<Object?> {
  void showSnackbarOnError(BuildContext context) {
    if (!isRefreshing && hasError) {
      switch (Theme.of(context).platform) {
        case TargetPlatform.android:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
        case TargetPlatform.iOS:
          showCupertinoSnackBar(
            context: context,
            message: error.toString(),
            type: SnackBarType.error,
          );
        default:
          assert(false, 'Unexpected platform ${Theme.of(context).platform}');
      }
    }
  }
}
