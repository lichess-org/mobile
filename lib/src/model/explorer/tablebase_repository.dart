import 'dart:async';

import 'package:http/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/explorer/tablebase.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tablebase_repository.g.dart';

@riverpod
class Tablebase extends _$Tablebase {
  @override
  Future<TablebaseEntry?> build({required String fen}) async {
    await ref.debounce(const Duration(milliseconds: 300));

    final client = ref.read(defaultClientProvider);

    final tablebaseEntry = await TablebaseRepository(client).getTablebaseEntry(fen);
    return tablebaseEntry;
  }
}

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
