// login exceptions
class UserNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

// register exceptions
class WeekPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class InvalidEmailException implements Exception {}

// generic exceptions(Authentication related errors that don't fall under the specific categories)
class GenericAuthException implements Exception {}

class UserNotLoggedInException implements Exception {}
