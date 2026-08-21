import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_summary.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:mocktail/mocktail.dart';

import '../../network/fake_websocket_channel.dart';
import '../../test_container.dart';

class MockStudyRepository extends Mock implements StudyRepository {}

const _testId = StudyId('test-id');
const _testOptions = (id: _testId, initialChapter: null);
final _studySocketUri = Uri(path: '/study/${_testId.value}/socket/v6');

const _originalSettings = StudySettings(
  computer: UserSelection.everyone,
  explorer: UserSelection.everyone,
  cloneable: UserSelection.everyone,
  shareable: UserSelection.everyone,
  chat: UserSelection.member,
  sticky: true,
  description: false,
);

const _newSettings = StudySettings(
  computer: UserSelection.contributor,
  explorer: UserSelection.contributor,
  cloneable: UserSelection.nobody,
  shareable: UserSelection.nobody,
  chat: UserSelection.everyone,
  sticky: false,
  description: true,
);

const _editPayload = EditStudyPayload(
  name: 'New name',
  visibility: StudyVisibility.unlisted,
  settings: _newSettings,
);

Study _makeStudy({
  String name = 'Original name',
  StudyVisibility visibility = StudyVisibility.public,
  StudySettings settings = _originalSettings,
}) {
  const chapter = StudyChapter(
    id: StudyChapterId('1'),
    setup: StudyChapterSetup(id: null, orientation: Side.white, variant: Variant.standard, fromFen: null),
    conceal: null,
    features: (computer: true, explorer: true),
    gamebook: false,
    practise: false,
  );
  return Study(
    id: _testId,
    name: name,
    liked: false,
    likes: 0,
    ownerId: const UserId('me'),
    features: (cloneable: true, chat: true, sticky: true),
    visibility: visibility,
    settings: settings,
    topics: const IList.empty(),
    chapters: IList(const [StudyChapterMeta(id: StudyChapterId('1'), name: '', fen: null)]),
    chapter: chapter,
    members: IMap(const {
      UserId('me'): StudyMember(user: LightUser(id: UserId('me'), name: 'me'), role: 'w'),
    }),
    hints: const IList.empty(),
    deviationComments: const IList.empty(),
  );
}

void main() {
  group('StudyController.editStudy', () {
    test('sends the message the server expects and updates state optimistically', () async {
      final mockRepository = MockStudyRepository();
      when(
        () => mockRepository.getStudy(id: _testId, chapterId: any(named: 'chapterId')),
      ).thenAnswer((_) async => (_makeStudy(), null as AnalysisSummary?, ''));

      final socketFactory = ListenableFakeWebSocketChannelFactory(createDefaultFakeWebSocketChannel);

      final container = await makeContainer(
        overrides: {
          studyRepositoryProvider: studyRepositoryProvider.overrideWith((ref) => mockRepository),
          webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWith(
            (ref) => socketFactory,
          ),
        },
      );

      // studyControllerProvider is autoDispose: a bare .read() doesn't keep it alive, and it would
      // get torn down (losing all state) during editStudy's multi-second retry delay below. A
      // persistent listener is what a real widget's ref.watch would provide.
      addTearDown(
        container.listen(studyControllerProvider(_testOptions), (_, _) {}).close,
      );

      await container.read(studyControllerProvider(_testOptions).future);

      final sentMessages = <dynamic>[];
      final subscription = socketFactory.outgoingMessages(_studySocketUri).listen(sentMessages.add);
      addTearDown(subscription.cancel);

      final pending = container
          .read(studyControllerProvider(_testOptions).notifier)
          .editStudy(_editPayload);

      // The local state must reflect the change immediately, without waiting on the server
      // round-trip: this is what makes the UI feel instant.
      final study = container.read(studyControllerProvider(_testOptions)).requireValue.study;
      expect(study.name, 'New name');
      expect(study.visibility, StudyVisibility.unlisted);
      expect(study.settings, _newSettings);

      // The message actually sent over the wire must match what the server's `editStudy` socket
      // handler expects (lila's `StudyForm.FormData` JSON reads).
      await Future<void>.delayed(Duration.zero);
      expect(sentMessages, hasLength(1));
      final decoded = jsonDecode(sentMessages.single as String) as Map<String, dynamic>;
      expect(decoded['t'], 'editStudy');
      expect(decoded['d'], {
        'name': 'New name',
        'visibility': 'unlisted',
        'computer': 'contributor',
        'explorer': 'contributor',
        'cloneable': 'nobody',
        'shareable': 'nobody',
        'chat': 'everyone',
        'sticky': false,
        'description': true,
      });

      await pending;
    });

    test(
      'confirms success once the server-side change is read back',
      () async {
        final mockRepository = MockStudyRepository();
        var editApplied = false;
        when(() => mockRepository.getStudy(id: _testId, chapterId: any(named: 'chapterId'))).thenAnswer(
          (_) async => (
            editApplied
                ? _makeStudy(
                    name: 'New name',
                    visibility: StudyVisibility.unlisted,
                    settings: _newSettings,
                  )
                : _makeStudy(),
            null as AnalysisSummary?,
            '',
          ),
        );

        final container = await makeContainer(
          overrides: {
            studyRepositoryProvider: studyRepositoryProvider.overrideWith((ref) => mockRepository),
          },
        );
        addTearDown(
          container.listen(studyControllerProvider(_testOptions), (_, _) {}).close,
        );

        await container.read(studyControllerProvider(_testOptions).future);
        editApplied = true;

        final succeeded = await container
            .read(studyControllerProvider(_testOptions).notifier)
            .editStudy(_editPayload);

        expect(succeeded, isTrue);
        final study = container.read(studyControllerProvider(_testOptions)).requireValue.study;
        expect(study.name, 'New name');
        expect(study.settings, _newSettings);
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );

    test(
      'reports failure and reverts local state when the server silently rejects the change '
      '(e.g. the caller lost owner/admin permissions)',
      () async {
        final mockRepository = MockStudyRepository();
        // The server never actually applies the edit — this is exactly what happens when
        // `canActAsOwner` returns false: no error is sent back, the message is just dropped.
        when(
          () => mockRepository.getStudy(id: _testId, chapterId: any(named: 'chapterId')),
        ).thenAnswer((_) async => (_makeStudy(), null as AnalysisSummary?, ''));

        final container = await makeContainer(
          overrides: {
            studyRepositoryProvider: studyRepositoryProvider.overrideWith((ref) => mockRepository),
          },
        );
        addTearDown(
          container.listen(studyControllerProvider(_testOptions), (_, _) {}).close,
        );

        await container.read(studyControllerProvider(_testOptions).future);

        final succeeded = await container
            .read(studyControllerProvider(_testOptions).notifier)
            .editStudy(_editPayload);

        expect(succeeded, isFalse);
        // Local state must be rolled back to the server's truth, not left showing the rejected
        // optimistic update.
        final study = container.read(studyControllerProvider(_testOptions)).requireValue.study;
        expect(study.name, 'Original name');
        expect(study.settings, _originalSettings);
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );
  });
}
