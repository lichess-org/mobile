import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/widgets/emoji_picker/emoji_picker_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flair_provider.g.dart';

@riverpod
Future<EmojiData> flairList(Ref ref) async {
  final list = await ref
      .read(defaultClientProvider)
      .read(Uri.parse(lichessAssetUrl('flair/list.txt')));
  final data = _makeEmojiData(list);
  return EmojiData.fromJson(data);
}

const categories = [
  ['smileys', 'Smileys'],
  ['people', 'People'],
  ['nature', 'Animals & Nature'],
  ['food-drink', 'Food & Drink'],
  ['activity', 'Activity'],
  ['travel-places', 'Travel & Places'],
  ['objects', 'Objects'],
  ['symbols', 'Symbols'],
];

Map<String, dynamic> _makeEmojiData(String list) {
  final lines = list.split('\n').where((line) => line.isNotEmpty);

  Map<String, dynamic> emojiData(String line) {
    final [cat, name] = line.split('.');
    return {
      'id': line,
      'name': name,
      'keywords': [cat, ...name.split('-')],
      'skins': [
        {'src': lichessFlairSrc(line)},
      ],
    };
  }

  final data = {
    'categories':
        categories.map((category) {
          return {
            'id': category[0],
            'name': category[1],
            'emojis': lines.where((line) => line.startsWith(category[0])).toList(),
          };
        }).toList(),
    'emojis': <String, dynamic>{for (final line in lines) line: emojiData(line)},
  };

  return data;
}
