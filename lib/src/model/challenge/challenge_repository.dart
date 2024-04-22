import 'package:http/http.dart' as http;

import './challenge_request.dart';

class ChallengeRepository {
  const ChallengeRepository(this.client);

  final http.Client client;

  Future<void> challenge(String username, ChallengeRequest req) async {
    final uri = Uri(path: '/api/challenge/$username');
    final response = await client.post(uri, body: req.toRequestBody);

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Failed to challenge user: ${response.statusCode}',
        uri,
      );
    }
  }

  Future<void> challengeAI(AiChallengeRequest req) async {
    final uri = Uri(path: '/api/challenge/ai');
    final response = await client.post(uri, body: req.toRequestBody);

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Failed to challenge AI: ${response.statusCode}',
        uri,
      );
    }
  }
}
