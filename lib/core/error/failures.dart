import 'package:equatable/equatable.dart';

/// Base class for all Failuress
abstract class Failures extends Equatable {
  final String message;

  const Failures(this.message);

  @override
  List<Object?> get props => [message];
}

/// 401: Unauthorized
class UnauthorizedFailure extends Failures {
  const UnauthorizedFailure(super.message);
}

/// 4xx: Client-side error
class ClientFailure extends Failures {
  const ClientFailure(super.message);
}

/// 5xx: Server-side error
class ServerFailure extends Failures {
  const ServerFailure(super.message);
}

/// Network-related error (e.g. SocketException)
class NetworkFailure extends Failures {
  const NetworkFailure(super.message);
}

/// Timeout
class TimeoutFailure extends Failures {
  const TimeoutFailure(super.message);
}

/// Anything unexpected
class UnexpectedFailure extends Failures {
  const UnexpectedFailure(super.message);
}
