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
