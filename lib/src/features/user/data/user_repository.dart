import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import '../model/user.dart';

class UserRepository {
  const UserRepository({
    required this.apiClient,
  });

  final ApiClient apiClient;

  TaskEither<IOError, User> getUser(String username) {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/user/$username'))
        .map((response) => User.fromJson(jsonDecode(response.body)));
  }

  TaskEither<IOError, List<UserStatus>> getUsersStatus(List<String> ids) {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/users/status?ids=${ids.join(',')}'))
        .map((response) => jsonDecode(response.body)
            .map<UserStatus>((e) => UserStatus.fromJson(e))
            .toList());
  }

  void dispose() {
    apiClient.close();
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo = UserRepository(apiClient: apiClient);
  ref.onDispose(() => repo.dispose());
  return repo;
});
