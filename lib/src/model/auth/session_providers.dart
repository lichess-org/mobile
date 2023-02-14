import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'session_repository.dart';
import 'user_session.dart';

part 'session_providers.g.dart';

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(SessionRepositoryRef ref) {
  return const SessionRepository(FlutterSecureStorage());
}

@Riverpod(keepAlive: true)
Future<UserSession?> session(SessionRef ref) {
  final repo = ref.watch(sessionRepositoryProvider);
  return repo.read();
}
