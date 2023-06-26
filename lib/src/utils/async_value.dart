import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/feedback.dart';

extension AsyncValueUI on AsyncValue<Object?> {
  void showSnackbarOnError(BuildContext context) {
    if (!isRefreshing && hasError) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        case TargetPlatform.iOS:
          showCupertinoErrorSnackBar(
            context: context,
            message: error.toString(),
          );
        default:
          assert(false, 'Unexpected platform $defaultTargetPlatform');
          break;
      }
    }
  }
}
