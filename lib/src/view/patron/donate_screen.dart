import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/patron/patron_repository.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

const _kTextParagraphPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

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

  int? _selectedAmount;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authSessionProvider);
    final authController = ref.watch(authControllerProvider);
    final currencies = ref.watch(stripeCurrenciesProvider);

    final appBarTitle = Text(context.l10n.patronDonate);

    switch (currencies) {
      case AsyncData(:final value):
        final (currencies, myCurrencyCode) = value;
        final myCurrency = currencies.firstWhere((c) => c.code == myCurrencyCode);

        _selectedAmount ??= myCurrency.defaultAmount;

        final numberFormat = NumberFormat.currency(name: myCurrencyCode, decimalDigits: 0);

        return PlatformScaffold(
          appBarTitle: appBarTitle,
          body: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                // Padding(
                //   padding: _kTextParagraphPadding,
                //   child: Text(context.l10n.patronWeAreNonProfit),
                // ),
                // Padding(
                //   padding: _kTextParagraphPadding,
                //   child: Text(context.l10n.patronWeRelyOnSupport),
                // ),
                Padding(
                  padding: Styles.bodySectionPadding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        spacing: 4.0,
                        runSpacing: 8.0,
                        children: [
                          for (final amount in myCurrency.suggestedAmounts)
                            ChoiceChip(
                              label: Text(numberFormat.format(amount)),
                              selected: amount == _selectedAmount,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedAmount = amount;
                                  } else {
                                    _selectedAmount = null;
                                  }
                                });
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      if (session == null)
                        FatButton(
                          semanticsLabel: context.l10n.signIn,
                          onPressed:
                              authController.isLoading
                                  ? null
                                  : () => ref.read(authControllerProvider.notifier).signIn(),
                          child: Text(context.l10n.patronLogInToDonate),
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
                                        try {
                                          setState(() {
                                            _initPaymentSheetFuture = initPaymentSheet(
                                              _selectedAmount!,
                                              currency: myCurrencyCode,
                                            );
                                          });

                                          await _initPaymentSheetFuture;
                                          await confirmPayment();

                                          if (context.mounted) {
                                            showPlatformSnackbar(
                                              context,
                                              context.l10n.patronThankYou,
                                              type: SnackBarType.success,
                                            );
                                          }
                                        } finally {
                                          setState(() {
                                            _initPaymentSheetFuture = null;
                                          });
                                        }
                                      },
                              semanticsLabel: context.l10n.patronDonate,
                              child: Text(context.l10n.patronDonate),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case AsyncError(:final error):
        return PlatformScaffold(
          appBarTitle: appBarTitle,
          body: Center(child: Text(error.toString())),
        );
      case _:
        return PlatformScaffold(
          appBarTitle: appBarTitle,
          body: const Center(child: CircularProgressIndicator()),
        );
    }
  }

  Future<void> initPaymentSheet(int amount, {required String currency}) async {
    final themeMode =
        Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

    try {
      // 1. create payment intent on the server
      final stripeSession = await ref
          .read(patronRepositoryProvider)
          .stripeCheckoutSession(amount: amount, frequency: Frequency.onetime, currency: currency);

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          paymentIntentClientSecret: stripeSession.clientSecret,
          applePay: const PaymentSheetApplePay(merchantCountryCode: 'FR'),
          googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'FR', testEnv: true),
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
