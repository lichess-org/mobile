import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/chat/chat_message.dart';
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
    required StudyVisibility visibility,
    required StudySettings settings,
    required IList<String> topics,
    required IList<StudyChapterMeta> chapters,
    required StudyChapter chapter,
    required IMap<UserId, StudyMember> members,
    ChatData? chat,
    int? socketVersion,

    /// The study's flair emoji, if any.
    ///
    /// Not editable from the app yet, but must be round-tripped through [EditStudyPayload]:
    /// the server's `editStudy` reads a missing `flair` key as "clear it".
    String? flair,

    /// Hints to display in "gamebook"/"interactive" mode
    /// Index corresponds to the current ply.
    required IList<String?> hints,

    /// Comment to display when deviating from the mainline in "gamebook" mode
    /// (i.e. when making a wrong move).
    /// Index corresponds to the current ply.
    required IList<String?> deviationComments,
  }) = _Study;

  /// The owner of the study.
  StudyMember? get owner => ownerId != null ? members[ownerId!]! : null;

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
    chat: study('chat').letOrNull((p) => chatDataFromPick(p)),
    socketVersion: study('socketVersion').asIntOrNull(),
    features: (
      cloneable: study('features', 'cloneable').asBoolOrFalse(),
      chat: study('features', 'chat').asBoolOrFalse(),
      sticky: study('features', 'sticky').asBoolOrFalse(),
    ),
    visibility: StudyVisibility.values.byName(study('visibility').asStringOrThrow()),
    settings: StudySettings.fromJson(study('settings').asMapOrThrow()),
    flair: study('flair').asStringOrNull(),
    topics: study('topics').asListOrThrow((pick) => pick.asStringOrThrow()).lock,
    chapters: study(
      'chapters',
    ).asListOrThrow((pick) => StudyChapterMeta.fromJson(pick.asMapOrThrow())).lock,
    chapter: StudyChapter.fromJson(study('chapter').asMapOrThrow()),
    members: study('members')
        .asMapOrThrow<String, Map<String, Object?>>()
        .map((key, value) => MapEntry(UserId(key), StudyMember.fromJson(value)))
        .toIMap(),
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
sealed class StudyPageItem with _$StudyPageItem {
  const StudyPageItem._();

  const factory StudyPageItem({
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
  }) = _StudyPageItem;

  factory StudyPageItem.fromJson(Map<String, Object?> json) => _$StudyPageItemFromJson(json);
}

@Freezed(fromJson: true)
sealed class StudyMember with _$StudyMember {
  const StudyMember._();

  const factory StudyMember({required LightUser user, required String role}) = _StudyMember;

  factory StudyMember.fromJson(Map<String, Object?> json) => _$StudyMemberFromJson(json);
}

/// Who is allowed to see a study.
///
/// The enum names are the keys expected by the lichess API, so do not rename them.
enum StudyVisibility {
  public,
  unlisted,
  private;

  String l10n(AppLocalizations l10n) => switch (this) {
    StudyVisibility.public => l10n.studyPublic,
    StudyVisibility.unlisted => l10n.studyUnlisted,
    StudyVisibility.private => l10n.studyInviteOnly,
  };
}

/// Who is allowed to use a given study permission (e.g. the engine, or cloning the study).
///
/// The enum names are the keys expected by the lichess API, so do not rename them.
enum UserSelection {
  nobody,
  owner,
  contributor,
  member,
  everyone;

  String l10n(AppLocalizations l10n) => switch (this) {
    UserSelection.nobody => l10n.studyNobody,
    UserSelection.owner => l10n.studyOnlyMe,
    UserSelection.contributor => l10n.studyContributors,
    UserSelection.member => l10n.studyMembers,
    UserSelection.everyone => l10n.studyEveryone,
  };
}

/// A study's owner-configurable permissions, as returned by the server under the `settings` key.
@Freezed(fromJson: true)
sealed class StudySettings with _$StudySettings {
  const factory StudySettings({
    required UserSelection computer,
    required UserSelection explorer,
    required UserSelection cloneable,
    required UserSelection shareable,
    required UserSelection chat,
    required bool sticky,
    required bool description,
  }) = _StudySettings;

  factory StudySettings.fromJson(Map<String, Object?> json) => _$StudySettingsFromJson(json);
}

@freezed
sealed class CreateStudyPayload with _$CreateStudyPayload {
  const factory CreateStudyPayload({required String name, required StudyVisibility visibility}) =
      _CreateStudyPayload;
}

/// Everything the owner can change from the "Edit study" screen.
@freezed
sealed class EditStudyPayload with _$EditStudyPayload {
  const factory EditStudyPayload({
    required String name,
    required StudyVisibility visibility,
    required StudySettings settings,
  }) = _EditStudyPayload;
}

@freezed
sealed class CreateStudyChapterPayload with _$CreateStudyChapterPayload {
  const factory CreateStudyChapterPayload({
    required String pgn,
    required String name,
    required Side orientation,
    @Default(null) Variant? variant,

    /// Whether this chapter replaces the study's initial chapter.
    ///
    /// Creating a study always creates an empty first chapter along with it. Setting this drops
    /// that chapter, so that a newly created study holds only the chapter the user asked for.
    @Default(false) bool initial,
  }) = _CreateStudyChapterPayload;
}
