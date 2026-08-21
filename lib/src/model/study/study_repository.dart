import 'dart:convert';

import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_summary.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_filter.dart';
import 'package:lichess_mobile/src/model/study/study_list_paginator.dart';
import 'package:lichess_mobile/src/network/http.dart';

/// A provider for [StudyRepository].
final studyRepositoryProvider = Provider<StudyRepository>((Ref ref) {
  return StudyRepository(ref, ref.watch(lichessClientProvider));
}, name: 'StudyRepositoryProvider');

class StudyRepository {
  StudyRepository(this.ref, this.client);

  final Client client;
  final Ref ref;

  Future<StudyList> getStudies({
    required StudyCategory category,
    required StudyListOrder order,
    int page = 1,
  }) {
    return _requestStudies(
      path: '${category.name}/${order.name}',
      queryParameters: {'page': page.toString()},
    );
  }

  Future<StudyList> searchStudies({
    required String query,
    required StudyListOrder order,
    int page = 1,
  }) {
    return _requestStudies(
      path: 'search',
      queryParameters: {'page': page.toString(), 'q': query, 'order': order.name},
    );
  }

  Future<StudyList> _requestStudies({
    required String path,
    required Map<String, String> queryParameters,
  }) {
    return client.readJson(
      Uri(path: '/study/$path', queryParameters: queryParameters),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) {
        final paginator = pick(json, 'paginator').asMapOrThrow<String, dynamic>();

        return (
          studies: pick(
            paginator,
            'currentPageResults',
          ).asListOrThrow((pick) => StudyPageItem.fromJson(pick.asMapOrThrow())).toIList(),
          nextPage: pick(paginator, 'nextPage').asIntOrNull(),
        );
      },
    );
  }

  Future<(Study study, AnalysisSummary? analysisSummary, String pgn)> getStudy({
    required StudyId id,
    StudyChapterId? chapterId,
  }) async {
    final study = await client.readJson(
      Uri(
        path: (chapterId != null) ? '/study/$id/$chapterId' : '/study/$id',
        queryParameters: {'chapters': '1'},
      ),
      headers: {'Accept': 'application/json'},
      mapper: Study.fromServerJson,
    );

    final response = await client.readResponse(
      Uri(
        path: '/api/study/$id/${chapterId ?? study.chapter.id}.pgn',
        queryParameters: {'analysisHeader': '1'},
      ),
      headers: {'Accept': 'application/x-chess-pgn'},
    );

    return (study, readAnalysisSummaryFromHeader(response), utf8.decode(response.bodyBytes));
  }

  Future<String> getStudyPgn(StudyId id) async {
    final pgnBytes = await client.readBytes(
      Uri(path: '/api/study/$id.pgn'),
      headers: {'Accept': 'application/x-chess-pgn'},
    );

    return utf8.decode(pgnBytes);
  }

  /// Creates a new study and returns its id.
  ///
  /// The study is created with a single empty chapter, which [createChapter] replaces when passed
  /// a payload with `initial: true`.
  Future<StudyId> createStudy(CreateStudyPayload study) async {
    return await client.postReadJson<StudyId>(
      Uri(path: '/api/study'),
      body: {
        'name': study.name,
        'visibility': study.visibility.name,
        'computer': 'everyone',
        'explorer': 'everyone',
        'cloneable': 'everyone',
        'shareable': 'everyone',
        'chat': 'member',
        'sticky': 'true',
        'description': 'false',
      },
      mapper: (json) => StudyId(pick(json, 'id').asStringOrThrow()),
    );
  }

  /// Creates one or more (if the PGN contains multiple games) chapters in the study with the given [studyId].
  Future<IList<StudyChapterId>> createChapter(
    StudyId studyId,
    CreateStudyChapterPayload chapter,
  ) async {
    return await client.postReadJson<IList<StudyChapterId>>(
      Uri(path: '/api/study/$studyId/import-pgn'),
      body: {
        'pgn': chapter.pgn,
        'name': chapter.name,
        'orientation': chapter.orientation.name,
        if (chapter.variant != null) 'variant': chapter.variant!.name,
        'initial': chapter.initial.toString(),
      },
      mapper: (json) => pick(
        json,
        'chapters',
      ).asListOrThrow((pick) => StudyChapterId(pick.required()('id').asStringOrThrow())).lock,
    );
  }

  /// Deletes the chapter with the given [chapterId] from the study with the given [studyId].
  ///
  /// The server refuses to delete a study's only chapter.
  Future<void> deleteChapter(StudyId studyId, StudyChapterId chapterId) async {
    await client.deleteRead(Uri(path: '/api/study/$studyId/$chapterId'));
  }
}
