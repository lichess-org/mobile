import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/study/study_list_screen.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  group('Study list screen', () {
    testWidgets('Scrolling down loads next page', (WidgetTester tester) async {
      final requestedPages = <int>[];
      final mockClient = MockClient((request) {
        if (request.url.path == '/study/all/hot') {
          requestedPages.add(int.parse(request.url.queryParameters['page']!));

          if (request.url.queryParameters['page'] == '1') {
            return mockResponse(kStudyAllHotPage1Response, 200);
          }
          if (request.url.queryParameters['page'] == '2') {
            return mockResponse(kStudyAllHotPage2Response, 200);
          }
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StudyListScreen(),
        overrides: [
          lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        ],
      );
      await tester.pumpWidget(app);

      // Wait for study list to load
      await tester.pump();

      expect(find.text('First Study Page 1'), findsOneWidget);
      expect(find.text('First Study Page 2'), findsNothing); // On page 2

      await tester.dragUntilVisible(
        find.text('First Study Page 2'),
        find.byType(ListView),
        const Offset(0, -250),
      );

      expect(requestedPages, [1, 2]);
    });

    testWidgets('Searching', (WidgetTester tester) async {
      final requestedUrls = <String>[];
      final mockClient = MockClient((request) {
        requestedUrls.add(request.url.toString());
        if (request.url.path == '/study/all/hot' &&
            request.url.queryParameters['page'] == '1') {
          return mockResponse(kStudyAllHotPage1Response, 200);
        } else if (request.url.path == '/study/search') {
          if (request.url.queryParameters['q'] == 'Magnus') {
            return mockResponse(
              '''
{
  "paginator": {
    "currentPage": 1,
    "maxPerPage": 16,
    "currentPageResults": [
      {
        "id": "g26XbGpT",
        "name": "Magnus Carlsen Games",
        "liked": false,
        "likes": 1,
        "updatedAt": 1723817543350,
        "owner": {
          "name": "tom-anders",
          "id": "tom-anders"
        },
        "chapters": [
          "Chapter 1",
          "Chapter 2"
        ],
        "topics": [ ],
        "members": [ ]
      }
    ],
    "previousPage": null,
    "nextPage": null,
    "nbResults": 1,
    "nbPages": 1
  }
}
              ''',
              200,
            );
          }
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const StudyListScreen(),
        overrides: [
          lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        ],
      );
      await tester.pumpWidget(app);

      // Wait for default study list (all/hot) to load
      await tester.pump();

      await tester.tap(find.byType(SearchBar));

      await tester.enterText(find.byType(TextField), 'Magnus');
      // submit the search
      await tester.testTextInput.receiveAction(TextInputAction.done);

      // Wait for search results to load
      await tester.pumpAndSettle();

      expect(find.text('Magnus Carlsen Games'), findsOneWidget);
      expect(find.textContaining('Chapter 1'), findsOneWidget);
      expect(find.textContaining('Chapter 2'), findsOneWidget);
      expect(find.textContaining('tom-anders'), findsOneWidget);

      expect(requestedUrls, [
        'https://lichess.dev/study/all/hot?page=1',
        'https://lichess.dev/study/search?page=1&q=Magnus',
      ]);
    });
  });
}

// Output based on the following command (with some modifications):
// curl -X GET 'https://lichess.dev/study/all/hot' -H "Accept: application/json" 2> /dev/null | jq
const kStudyAllHotPage1Response = '''
{
  "paginator": {
    "currentPage": 1,
    "maxPerPage": 16,
    "currentPageResults": [
      {
        "id": "g26XbGpT",
        "name": "First Study Page 1",
        "liked": false,
        "likes": 1,
        "updatedAt": 1723817543350,
        "owner": {
          "name": "HeySerginho",
          "id": "heyserginho"
        },
        "chapters": [
          "Stevanic, David - Ilamparthi A R",
          "Quizon, Daniel - Raahul V S"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "HeySerginho",
              "id": "heyserginho"
            },
            "role": "w"
          },
          {
            "user": {
              "name": "AAArmstark",
              "flair": "activity.lichess-hogger",
              "id": "aaarmstark"
            },
            "role": "w"
          }
        ]
      },
      {
        "id": "6QZbnn0u",
        "name": "test",
        "liked": false,
        "likes": 1,
        "updatedAt": 1722185354120,
        "owner": {
          "name": "HeySerginho",
          "id": "heyserginho"
        },
        "chapters": [
          "Larkin, Vladyslav - Monteiro, Jose Macedo",
          "Campora, Daniel H. - Pinto, Jose Joao Meireles Alves"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "HeySerginho",
              "id": "heyserginho"
            },
            "role": "w"
          }
        ]
      },
      {
        "id": "Oc2oNWPH",
        "name": "test",
        "liked": false,
        "likes": 1,
        "updatedAt": 1722185242763,
        "owner": {
          "name": "HeySerginho",
          "id": "heyserginho"
        },
        "chapters": [
          "Larkin, Vladyslav - Monteiro, Jose Flavio",
          "Campora, Daniel H. - Pinto, Fernando Jose Seixas"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "HeySerginho",
              "id": "heyserginho"
            },
            "role": "w"
          },
          {
            "user": {
              "name": "thibault",
              "flair": "smileys.disguised-face",
              "patron": true,
              "id": "thibault"
            },
            "role": "w"
          }
        ]
      },
      {
        "id": "WLpIyPTB",
        "name": "Round 9",
        "liked": false,
        "likes": 1,
        "updatedAt": 1722016933485,
        "owner": {
          "name": "AAArmstark",
          "flair": "activity.lichess-hogger",
          "id": "aaarmstark"
        },
        "chapters": [
          "Madaminov, Mukhiddin - Macovei, Andrei",
          "Gan-Erdene, Sugar - Assaubayeva, Bibisara",
          "Chinguun, Sumiya - Materia, Marco",
          "Sukandar, Irine Kharisma - Moiseenko, Alexander"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "AAArmstark",
              "flair": "activity.lichess-hogger",
              "id": "aaarmstark"
            },
            "role": "w"
          }
        ]
      },
      {
        "id": "7BaR9QW4",
        "name": "Round 8",
        "liked": false,
        "likes": 1,
        "updatedAt": 1722016933188,
        "owner": {
          "name": "AAArmstark",
          "flair": "activity.lichess-hogger",
          "id": "aaarmstark"
        },
        "chapters": [
          "Assaubayeva, Bibisara - Madaminov, Mukhiddin",
          "Chinguun, Sumiya - Gan-Erdene, Sugar",
          "Sukandar, Irine Kharisma - Macovei, Andrei",
          "Materia, Marco - Sasikiran, Krishnan"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "AAArmstark",
              "flair": "activity.lichess-hogger",
              "id": "aaarmstark"
            },
            "role": "w"
          }
        ]
      },
      {
        "id": "oZdBmHQG",
        "name": "Round 7",
        "liked": false,
        "likes": 1,
        "updatedAt": 1722016933000,
        "owner": {
          "name": "AAArmstark",
          "flair": "activity.lichess-hogger",
          "id": "aaarmstark"
        },
        "chapters": [
          "Madaminov, Mukhiddin - Materia, Marco",
          "Sasikiran, Krishnan - Sukandar, Irine Kharisma",
          "Gan-Erdene, Sugar - Harsha Bharathakoti",
          "Juksta, Karolis - Assaubayeva, Bibisara"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "AAArmstark",
              "flair": "activity.lichess-hogger",
              "id": "aaarmstark"
            },
            "role": "w"
          }
        ]
      },
      {
        "id": "wVTCciEa",
        "name": "Round 6",
        "liked": false,
        "likes": 1,
        "updatedAt": 1722016932803,
        "owner": {
          "name": "AAArmstark",
          "flair": "activity.lichess-hogger",
          "id": "aaarmstark"
        },
        "chapters": [
          "Jumabayev, Rinat - Madaminov, Mukhiddin",
          "Materia, Marco - Ganguly, Surya Shekhar",
          "Nesterov, Arseniy - Gan-Erdene, Sugar",
          "Kersten, Uwe - Sasikiran, Krishnan"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "AAArmstark",
              "flair": "activity.lichess-hogger",
              "id": "aaarmstark"
            },
            "role": "w"
          }
        ]
      },
      {
        "id": "9WB6pTtb",
        "name": "Round 5",
        "liked": false,
        "likes": 1,
        "updatedAt": 1722016932628,
        "owner": {
          "name": "AAArmstark",
          "flair": "activity.lichess-hogger",
          "id": "aaarmstark"
        },
        "chapters": [
          "Madaminov, Mukhiddin - Nesterov, Arseniy",
          "Jumabayev, Rinat - Materia, Marco",
          "Munguntuul, Batkhuyag - Ganguly, Surya Shekhar",
          "Sasikiran, Krishnan - Harsha Bharathakoti"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "AAArmstark",
              "flair": "activity.lichess-hogger",
              "id": "aaarmstark"
            },
            "role": "w"
          }
        ]
      },
      {
        "id": "vWxkJ9Dp",
        "name": "Round 4",
        "liked": false,
        "likes": 1,
        "updatedAt": 1722016932385,
        "owner": {
          "name": "AAArmstark",
          "flair": "activity.lichess-hogger",
          "id": "aaarmstark"
        },
        "chapters": [
          "Gan-Erdene, Sugar - Sasikiran, Krishnan",
          "Nesterov, Arseniy - Munkhzul, Turmunkh",
          "Harsha Bharathakoti - Munguntuul, Batkhuyag",
          "Tahay, Alexis - Jumabayev, Rinat"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "AAArmstark",
              "flair": "activity.lichess-hogger",
              "id": "aaarmstark"
            },
            "role": "w"
          }
        ]
      },
      {
        "id": "fJSDBhRQ",
        "name": "Round 3",
        "liked": false,
        "likes": 1,
        "updatedAt": 1722016932195,
        "owner": {
          "name": "AAArmstark",
          "flair": "activity.lichess-hogger",
          "id": "aaarmstark"
        },
        "chapters": [
          "Sasikiran, Krishnan - Haimovich, Tal",
          "Arcuti, Davide - Nesterov, Arseniy",
          "Peycheva, Gergana - Harsha Bharathakoti",
          "Jumabayev, Rinat - Kersten, Uwe"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "AAArmstark",
              "flair": "activity.lichess-hogger",
              "id": "aaarmstark"
            },
            "role": "w"
          }
        ]
      },
      {
        "id": "9xh4D5mM",
        "name": "Round 2",
        "liked": false,
        "likes": 1,
        "updatedAt": 1722016932070,
        "owner": {
          "name": "AAArmstark",
          "flair": "activity.lichess-hogger",
          "id": "aaarmstark"
        },
        "chapters": [
          "Toktomushev, Teimur - Ganguly, Surya Shekhar",
          "Moiseenko, Alexander - Vemparala, Nikash",
          "Papaux, Steve - Sasikiran, Krishnan",
          "Nesterov, Arseniy - Bex, Pierre-Alain"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "AAArmstark",
              "flair": "activity.lichess-hogger",
              "id": "aaarmstark"
            },
            "role": "w"
          }
        ]
      },
      {
        "id": "D7TAt3rj",
        "name": "Round 1",
        "liked": false,
        "likes": 1,
        "updatedAt": 1722016931939,
        "owner": {
          "name": "AAArmstark",
          "flair": "activity.lichess-hogger",
          "id": "aaarmstark"
        },
        "chapters": [
          "Ganguly, Surya Shekhar - Lang, Fabian",
          "Tcheau, Alain - Moiseenko, Alexander",
          "Sasikiran, Krishnan - Arulanantham, Aneet",
          "Ranieri, Pierpaolo - Nesterov, Arseniy"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "AAArmstark",
              "flair": "activity.lichess-hogger",
              "id": "aaarmstark"
            },
            "role": "w"
          }
        ]
      },
      {
        "id": "9rZ88BkF",
        "name": "Round 8",
        "liked": false,
        "likes": 1,
        "updatedAt": 1718628262858,
        "owner": {
          "name": "AAArmstark",
          "flair": "activity.lichess-hogger",
          "id": "aaarmstark"
        },
        "chapters": [
          "Chapter 1"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "AAArmstark",
              "flair": "activity.lichess-hogger",
              "id": "aaarmstark"
            },
            "role": "w"
          }
        ]
      },
      {
        "id": "k79RXsyo",
        "name": "Round 7",
        "liked": false,
        "likes": 1,
        "updatedAt": 1718628262852,
        "owner": {
          "name": "AAArmstark",
          "flair": "activity.lichess-hogger",
          "id": "aaarmstark"
        },
        "chapters": [
          "Chapter 1"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "AAArmstark",
              "flair": "activity.lichess-hogger",
              "id": "aaarmstark"
            },
            "role": "w"
          }
        ]
      },
      {
        "id": "yqPw9epZ",
        "name": "Round 6",
        "liked": false,
        "likes": 1,
        "updatedAt": 1718628262846,
        "owner": {
          "name": "AAArmstark",
          "flair": "activity.lichess-hogger",
          "id": "aaarmstark"
        },
        "chapters": [
          "Chapter 1"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "AAArmstark",
              "flair": "activity.lichess-hogger",
              "id": "aaarmstark"
            },
            "role": "w"
          }
        ]
      },
      {
        "id": "wSLKGjre",
        "name": "Last Study Page 1",
        "liked": false,
        "likes": 1,
        "updatedAt": 1718628262840,
        "owner": {
          "name": "AAArmstark",
          "flair": "activity.lichess-hogger",
          "id": "aaarmstark"
        },
        "chapters": [
          "Chapter 1"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "AAArmstark",
              "flair": "activity.lichess-hogger",
              "id": "aaarmstark"
            },
            "role": "w"
          }
        ]
      }
    ],
    "previousPage": null,
    "nextPage": 2,
    "nbResults": 9999,
    "nbPages": 2
  }
}
''';

const kStudyAllHotPage2Response = '''
{
  "paginator": {
    "currentPage": 2,
    "maxPerPage": 16,
    "currentPageResults": [
      {
        "id": "g26XbGpT",
        "name": "First Study Page 2",
        "liked": false,
        "likes": 1,
        "updatedAt": 1723817543350,
        "owner": {
          "name": "HeySerginho",
          "id": "heyserginho"
        },
        "chapters": [
          "Stevanic, David - Ilamparthi A R",
          "Quizon, Daniel - Raahul V S"
        ],
        "topics": [
          "Broadcast"
        ],
        "members": [
          {
            "user": {
              "name": "HeySerginho",
              "id": "heyserginho"
            },
            "role": "w"
          },
          {
            "user": {
              "name": "AAArmstark",
              "flair": "activity.lichess-hogger",
              "id": "aaarmstark"
            },
            "role": "w"
          }
        ]
      }
    ],
    "previousPage": null,
    "nextPage": null,
    "nbResults": 9999,
    "nbPages": 2
  }
}
''';
