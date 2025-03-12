import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({required String message, int? code})
      : super(message: message, code: code);
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message})
      : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({required String message})
      : super(message: message);
}

class FileOperationFailure extends Failure {
  const FileOperationFailure({required String message})
      : super(message: message);
}

class ValidationFailure extends Failure {
  const ValidationFailure({required String message})
      : super(message: message);
}

class ClassificationFailure extends Failure {
  const ClassificationFailure({required String message})
      : super(message: message);
}

class TranslationFailure extends Failure {
  const TranslationFailure({required String message})
      : super(message: message);
}

class PermissionFailure extends Failure {
  const PermissionFailure({required String message})
      : super(message: message);
}

class UnknownFailure extends Failure {
  const UnknownFailure({required String message})
      : super(message: message);
}