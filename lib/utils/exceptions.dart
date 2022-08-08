class CustomException implements Exception {
  final String _prefix;
  final String _message;

  const CustomException({required prefix, required message})
      : _prefix = prefix,
        _message = message;

  @override
  String toString() => "$_prefix: $_message";
}

class FetchDataException extends CustomException {
  const FetchDataException({required String message})
      : super(
          prefix: "Error During Communication",
          message: message,
        );
}

class BadRequestException extends CustomException {
  const BadRequestException({required String message})
      : super(
          prefix: "Invalid Request",
          message: message,
        );
}

class UnauthorisedException extends CustomException {
  const UnauthorisedException({required String message})
      : super(
          prefix: "Unauthorised",
          message: message,
        );
}

class InvalidInputException extends CustomException {
  const InvalidInputException({required String message})
      : super(
          prefix: "Invalid Input",
          message: message,
        );
}
