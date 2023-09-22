import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

part 'openings_database.g.dart';

// The dataset is from https://github.com/lichess-org/chess-openings
// and was simply imported in sqlite with:
//   sqlite> .mode tabs
//   sqlite> .import a.tsv openings
//   sqlite> .import b.tsv openings
//   sqlite> .import c.tsv openings
//   sqlite> .import d.tsv openings
//   sqlite> .import e.tsv openings

const _kDatabaseName = 'chess_openings.db';

@Riverpod(keepAlive: true)
Future<Database> openingsDatabase(OpeningsDatabaseRef ref) async {
  final dbPath = p.join(await getDatabasesPath(), _kDatabaseName);
  return openDb(dbPath);
}

Future<Database> openDb(String path) async {
  final exists = await databaseExists(path);

  if (!exists) {
    // Make sure the parent directory exists
    try {
      await Directory(p.dirname(path)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    final ByteData data =
        await rootBundle.load(p.url.join('assets', _kDatabaseName));
    final List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(path).writeAsBytes(bytes, flush: true);
  }

  return openDatabase(path, readOnly: true);
}
