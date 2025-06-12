import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:lichess_mobile/src/view/settings/account_preferences_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';

class AccountMenu extends ConsumerStatefulWidget {
  const AccountMenu({super.key});

  @override
  ConsumerState<AccountMenu> createState() => _AccountMenuState();
}

class _AccountMenuState extends ConsumerState<AccountMenu> {
  bool errorLoadingFlair = false;

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authControllerProvider);
    final account = ref.watch(accountProvider);
    final userSession = ref.watch(authSessionProvider);
    final LightUser? user = account.valueOrNull?.lightUser ?? userSession?.user;

    return ContextMenuIconButton(
      icon: switch (account) {
        AsyncData(:final value) =>
          value == null
              ? const Icon(Icons.account_circle_outlined, size: 30)
              : CircleAvatar(
                  radius: 16,
                  foregroundImage: value.flair != null
                      ? CachedNetworkImageProvider(lichessFlairSrc(value.flair!))
                      : null,
                  onForegroundImageError: value.flair != null
                      ? (error, _) {
                          setState(() {
                            errorLoadingFlair = true;
                          });
                        }
                      : null,
                  backgroundColor: value.flair == null || errorLoadingFlair
                      ? null
                      : ColorScheme.of(context).surfaceContainer,
                  child: value.flair == null || errorLoadingFlair ? Text(value.initials) : null,
                ),
        _ => Icon(Icons.account_circle_outlined, semanticLabel: context.l10n.signIn, size: 30),
      },
      semanticsLabel: user == null ? context.l10n.signIn : user.name,
      actions: [
        if (userSession != null) ...[
          ContextMenuAction(
            icon: Icons.person_outline,
            label: context.l10n.profile,
            onPressed: () {
              ref.invalidate(accountProvider);
              Navigator.of(context).push(ProfileScreen.buildRoute(context));
            },
          ),
          ContextMenuAction(
            icon: Icons.manage_accounts_outlined,
            label: context.l10n.preferencesPreferences,
            onPressed: () {
              Navigator.of(context).push(AccountPreferencesScreen.buildRoute(context));
            },
          ),
          if (authController.isLoading)
            ContextMenuAction(
              icon: Icons.logout_outlined,
              label: context.l10n.logOut,
              onPressed: null, // Disabled while loading
            )
          else
            ContextMenuAction(
              icon: Icons.logout_outlined,
              label: context.l10n.logOut,
              onPressed: () {
                _showSignOutConfirmDialog(context, ref);
              },
            ),
        ] else ...[
          if (authController.isLoading)
            ContextMenuAction(
              icon: Icons.login_outlined,
              label: context.l10n.signIn,
              onPressed: null, // Disabled while loading
            )
          else
            ContextMenuAction(
              icon: Icons.login_outlined,
              label: context.l10n.signIn,
              onPressed: () {
                ref.read(authControllerProvider.notifier).signIn();
              },
            ),
        ],
      ],
    );
  }

  Future<void> _showSignOutConfirmDialog(BuildContext context, WidgetRef ref) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return showCupertinoActionSheet(
        context: context,
        actions: [
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.logOut),
            isDestructiveAction: true,
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      );
    } else {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(context.l10n.logOut),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(textStyle: TextTheme.of(context).labelLarge),
                child: Text(context.l10n.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(textStyle: TextTheme.of(context).labelLarge),
                child: Text(context.l10n.mobileOkButton),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await ref.read(authControllerProvider.notifier).signOut();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
