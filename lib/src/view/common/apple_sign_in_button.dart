import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/utils/apple_sign_in_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInButton extends StatelessWidget {
  final AppleSignInService _appleSignInService = AppleSignInService();
  final Function(UserCredential) onSignInSuccess;
  final Function(dynamic) onSignInError;

  AppleSignInButton({
    required this.onSignInSuccess,
    required this.onSignInError,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SignInWithApple.isAvailable(),
      builder: (context, snapshot) {
        // Only show the button if Apple Sign In is available on this device
        if (snapshot.data == true) {
          return ElevatedButton.icon(
            icon: const Icon(Icons.apple, color: Colors.black),
            label: const Text('Sign in with Apple'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              try {
                final userCredential = await _appleSignInService.signInWithApple();
                if (userCredential != null) {
                  onSignInSuccess(userCredential);
                }
              } catch (e) {
                onSignInError(e);
              }
            },
          );
        }
        return const SizedBox.shrink(); // Don't show the button if Apple Sign In is not available
      },
    );
  }
}
