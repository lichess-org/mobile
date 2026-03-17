import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A broadcast stream controller that receives the OAuth redirect URI after the
/// user completes the authorization flow in the external browser.
///
/// The [oauthCallbackProvider] receives the URI from app links.
/// listener and forwards it to any awaiting [AuthRepository.signIn] call.
final oauthCallbackProvider = Provider<StreamController<Uri>>((ref) {
  final controller = StreamController<Uri>.broadcast();
  ref.onDispose(controller.close);
  return controller;
});
