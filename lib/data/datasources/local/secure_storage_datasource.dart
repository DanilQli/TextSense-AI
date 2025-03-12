import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/logger/app_logger.dart';

abstract class SecureStorageDataSource {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<bool> containsKey(String key);
  Future<void> deleteAll();
  Future<Map<String, String>> readAll();
}

class SecureStorageDataSourceImpl implements SecureStorageDataSource {
  final FlutterSecureStorage _storage;

  SecureStorageDataSourceImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      AppLogger.error('Ошибка при чтении из защищенного хранилища', e);
      throw CacheException('Не удалось прочитать данные: $e');
    }
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      AppLogger.error('Ошибка при записи в защищенное хранилище', e);
      throw CacheException('Не удалось записать данные: $e');
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      AppLogger.error('Ошибка при удалении из защищенного хранилища', e);
      throw CacheException('Не удалось удалить данные: $e');
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      AppLogger.error('Ошибка при проверке ключа в защищенном хранилище', e);
      throw CacheException('Не удалось проверить наличие ключа: $e');
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      AppLogger.error('Ошибка при очистке защищенного хранилища', e);
      throw CacheException('Не удалось очистить хранилище: $e');
    }
  }

  @override
  Future<Map<String, String>> readAll() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      AppLogger.error('Ошибка при чтении всех данных из защищенного хранилища', e);
      throw CacheException('Не удалось прочитать все данные: $e');
    }
  }
}