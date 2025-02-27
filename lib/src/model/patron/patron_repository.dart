import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/model/patron/patron.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'patron_repository.g.dart';

enum Frequency { onetime, monthly }

typedef StripeCheckoutSession = ({String id, String clientSecret});

typedef StripeCurrencies = (IList<PatronCurrency> currencies, String myCurrency);

@riverpod
Future<StripeCurrencies> stripeCurrencies(Ref ref) {
  return ref.withClientCacheFor(
    (client) => PatronRepository(ref, client).getCurrencies(),
    const Duration(days: 1),
  );
}

@Riverpod(keepAlive: true)
PatronRepository patronRepository(Ref ref) {
  return PatronRepository(ref, ref.read(lichessClientProvider));
}

class PatronRepository {
  PatronRepository(this.ref, this.client);

  final Client client;
  final Ref ref;

  Future<StripeCurrencies> getCurrencies() {
    return client.readJson(
      Uri(path: '/api/patron/currencies'),
      mapper: (json) {
        final currencies =
            pick(json, 'stripe').asListOrEmpty((elPick) {
              return PatronCurrency(
                code: elPick('currency').asStringOrThrow(),
                minAmount: elPick('min').asIntOrThrow(),
                maxAmount: elPick('max').asIntOrThrow(),
                lifetimePatronAmount: elPick('lifetime').asIntOrThrow(),
                defaultAmount: elPick('default').asIntOrThrow(),
                suggestedAmounts:
                    elPick('suggestions').asListOrEmpty((e) => e.asIntOrThrow()).toIList(),
              );
            }).toIList();
        return (currencies, pick(json, 'myCurrency').asStringOrThrow());
      },
    );
  }

  /// Creates a Stripe Checkout session for the given amount and frequency.
  Future<StripeCheckoutSession> stripeCheckoutSession({
    required int amount,
    required Frequency frequency,
    String? currency,
  }) {
    return client.postReadJson(
      Uri(path: '/api/patron/stripe/checkout', queryParameters: {'currency': currency}),
      body: {'amount': amount.toString(), 'freq': frequency.name},
      mapper:
          (json) => (
            id: pick(json, 'session', 'id').asStringOrThrow(),
            clientSecret: pick(json, 'session', 'clientSecret').asStringOrThrow(),
          ),
    );
  }
}
