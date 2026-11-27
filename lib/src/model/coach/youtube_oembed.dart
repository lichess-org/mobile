import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/network/http.dart';

/// Fetches the title of a YouTube video through the public oEmbed API.
///
/// Returns null when the API cannot be reached or the video doesn't exist; the
/// thumbnail is then shown without an overlay.
final youtubeVideoTitleProvider = FutureProvider.autoDispose.family<String?, String>((
  ref,
  url,
) async {
  final client = ref.read(defaultClientProvider);
  try {
    final response = await client.get(
      Uri.https('www.youtube.com', '/oembed', {'url': url, 'format': 'json'}),
    );
    if (response.statusCode != 200) return null;
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    return json is Map<String, dynamic> ? json['title'] as String? : null;
  } catch (_) {
    return null;
  }
}, name: 'YoutubeVideoTitleProvider');
