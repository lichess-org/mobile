import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'coach.freezed.dart';

final RegExp _youtubeVideoIdRegex = RegExp(
  r'(?:youtube\.com|youtu\.be)/(?:watch)?(?:\?v=)?([^"&?/ ]{11})',
);
final RegExp _studyIdRegex = RegExp(r'lichess\.org/study/(\w{8})');

IList<String> _parseYoutubeUrls(String text) {
  return text
      .split('\n')
      .map(_youtubeVideoIdRegex.firstMatch)
      .nonNulls
      .map((match) => match[1]!)
      .take(6)
      .map((id) => 'https://www.youtube.com/watch?v=$id')
      .toIList();
}

IList<String> _parseStudyIds(String text) {
  return text
      .split('\n')
      .map(_studyIdRegex.firstMatch)
      .nonNulls
      .map((match) => match[1]!)
      .take(6)
      .toIList();
}

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
      rating: pick('coach', 'user', 'rating').asIntOrNull(),
      languages: pick('coach', 'languages').asListOrEmpty((it) => it.asStringOrThrow()).toIList(),
      nbReviews: pick('coach', 'nbReviews').asIntOrThrow(),
      available: pick('coach', 'available').asBoolOrThrow(),
      listed: pick('coach', 'listed').asBoolOrThrow(),
      headline: pick('coach', 'profile', 'headline').asStringOrNull(),
      hourlyRate: pick('coach', 'profile', 'hourlyRate').asStringOrNull(),
      picture: pick('coach', 'picture').asStringOrNull(),
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
    final profile = pick('coach', 'profile');
    return CoachProfile(
      user: pick('user').asLightUserOrThrow(),
      rating: pick('coach', 'user', 'rating').asIntOrNull(),
      languages: pick('coach', 'languages').asListOrEmpty((it) => it.asStringOrThrow()).toIList(),
      nbReviews: pick('coach', 'nbReviews').asIntOrThrow(),
      available: pick('coach', 'available').asBoolOrThrow(),
      listed: pick('coach', 'listed').asBoolOrThrow(),
      headline: profile('headline').asStringOrNull(),
      hourlyRate: profile('hourlyRate').asStringOrNull(),
      picture: pick('coach', 'picture').asStringOrNull(),
      youtubeVideos: _parseYoutubeUrls(profile('youtubeVideos').asStringOrNull() ?? ''),
      studies: _parseStudyIds(profile('publicStudies').asStringOrNull() ?? ''),
      description: profile('description').asStringOrNull(),
      playingExperience: profile('playingExperience').asStringOrNull(),
      teachingExperience: profile('teachingExperience').asStringOrNull(),
      otherExperience: profile('otherExperience').asStringOrNull(),
      skills: profile('skills').asStringOrNull(),
      methodology: profile('methodology').asStringOrNull(),
      youtubeChannel: profile('youtubeChannel').asStringOrNull(),
    );
  }
}
