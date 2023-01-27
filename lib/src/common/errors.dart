abstract class IOException implements Exception {
  String get message;

  @override
  String toString() => message;
}

class GenericException implements IOException {
  @override
  String get message =>
      'The operation could not be completed. Please try again later.';
}

/// Exception when json returned by server is not valid.
class DataFormatException implements IOException {
  @override
  String get message => 'Could not read data from server.';
}

/// Generic error for API requests.
class ApiRequestException implements IOException {
  @override
  String get message =>
      'Something went wrong with the request. Please try again later.';
}

class NotFoundException implements IOException {
  @override
  String get message => 'Requested resource could not be found.';
}

class UnauthorizedException implements IOException {
  @override
  String get message => 'You must sign in to access this resource.';
}

class ForbiddenException implements IOException {
  @override
  String get message => 'Requested resource access is forbidden.';
}
