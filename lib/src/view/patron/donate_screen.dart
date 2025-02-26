import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/patron/patron_repository.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class DonateScreen extends ConsumerStatefulWidget {
  const DonateScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const DonateScreen(),
      title: context.l10n.patronDonate,
    );
  }

  @override
  ConsumerState<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends ConsumerState<DonateScreen> {
  Future<void>? _initPaymentSheetFuture;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authSessionProvider);
    final authController = ref.watch(authControllerProvider);

    return PlatformScaffold(
      appBarTitle: Text(context.l10n.patronDonate),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Amount: \$5'),
            if (session == null)
              FatButton(
                semanticsLabel: context.l10n.signIn,
                onPressed:
                    authController.isLoading
                        ? null
                        : () => ref.read(authControllerProvider.notifier).signIn(),
                child: Text(context.l10n.signIn),
              )
            else
              FutureBuilder(
                future: _initPaymentSheetFuture,
                builder: (context, snapshot) {
                  return FatButton(
                    onPressed:
                        snapshot.connectionState == ConnectionState.waiting
                            ? null
                            : () async {
                              setState(() {
                                _initPaymentSheetFuture = initPaymentSheet();
                              });

                              await _initPaymentSheetFuture;
                              await confirmPayment();
                            },
                    semanticsLabel: context.l10n.patronDonate,
                    child: Text(context.l10n.patronDonate),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> initPaymentSheet() async {
    final themeMode =
        Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

    try {
      // 1. create payment intent on the server
      final stripeSession = await ref
          .read(patronRepositoryProvider)
          .stripeCheckoutSession(amount: 5, frequency: Frequency.onetime);

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          paymentIntentClientSecret: stripeSession.clientSecret,
          applePay: const PaymentSheetApplePay(merchantCountryCode: 'US'),
          googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'US', testEnv: true),
          style: themeMode,
        ),
      );
    } catch (e) {
      if (mounted) {
        showPlatformSnackbar(context, e.toString(), type: SnackBarType.error);
      }
      rethrow;
    }
  }

  Future<void> confirmPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      if (mounted) {
        if (e is StripeException) {
          showPlatformSnackbar(
            context,
            e.error.localizedMessage ?? e.error.toString(),
            type: SnackBarType.error,
          );
        } else {
          showPlatformSnackbar(context, e.toString(), type: SnackBarType.error);
        }
      }
      rethrow;
    }
  }
}
