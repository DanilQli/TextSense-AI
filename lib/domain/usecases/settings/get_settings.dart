import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../entities/user_settings.dart';
import '../../repositories/settings_repository.dart';

class GetSettings {
  final SettingsRepository repository;

  GetSettings(this.repository);

  Future<Either<Failure, UserSettings>> call() async {
    try {
      return repository.getSettings();
    } catch (e) {
      return Left(UnknownFailure(
          message: 'Произошла ошибка при получении настроек: $e'
      ));
    }
  }
}