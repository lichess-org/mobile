import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/account/profile_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../mock_server_responses.dart';
import '../../model/auth/fake_auth_storage.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  testWidgets('refetches account data when the screen regains focus', (tester) async {
    var location = 'Lille';
    final mockClient = MockClient((request) {
      if (request.url.path == '/api/account') {
        return mockResponse(
          mockApiAccountResponse(fakeAuthUser.user.name).replaceFirst('Lille', location),
          200,
        );
      }
      return mockResponse('', 404);
    });

    final app = await makeTestProviderScopeApp(
      tester,
      home: const ProfileScreen(),
      authUser: fakeAuthUser,
      overrides: {
        lichessClientProvider: lichessClientProvider.overrideWith(
          (ref) => LichessClient(mockClient, ref),
        ),
      },
    );
    await tester.pumpWidget(app);
    await tester.pump();
    await tester.pump();
    expect(find.text('Lille'), findsOneWidget);

    final navigator = Navigator.of(tester.element(find.byType(ProfileScreen)));
    navigator.push(MaterialPageRoute<void>(builder: (_) => const SizedBox.shrink()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    location = 'Paris';
    navigator.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    await tester.pump();

    expect(find.text('Paris'), findsOneWidget);
  });
}
