import 'dart:convert';

import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
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

  Future<(Study study, String pgn)> getStudy({
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

    final pgnBytes = await client.readBytes(
      Uri(path: '/api/study/$id/${chapterId ?? study.chapter.id}.pgn'),
      headers: {'Accept': 'application/x-chess-pgn'},
    );

    return (study, utf8.decode(pgnBytes));
  }

  Future<String> getStudyPgn(StudyId id) async {
    final pgnBytes = await client.readBytes(
      Uri(path: '/api/study/$id.pgn'),
      headers: {'Accept': 'application/x-chess-pgn'},
    );

    return utf8.decode(pgnBytes);
  }
}
