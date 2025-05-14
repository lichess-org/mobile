import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

@freezed
sealed class Profile with _$Profile {
  const factory Profile({
    String? country,
    String? location,
    String? bio,
    String? realName,
    int? fideRating,
    int? uscfRating,
    int? ecfRating,
    IList<SocialLink>? links,
  }) = _Profile;

  const Profile._();

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile.fromPick(pick(json).required());
  }

  factory Profile.fromPick(RequiredPick pick) {
    const lineSplitter = LineSplitter();
    final rawLinks = pick('links').letOrNull((e) => lineSplitter.convert(e.asStringOrThrow()));

    return Profile(
      country: pick('flag').asStringOrNull() ?? pick('country').asStringOrNull(),
      location: pick('location').asStringOrNull(),
      bio: pick('bio').asStringOrNull(),
      realName: pick('realName').asStringOrNull(),
      fideRating: pick('fideRating').asIntOrNull(),
      uscfRating: pick('uscfRating').asIntOrNull(),
      ecfRating: pick('ecfRating').asIntOrNull(),
      links:
          rawLinks
              ?.where((e) => e.trim().isNotEmpty)
              .map((e) {
                final link = SocialLink.fromUrl(e);
                if (link == null) {
                  final uri = Uri.tryParse(e);
                  if (uri != null) {
                    return SocialLink(site: null, url: uri);
                  }
                  return null;
                }
                return link;
              })
              .nonNulls
              .toIList(),
    );
  }
}

@freezed
sealed class SocialLink with _$SocialLink {
  const factory SocialLink({required LinkSite? site, required Uri url}) = _SocialLink;

  const SocialLink._();

  static SocialLink? fromUrl(String url) {
    final updatedUrl =
        url.startsWith('http://') || url.startsWith('https://') ? url : 'https://$url';
    final uri = Uri.tryParse(updatedUrl);
    if (uri == null) return null;
    final host = uri.host.replaceAll(RegExp(r'www\.'), '');
    final site = LinkSite.values.firstWhereOrNull((e) => e.domains.contains(host));

    return site != null ? SocialLink(site: site, url: uri) : null;
  }
}

enum LinkSite {
  mastodon(
    'Mastodon',
    IListConst([
      'mstdn.social',
      'fosstodon.org',
      'gensokyo.social',
      'ravenation.club',
      'mastodon.art',
      'mastodon.lol',
      'mastodon.green',
      'mas.to',
      'mindly.social',
      'mastodon.world',
      'masthead.social',
      'techhub.social',
    ]),
  ),
  twitter('Twitter', IListConst(['twitter.com'])),
  bluesky('Bluesky', IListConst(['bsky.app'])),
  facebook('Facebook', IListConst(['facebook.com'])),
  instagram('Instagram', IListConst(['instagram.com'])),
  youtube('YouTube', IListConst(['youtube.com'])),
  twitch('Twitch', IListConst(['twitch.tv'])),
  github('GitHub', IListConst(['github.com'])),
  gitlab('GitLab', IListConst(['gitlab.com'])),
  vkontakte('VKontakte', IListConst(['vk.com'])),
  chessCom('Chess.com', IListConst(['chess.com'])),
  chess24('Chess24', IListConst(['chess24.com'])),
  chessMonitor('ChessMonitor', IListConst(['chessmonitor.com'])),
  chessTempo('ChessTempo', IListConst(['chesstempo.com']));

  const LinkSite(this.title, this.domains);

  final String title;
  final IList<String> domains;
}
