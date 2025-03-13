import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/logger/app_logger.dart';

abstract class ClassifierDataSource {
  /// Выполняет классификацию текста с помощью внешнего API
  Future<List<List<double>>> classifyText(String text);
}

class ClassifierDataSourceImpl implements ClassifierDataSource {
  final http.Client httpClient;

  ClassifierDataSourceImpl({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  @override
  Future<List<List<double>>> classifyText(String text) async {
    try {
      if (text.trim().isEmpty) {
        return [[0.0], [0.0]]; // Возвращаем дефолтное значение для пустого текста
      }

      final url = Uri.parse(AppConstants.classifierEndpoint);

      final response = await httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw NetworkException('Тайм-аут запроса классификации'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (!data.containsKey('output') || !data.containsKey('outputEmotions')) {
          throw FormatException('Неверный формат ответа API');
        }

        final output = (data['output'][0] as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList();

        final outputEmotions = [(data['outputEmotions'][0] as num).toDouble()];

        AppLogger.debug('Классификация успешно выполнена');
        return [output, outputEmotions];
      } else {
        AppLogger.error('Ошибка API классификации: ${response.statusCode}');
        throw ServerException(
          'Ошибка API классификации',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is FormatException) {
        rethrow;
      }

      AppLogger.error('Ошибка во время классификации текста', e);
      throw NetworkException('Не удалось выполнить классификацию: $e');
    }
  }
}