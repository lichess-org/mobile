abstract class IOError {
  String get message;
  StackTrace get stackTrace;
}

class GenericError implements IOError {
  @override
  final StackTrace stackTrace;

  GenericError(this.stackTrace);

  @override
  String get message => "The operation could not be completed. Please try again later.";
}

/// Generic error for API requests.
class ApiRequestError implements IOError {
  @override
  final StackTrace stackTrace;

  ApiRequestError(this.stackTrace);

  @override
  String get message => "Something went wrong with the request. Please try again later.";
}

class NotFoundError implements IOError {
  @override
  final StackTrace stackTrace;

  NotFoundError(this.stackTrace);

  @override
  String get message => "Requested resource could not be found.";
}

class UnauthorizedError implements IOError {
  @override
  final StackTrace stackTrace;

  UnauthorizedError(this.stackTrace);

  @override
  String get message => "You must sign in to access this resource.";
}

class ForbiddenError implements IOError {
  @override
  final StackTrace stackTrace;

  ForbiddenError(this.stackTrace);

  @override
  String get message => "Requested resource access is forbidden.";
}
