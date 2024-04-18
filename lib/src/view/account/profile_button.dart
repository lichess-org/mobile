import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class ProfileButton extends ConsumerWidget {
  const ProfileButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onPressed() {
      ref.invalidate(accountProvider);
      ref.invalidate(accountActivityProvider);
      pushPlatformRoute(
        context,
        title: context.l10n.profile,
        builder: (_) => const ProfileScreen(),
      );
    }

    return PlatformWidget(
      androidBuilder: (context) => IconButton(
        icon: const Icon(Icons.account_circle),
        tooltip: context.l10n.profile,
        onPressed: onPressed,
      ),
      iosBuilder: (context) => AppBarIconButton(
        semanticsLabel: context.l10n.profile,
        onPressed: onPressed,
        icon: const Icon(CupertinoIcons.profile_circled),
      ),
    );
  }
}
