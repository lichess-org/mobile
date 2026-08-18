import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/chess.dart' show Variant;
import 'package:lichess_mobile/src/model/explorer/tablebase.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';

/// A provider for fetching tablebase entries.
final tablebaseProvider = FutureProvider.autoDispose
    .family<TablebaseEntry?, ({String fen, Variant variant})>((ref, request) async {
      await ref.debounce(const Duration(milliseconds: 300));

      final tablebaseEntry = await ref
          .read(tablebaseRepositoryProvider)
          .getTablebaseEntry(request.fen, request.variant);
      return tablebaseEntry;
    }, name: 'TablebaseProvider');

final tablebaseRepositoryProvider = Provider<TablebaseRepository>((ref) {
  final client = ref.watch(lichessClientProvider);
  return TablebaseRepository(client);
}, name: 'TablebaseRepositoryProvider');

class TablebaseRepository {
  const TablebaseRepository(this.client);

  final Client client;

  Future<TablebaseEntry> getTablebaseEntry(String fen, Variant variant) {
    return client.readJson(
      Uri.https(kLichessTablebaseHost, _tablebasePath(variant), {'source': 'mobile', 'fen': fen}),
      mapper: TablebaseEntry.fromJson,
    );
  }
}

String _tablebasePath(Variant variant) {
  // Standard, imported positions, and Chess960 all use the standard tablebase
  // endpoint; only variants with dedicated tablebases get their own path.
  return switch (variant) {
    Variant.standard || Variant.fromPosition || Variant.chess960 => '/standard',
    Variant.atomic => '/atomic',
    Variant.antichess => '/antichess',
    _ => throw ArgumentError.value(variant, 'variant', 'Unsupported tablebase variant.'),
  };
}
