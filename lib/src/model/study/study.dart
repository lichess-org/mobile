import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'study.freezed.dart';
part 'study.g.dart';

@freezed
sealed class Study with _$Study {
  const Study._();

  const factory Study({
    required StudyId id,
    required String name,
    required bool liked,
    required int likes,
    required UserId? ownerId,
    required StudyFeatures features,
    required IList<String> topics,
    required IList<StudyChapterMeta> chapters,
    required StudyChapter chapter,

    /// Hints to display in "gamebook"/"interactive" mode
    /// Index corresponds to the current ply.
    required IList<String?> hints,

    /// Comment to display when deviating from the mainline in "gamebook" mode
    /// (i.e. when making a wrong move).
    /// Index corresponds to the current ply.
    required IList<String?> deviationComments,
  }) = _Study;

  /// Returns the index of the chapter with the given [chapterId].
  ///
  /// Searches through the list of chapters and returns the index of the first
  /// chapter that matches the provided [chapterId]. If no chapter is found,
  /// returns -1.
  ///
  /// [chapterId] - The ID of the chapter to find.
  ///
  /// Returns the index of the chapter if found, otherwise -1.
  int getChapterIndex(StudyChapterId chapterId) {
    return chapters.indexWhere((c) => c.id == chapterId);
  }

  StudyChapterMeta get currentChapterMeta => chapters.firstWhere((c) => c.id == chapter.id);

  factory Study.fromServerJson(Map<String, Object?> json) {
    return _studyFromPick(pick(json).required());
  }
}

Study _studyFromPick(RequiredPick pick) {
  final treeParts = pick('analysis', 'treeParts').asListOrThrow((part) => part);

  final hints = <String?>[];
  final deviationComments = <String?>[];

  for (final part in treeParts) {
    hints.add(part('gamebook', 'hint').asStringOrNull());
    deviationComments.add(part('gamebook', 'deviation').asStringOrNull());
  }

  final study = pick('study');
  return Study(
    id: study('id').asStudyIdOrThrow(),
    name: study('name').asStringOrThrow(),
    liked: study('liked').asBoolOrThrow(),
    likes: study('likes').asIntOrThrow(),
    ownerId: study('ownerId').asUserIdOrNull(),
    features: (
      cloneable: study('features', 'cloneable').asBoolOrFalse(),
      chat: study('features', 'chat').asBoolOrFalse(),
      sticky: study('features', 'sticky').asBoolOrFalse(),
    ),
    topics: study('topics').asListOrThrow((pick) => pick.asStringOrThrow()).lock,
    chapters:
        study(
          'chapters',
        ).asListOrThrow((pick) => StudyChapterMeta.fromJson(pick.asMapOrThrow())).lock,
    chapter: StudyChapter.fromJson(study('chapter').asMapOrThrow()),
    hints: hints.lock,
    deviationComments: deviationComments.lock,
  );
}

typedef StudyFeatures = ({bool cloneable, bool chat, bool sticky});

@Freezed(fromJson: true)
sealed class StudyChapter with _$StudyChapter {
  const StudyChapter._();

  const factory StudyChapter({
    required StudyChapterId id,
    required StudyChapterSetup setup,
    @JsonKey(defaultValue: false) required bool practise,
    required int? conceal,
    @JsonKey(defaultValue: false) required bool gamebook,
    @JsonKey(fromJson: studyChapterFeaturesFromJson) required StudyChapterFeatures features,
  }) = _StudyChapter;

  factory StudyChapter.fromJson(Map<String, Object?> json) => _$StudyChapterFromJson(json);
}

typedef StudyChapterFeatures = ({bool computer, bool explorer});

StudyChapterFeatures studyChapterFeaturesFromJson(Map<String, Object?> json) {
  return (
    computer: json['computer'] as bool? ?? false,
    explorer: json['explorer'] as bool? ?? false,
  );
}

@Freezed(fromJson: true)
sealed class StudyChapterSetup with _$StudyChapterSetup {
  const StudyChapterSetup._();

  const factory StudyChapterSetup({
    required GameId? id,
    required Side orientation,
    @JsonKey(fromJson: _variantFromJson) required Variant variant,
    required bool? fromFen,
  }) = _StudyChapterSetup;

  factory StudyChapterSetup.fromJson(Map<String, Object?> json) =>
      _$StudyChapterSetupFromJson(json);
}

Variant _variantFromJson(Map<String, Object?> json) {
  return Variant.values.firstWhereOrNull((v) => v.name == json['key'])!;
}

@Freezed(fromJson: true)
sealed class StudyChapterMeta with _$StudyChapterMeta {
  const StudyChapterMeta._();

  const factory StudyChapterMeta({
    required StudyChapterId id,
    required String name,
    required String? fen,
  }) = _StudyChapterMeta;

  factory StudyChapterMeta.fromJson(Map<String, Object?> json) => _$StudyChapterMetaFromJson(json);
}

@Freezed(fromJson: true)
sealed class StudyPageData with _$StudyPageData {
  const StudyPageData._();

  const factory StudyPageData({
    required StudyId id,
    required String name,
    required bool liked,
    required int likes,
    @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch) required DateTime updatedAt,
    required LightUser? owner,
    required IList<String> topics,
    required IList<StudyMember> members,
    required IList<String> chapters,
    required String? flair,
  }) = _StudyPageData;

  factory StudyPageData.fromJson(Map<String, Object?> json) => _$StudyPageDataFromJson(json);
}

@Freezed(fromJson: true)
sealed class StudyMember with _$StudyMember {
  const StudyMember._();

  const factory StudyMember({required LightUser user, required String role}) = _StudyMember;

  factory StudyMember.fromJson(Map<String, Object?> json) => _$StudyMemberFromJson(json);
}
