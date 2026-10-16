import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'coach.freezed.dart';

@freezed
sealed class CoachPreview with _$CoachPreview {
  const factory({
    required LightUser user,
    int? rating,
    required IList<String> languages,
    required int nbReviews,
    required bool available,
    required bool listed,
    String? headline,
    String? hourlyRate,
    String? picture,
  }) = _CoachPreview;

  factory fromPick(RequiredPick pick) {
    return CoachPreview(
      user: pick('user').asLightUserOrThrow(),
      rating: pick('rating').asIntOrNull(),
      languages: pick('languages').asListOrEmpty((it) => it.asStringOrThrow()).toIList(),
      nbReviews: pick('nbReviews').asIntOrThrow(),
      available: pick('available').asBoolOrThrow(),
      listed: pick('listed').asBoolOrThrow(),
      headline: pick('headline').asStringOrNull(),
      hourlyRate: pick('hourlyRate').asStringOrNull(),
      picture: pick('picture').asStringOrNull(),
    );
  }
}

@freezed
sealed class CoachProfile with _$CoachProfile {
  const factory({
    required LightUser user,
    int? rating,
    required IList<String> languages,
    required int nbReviews,
    required bool available,
    required bool listed,
    String? headline,
    String? hourlyRate,
    String? picture,
    required IList<String> youtubeVideos,
    required IList<String> studies,
    String? description,
    String? playingExperience,
    String? teachingExperience,
    String? otherExperience,
    String? skills,
    String? methodology,
    String? youtubeChannel,
  }) = _CoachProfile;

  factory fromPick(RequiredPick pick) {
    return CoachProfile(
      user: pick('user').asLightUserOrThrow(),
      rating: pick('rating').asIntOrNull(),
      languages: pick('languages').asListOrEmpty((it) => it.asStringOrThrow()).toIList(),
      nbReviews: pick('nbReviews').asIntOrThrow(),
      available: pick('available').asBoolOrThrow(),
      listed: pick('listed').asBoolOrThrow(),
      headline: pick('headline').asStringOrNull(),
      hourlyRate: pick('hourlyRate').asStringOrNull(),
      picture: pick('picture').asStringOrNull(),
      youtubeVideos: pick('youtubeVideos').asListOrEmpty((it) => it.asStringOrThrow()).toIList(),
      studies: pick('studies').asListOrEmpty((it) => it.asStringOrThrow()).toIList(),
      description: pick('description').asStringOrNull(),
      playingExperience: pick('playingExperience').asStringOrNull(),
      teachingExperience: pick('teachingExperience').asStringOrNull(),
      otherExperience: pick('otherExperience').asStringOrNull(),
      skills: pick('skills').asStringOrNull(),
      methodology: pick('methodology').asStringOrNull(),
      youtubeChannel: pick('youtubeChannel').asStringOrNull(),
    );
  }
}
