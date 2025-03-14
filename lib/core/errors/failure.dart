import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class FileOperationFailure extends Failure {
  const FileOperationFailure({required super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class ClassificationFailure extends Failure {
  const ClassificationFailure({required super.message});
}

class TranslationFailure extends Failure {
  const TranslationFailure({required super.message});
}

class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}