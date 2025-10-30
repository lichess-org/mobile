import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'openings_database.g.dart';

// The dataset is from https://github.com/lichess-org/chess-openings
// and was simply imported in sqlite with:
//   sqlite> .mode tabs
//   sqlite> .import a.tsv openings
//   sqlite> .import b.tsv openings
//   sqlite> .import c.tsv openings
//   sqlite> .import d.tsv openings
//   sqlite> .import e.tsv openings

const _kDatabaseVersion = 2;
const _kDatabaseName = 'chess_openings$_kDatabaseVersion.db';

@Riverpod(keepAlive: true)
Future<Database> openingsDatabase(Ref ref) async {
  final dbPath = p.join(await getDatabasesPath(), _kDatabaseName);
  return _openDb(dbPath);
}

Future<Database> _openDb(String path) async {
  final exists = await databaseExists(path);

  if (!exists) {
    final directory = Directory(p.dirname(path));

    // Make sure the parent directory exists
    try {
      await directory.create(recursive: true);
    } catch (_) {}

    // Delete existing previous if any
    directory.list().forEach((file) {
      if (file.path.startsWith('chess_openings')) {
        deleteDatabase(file.path);
      }
    });

    // Copy from asset
    final ByteData data = await rootBundle.load(p.url.join('assets', 'chess_openings.db'));
    final List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(path).writeAsBytes(bytes, flush: true);
  }

  return databaseFactory.openDatabase(path, options: OpenDatabaseOptions(readOnly: true));
}
