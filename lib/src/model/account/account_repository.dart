import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/json.dart';

class AccountRepository {
  const AccountRepository({
    required ApiClient apiClient,
    required Logger logger,
  })  : _apiClient = apiClient,
        _log = logger;

  final ApiClient _apiClient;
  final Logger _log;

  FutureResult<User> getProfile() {
    return _apiClient.get(Uri.parse('$kLichessHost/api/account')).then(
          (result) => result.flatMap(
            (response) => readJsonObject(
              response.body,
              mapper: User.fromJson,
              logger: _log,
            ),
          ),
        );
  }
}
