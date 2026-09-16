// Generates the practice content embedded in the app, by crawling lichess.org/practice and writing
// a JSON asset.
//
// Practice chapters are stored without their move tree: lila strips it, and the opponent's moves
// and the verdicts come from the local engine. A chapter is a FEN, an orientation, a goal and a
// description. Studies can also mix in gamebook chapters and plain lesson chapters, which do need
// their tree, so those also get their PGN plus the gamebook hints and deviation comments that the
// PGN export leaves out.
//
// No token is needed, every route used here is public:
//
//   dart run scripts/gen_practice.dart
//
// Requests are made one at a time, one per second, as the API guidelines ask. Every response is
// cached under `--cache`, so re-running to change the output format costs no requests at all.
// Delete the cache to refresh the data.

import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final options = _Options.parse(args);
  final lichess = _Lichess(
    host: options.host,
    cacheDir: Directory(options.cacheDir),
    minInterval: Duration(milliseconds: (1000 / options.rps).round()),
  );

  final index = jsonDecode(await lichess.get('/practice', json: true)) as Map<String, dynamic>;
  final sections = (index['sections']! as List<dynamic>).cast<Map<String, dynamic>>();
  final descriptions = _studyDescriptions(await lichess.get('/practice'));

  final kinds = <String, int>{};
  final outSections = <Map<String, dynamic>>[];
  for (final section in sections) {
    final outStudies = <Map<String, dynamic>>[];
    for (final study in (section['studies']! as List<dynamic>).cast<Map<String, dynamic>>()) {
      final studyId = study['id']! as String;
      final pgns = await _studyChapterPgns(lichess, studyId);
      stdout.writeln('${section['id']}/${study['slug']}: ${pgns.length} chapters');

      final outChapters = <Map<String, dynamic>>[];
      for (final MapEntry(key: chapterId, value: pgn) in pgns.entries) {
        final chapter = await _chapter(lichess, studyId, chapterId, pgn);
        kinds.update(chapter['kind']! as String, (count) => count + 1, ifAbsent: () => 1);
        outChapters.add(chapter);
      }
      final description = descriptions[studyId];
      if (description == null) stderr.writeln('No description for study $studyId');
      outStudies.add({
        'id': studyId,
        'slug': study['slug'],
        'name': study['name'],
        'description': ?description,
        'chapters': outChapters,
      });
    }
    outSections.add({'id': section['id'], 'name': section['name'], 'studies': outStudies});
  }

  final out = File(options.out);
  await out.parent.create(recursive: true);
  final content = const JsonEncoder.withIndent(' ').convert({'sections': outSections});
  await out.writeAsString('$content\n');

  final total = kinds.values.fold(0, (sum, count) => sum + count);
  stdout.writeln(
    'Wrote ${options.out}: $total chapters ($kinds), '
    '${(content.length / 1024).toStringAsFixed(1)} KB',
  );
  stdout.writeln('${lichess.fetched} fetched, ${lichess.cacheHits} from cache');
}

/// The short description of each study, by study id, read from the practice page.
///
/// The JSON of `/practice` leaves it out: the page is the only place lila publishes it.
Map<String, String> _studyDescriptions(String html) {
  final study = RegExp(
    '<icon class="([A-Za-z0-9]{8})"></icon><span class="text"><h3>[^<]*</h3><p>([^<]*)</p>',
  );
  return {
    for (final match in study.allMatches(html)) match.group(1)!: _unescapeHtml(match.group(2)!),
  };
}

/// [pgn] without the `[%anno "Name", username]` lila writes at the start of a comment to credit
/// its author, which no PGN reader knows and which would otherwise show up in the comment text.
String _withoutAuthorAnnotations(String pgn) => pgn.replaceAll(RegExp(r'\[%anno [^\]]*\]\s*'), '');

String _unescapeHtml(String text) => text
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&quot;', '"')
    .replaceAll('&#39;', "'")
    .replaceAll('&#x27;', "'")
    .replaceAll('&amp;', '&');

/// The PGN of every chapter of [studyId], keyed by chapter id, in chapter order.
///
/// The index gives no chapter ids, and the study export is the one request that lists them all.
Future<Map<String, String>> _studyChapterPgns(_Lichess lichess, String studyId) async {
  final pgn = await lichess.get('/api/study/$studyId.pgn');
  final chapterUrl = RegExp(r'\[ChapterURL "[^"]*/([A-Za-z0-9]{8})"\]');
  return {
    for (final game in pgn.trim().split(RegExp(r'\n\s*\n(?=\[Event )')))
      chapterUrl.firstMatch(game)!.group(1)!: _withoutAuthorAnnotations(game.trim()),
  };
}

Future<Map<String, dynamic>> _chapter(
  _Lichess lichess,
  String studyId,
  String chapterId,
  String pgn,
) async {
  final load = await _load(lichess, studyId, chapterId);
  final study = load['study']! as Map<String, dynamic>;
  final chapter = study['chapter']! as Map<String, dynamic>;
  final analysis = load['analysis']! as Map<String, dynamic>;
  final treeParts = (analysis['treeParts']! as List<dynamic>).cast<Map<String, dynamic>>();
  final setup = chapter['setup']! as Map<String, dynamic>;

  final variant = (setup['variant']! as Map<String, dynamic>)['key'];
  if (variant != 'standard' && variant != 'fromPosition') {
    throw StateError('Chapter $studyId/$chapterId is not standard chess: $variant');
  }

  // `practice` wins over `gamebook`: lila strips the tree of a practice chapter, so there would be
  // no gamebook left to play.
  final kind = chapter['practice'] == true
      ? 'practice'
      : chapter['gamebook'] == true
      ? 'gamebook'
      : 'lesson';

  final result = <String, dynamic>{
    'id': chapterId,
    'name': chapter['name'],
    'kind': kind,
    'orientation': setup['orientation'],
    'fen': treeParts.first['fen'],
    if (chapter['description'] case final String description when description.isNotEmpty)
      'description': description,
  };

  if (kind == 'practice') {
    result['goal'] = analysis['practiceGoal'];
    return result;
  }

  // The tree is rebuilt from the PGN, like a study chapter. Hints and deviation comments are
  // gamebook-only and absent from the PGN export; they are indexed by ply along the mainline,
  // which is what `treeParts` lists.
  result['pgn'] = pgn;
  if (kind == 'gamebook') {
    String? gamebook(Map<String, dynamic> part, String key) =>
        (part['gamebook'] as Map<String, dynamic>?)?[key] as String?;
    final hints = treeParts.map((part) => gamebook(part, 'hint')).toList();
    final deviations = treeParts.map((part) => gamebook(part, 'deviation')).toList();
    if (hints.any((hint) => hint != null)) result['hints'] = hints;
    if (deviations.any((deviation) => deviation != null)) result['deviations'] = deviations;
  }
  return result;
}

Future<Map<String, dynamic>> _load(_Lichess lichess, String studyId, String chapterId) async =>
    jsonDecode(await lichess.get('/practice/load/$studyId/$chapterId')) as Map<String, dynamic>;

// ---------------------------------------------------------------------------------------------
// Lichess
// ---------------------------------------------------------------------------------------------

/// Lichess, one request at a time, rate limited and cached on disk.
class _Lichess({
  required final String host,
  required final Directory cacheDir,
  required final Duration minInterval,
}) {
  final _client = HttpClient();
  DateTime _lastRequest = DateTime.fromMillisecondsSinceEpoch(0);

  int fetched = 0;
  int cacheHits = 0;

  Future<String> get(String path, {bool json = false}) async {
    final cached = _cacheFile(path, json: json);
    if (cached.existsSync()) {
      cacheHits++;
      return cached.readAsStringSync();
    }

    final wait = minInterval - DateTime.now().difference(_lastRequest);
    if (wait > Duration.zero) await Future<void>.delayed(wait);
    _lastRequest = DateTime.now();

    final body = await _fetch(Uri.https(host, path), json: json);
    cached.parent.createSync(recursive: true);
    cached.writeAsStringSync(body);
    fetched++;
    return body;
  }

  /// Fetches [uri], backing off on the rate limiter rather than giving up on the crawl.
  Future<String> _fetch(Uri uri, {required bool json}) async {
    for (var attempt = 0; ; attempt++) {
      final request = await _client.getUrl(uri);
      if (json) request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) return body;
      if (response.statusCode != 429 || attempt >= 5) {
        throw HttpException('${response.statusCode} for $uri: $body');
      }
      final backoff = Duration(seconds: 60 * (attempt + 1));
      stderr.writeln('rate limited, waiting ${backoff.inSeconds}s');
      await Future<void>.delayed(backoff);
    }
  }

  File _cacheFile(String path, {required bool json}) {
    final name = path.replaceAll(RegExp('[^a-zA-Z0-9.]'), '_');
    return File('${cacheDir.path}/$host/$name${json ? '.json' : ''}');
  }
}

// ---------------------------------------------------------------------------------------------
// Options
// ---------------------------------------------------------------------------------------------

class const _Options({
  required final String out,
  required final String cacheDir,
  required final String host,

  /// Requests per second.
  required final double rps,
}) {
  factory parse(List<String> args) {
    final values = <String, String>{};
    for (final arg in args) {
      final separator = arg.indexOf('=');
      if (!arg.startsWith('--') || separator < 0) {
        stderr.writeln('Unknown argument: $arg');
        exit(2);
      }
      values[arg.substring(2, separator)] = arg.substring(separator + 1);
    }
    return _Options(
      out: values['out'] ?? 'assets/practice.json',
      cacheDir: values['cache'] ?? '.cache/practice',
      host: values['host'] ?? 'lichess.org',
      rps: double.parse(values['rps'] ?? '1'),
    );
  }
}
