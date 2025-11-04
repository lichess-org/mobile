import 'package:deep_pick/deep_pick.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'blog.freezed.dart';

@freezed
sealed class BlogPost with _$BlogPost {
  const factory BlogPost({
    required StringId id,
    required String title,
    required String slug,
    required DateTime createdAt,
    required Uri url,
    LightUser? author,
    Uri? imageUrl,
  }) = _BlogPost;

  factory BlogPost.fromServerJson(Map<String, dynamic> json) {
    return _blogPostFromPick(pick(json).required());
  }
}

BlogPost _blogPostFromPick(RequiredPick pick) {
  return BlogPost(
    id: pick('id').asStringIdOrThrow(),
    title: pick('title').asStringOrThrow(),
    slug: pick('slug').asStringOrThrow(),
    createdAt: pick('createdAt').asDateTimeFromMillisecondsOrThrow(),
    url: pick('url').letOrThrow((p) => Uri.parse(p.asStringOrThrow())),
    imageUrl: pick('image').letOrNull((p) => Uri.tryParse(p.asStringOrThrow())),
    author: pick('author').asLightUserOrNull(),
  );
}
