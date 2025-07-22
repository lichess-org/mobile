import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

import 'package:lichess_mobile/src/model/message/message_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

void main() {
  group('MessageRepository', () {
    test('loadContacts parses /inbox JSON correctly', () async {
      const inboxJson = '''
      {
        "me":{"name":"veloce","flair":"people.woman-and-man-holding-hands-medium-dark-skin-tone-dark-skin-tone","patron":true,"id":"veloce"},
        "contacts":[
          {"user":{"name":"chabrot","flair":"people.person-raising-hand-medium-skin-tone","patron":true},"lastMsg":{"text":"https://github.com/veloce/lichobile/issues/1659","user":"veloce","date":1621533013388,"read":true}},
          {"user":{"name":"thibault","flair":"smileys.disguised-face","patron":true},"lastMsg":{"text":"http://fr.stage.lichess.org/study/CTKRc8Lj","user":"thibault","date":1462036409297,"read":true}}
        ]
      }
      ''';

      final mockClient = MockClient((request) {
        if (request.url.path == '/inbox') {
          return mockResponse(inboxJson, 200);
        }
        return mockResponse('Not found', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final client = container.read(lichessClientProvider);

      final repo = MessageRepository(client);

      final data = await repo.loadContacts();
      final contacts = data.contacts;

      expect(contacts.length, 2);
      expect(contacts.first.user.name, 'chabrot');
      expect(contacts.first.lastMessage.text, 'https://github.com/veloce/lichobile/issues/1659');
      expect(contacts[1].user.name, 'thibault');
      expect(contacts[1].lastMessage.userId.value, 'thibault');
    });
  });
}
