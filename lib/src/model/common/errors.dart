abstract class IOException implements Exception {
  const IOException();

  String get message;

  @override
  String toString() => message;
}

class GenericIOException extends IOException {
  @override
  String get message =>
      'The operation could not be completed. Please try again later.';
}

/// Exception when json returned by server is not valid.
class DataFormatException extends IOException {
  @override
  String get message => 'Could not read data from server.';
}

/// Generic error for API requests.
class ApiRequestException extends IOException {
  const ApiRequestException(this.errorCode, this.errorMessage);

  final int errorCode;
  final String errorMessage;

  @override
  String get message => '$errorMessage ($errorCode)';
}

class NotFoundException extends IOException {
  @override
  String get message => 'Requested resource could not be found.';
}

class UnauthorizedException extends IOException {
  @override
  String get message => 'You must sign in to access this resource.';
}

class ForbiddenException extends IOException {
  @override
  String get message => 'Requested resource access is forbidden.';
}
