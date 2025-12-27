import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/explorer/tablebase.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';

/// A provider for fetching tablebase entries.
final tablebaseProvider = FutureProvider.autoDispose.family<TablebaseEntry?, String>((
  ref,
  fen,
) async {
  await ref.debounce(const Duration(milliseconds: 300));

  final client = ref.read(defaultClientProvider);

  final tablebaseEntry = await TablebaseRepository(client).getTablebaseEntry(fen);
  return tablebaseEntry;
}, name: 'TablebaseProvider');

class TablebaseRepository {
  const TablebaseRepository(this.client);

  final Client client;

  Future<TablebaseEntry> getTablebaseEntry(String fen) {
    return client.readJson(
      Uri.https(kLichessTablebaseHost, '/standard', {'fen': fen}),
      mapper: TablebaseEntry.fromJson,
    );
  }
}
