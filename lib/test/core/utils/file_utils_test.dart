import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:io';
import 'package:coursework/core/utils/file_utils.dart';
import 'package:coursework/core/errors/app_exception.dart';


// Создаем мок для директории
class MockDirectory extends Mock implements Directory {
  @override
  String get path => '/mock/directory';
}

void main() {
  group('FileUtils', () {
    test('isValidFileName должен возвращать true для валидных имен файлов', () {
      expect(FileUtils.isValidFileName('valid_file_name'), isTrue);
      expect(FileUtils.isValidFileName('ValidFileName123'), isTrue);
      expect(FileUtils.isValidFileName('valid file name'), isTrue);
      expect(FileUtils.isValidFileName('имя-файла'), isTrue);
    });

    test('isValidFileName должен возвращать false для невалидных имен файлов', () {
      expect(FileUtils.isValidFileName(''), isFalse);
      expect(FileUtils.isValidFileName('file/name'), isFalse);
      expect(FileUtils.isValidFileName('file\\name'), isFalse);
      expect(FileUtils.isValidFileName('file:name'), isFalse);
      expect(FileUtils.isValidFileName('file*name'), isFalse);
      expect(FileUtils.isValidFileName('file?name'), isFalse);
      expect(FileUtils.isValidFileName('file"name'), isFalse);
      expect(FileUtils.isValidFileName('file<name'), isFalse);
      expect(FileUtils.isValidFileName('file>name'), isFalse);
      expect(FileUtils.isValidFileName('file|name'), isFalse);
      expect(FileUtils.isValidFileName('..'), isFalse);
    });

    test('getUniqueFileName должен добавлять числовой суффикс, если файл существует', () async {
      // Здесь тестирование getUniqueFileName с мокированием файловой системы
    });

    test('getSafePath должен выбрасывать SecurityException для невалидных имен файлов', () async {
      expect(() => FileUtils.getSafePath('file/name'), throwsA(isA<SecurityException>()));
    });

    test('saveDataToFile и loadDataFromFile должны сохранять и загружать данные', () async {
      // Здесь тестирование сохранения и загрузки с мокированием файловой системы
    });
  });
}