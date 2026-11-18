import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

typedef YoutubeChannelInfo = ({
  String? title,
  String? avatarUrl,
  String? subscriberText,
  String? videoCountText,
});

typedef YoutubeChannelParams = ({String url, String languageCode});

final youtubeScrapeClientProvider = Provider<Client>((ref) {
  final client = IOClient(
    HttpClient()..userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36',
  );
  ref.onDispose(client.close);
  return client;
}, name: 'YoutubeScrapeClientProvider');

final youtubeChannelInfoProvider = FutureProvider.autoDispose
    .family<YoutubeChannelInfo?, YoutubeChannelParams>((ref, params) async {
      final uri = Uri.parse(params.url);
      final client = ref.read(youtubeScrapeClientProvider);
      try {
        final response = await client
            .get(
              uri.replace(queryParameters: {...uri.queryParameters, 'hl': params.languageCode}),
              headers: {
                'Accept-Language': params.languageCode,
                'Cookie': 'CONSENT=YES+cb; SOCS=CAI',
              },
            )
            .timeout(const Duration(seconds: 10));
        if (response.statusCode != 200) return null;
        return parseYoutubeChannelPage(utf8.decode(response.bodyBytes));
      } catch (_) {
        return null;
      }
    }, name: 'YoutubeChannelInfoProvider');

YoutubeChannelInfo? parseYoutubeChannelPage(String html) {
  final title =
      RegExp('"channelMetadataRenderer":\\{"title":"([^"]+)"').firstMatch(html)?[1] ??
      RegExp('property="og:title" content="([^"]+)"').firstMatch(html)?[1];
  final avatar = RegExp('"avatar":\\{"thumbnails":\\[\\{"url":"([^"]+)"').firstMatch(html)?[1];
  final headerParts = RegExp(
    '"metadataParts":\\[\\{"text":\\{"content":"([^"]+)"\\},"accessibilityLabel":"[^"]*"\\},\\{"text":\\{"content":"([^"]+)"',
  ).firstMatch(html);
  final subscribers =
      headerParts?[1] ??
      RegExp('"subscriberCountText":\\{.*?"simpleText":"([^"]+)"').firstMatch(html)?[1];
  final videoCount =
      headerParts?[2] ??
      RegExp('"videosCountText":\\{.*?"simpleText":"([^"]+)"').firstMatch(html)?[1];
  if (title == null && subscribers == null && videoCount == null) return null;
  return (
    title: title != null ? _unescape(title) : null,
    avatarUrl: avatar != null ? _unescape(avatar) : null,
    subscriberText: subscribers != null ? _unescape(subscribers) : null,
    videoCountText: videoCount != null ? _unescape(videoCount) : null,
  );
}

String _unescape(String value) {
  return value.replaceAll(r'\/', '/').replaceAll(r'\u0026', '&').replaceAll(r'\u00a0', ' ');
}
