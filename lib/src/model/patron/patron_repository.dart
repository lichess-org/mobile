import 'package:deep_pick/deep_pick.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'patron_repository.g.dart';

enum Frequency { onetime, monthly }

@Riverpod(keepAlive: true)
PatronRepository patronRepository(Ref ref) {
  return PatronRepository(ref, ref.read(lichessClientProvider));
}

class PatronRepository {
  PatronRepository(this.ref, this.client);

  final Client client;
  final Ref ref;

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

typedef StripeCheckoutSession = ({String id, String clientSecret});
