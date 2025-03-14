import 'package:dartz/dartz.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/classification_constants.dart';
import '../../../core/errors/failure.dart';
import '../../../core/services/translation_service.dart';
import '../../../core/utils/translation_utils.dart';
import '../../entities/message.dart';
import '../../repositories/chat_repository.dart';
import '../../repositories/classifier_repository.dart';
import '../../repositories/translator_repository.dart';
import '../classification/classify_text.dart';
import 'dart:math' as Math;

class SendMessage {
  final ChatRepository chatRepository;
  final ClassifierRepository classifierRepository;
  final TranslatorRepository translatorRepository;
  // Кэш для результатов softmax
  final Map<String, List<double>> _softmaxCache = {};

  SendMessage(
      this.chatRepository,
      this.classifierRepository,
      this.translatorRepository
      );

  Future<Either<Failure, List<Message>>> call(String text) async {
    try {
      // Получаем текущие сообщения
      final messagesResult = await chatRepository.loadChat('current');
      List<Message> currentMessages = [];

      // Проверка на максимальную длину
      if (text.length > AppConstants.maxTextLength) {
        return const Left(ValidationFailure(message: 'Текст сообщения слишком длинный'));
      }

      // Проверка на наличие запрещенных символов или последовательностей
      if (text.contains(RegExp(r'[^\p{L}\p{N}\p{P}\p{Z}]', unicode: true))) {
        return const Left(ValidationFailure(message: 'Текст содержит недопустимые символы'));
      }

      messagesResult.fold(
              (failure) {
            // Если текущего чата нет, начинаем с пустого списка
            currentMessages = [];
          },
              (messages) {
            currentMessages = messages;
          }
      );

      // Добавляем сообщение пользователя
      final userMessage = Message(
        text: text.trim(),
        isUser: true,
        timestamp: DateTime.now(),
      );

      // Переводим текст на английский для классификации
      final translationResult = await translatorRepository.translate(text, 'en');

      final englishText = translationResult.fold(
            (failure) => text, // Если перевод не удался, используем оригинальный текст
            (translatedText) => translatedText,
      );

      // Классифицируем текст
      final classifyText = ClassifyText(classifierRepository);
      final classificationResult = await classifyText(englishText);

      List<List<double>>? classification;
      List<List<double>>? emotionClassification;

      classificationResult.fold(
            (failure) {
          // Если классификация не удалась, оставляем null
          classification = null;
          emotionClassification = null;
        },
            (result) {
          // Правильно извлекаем результаты
          classification = result[0];
          emotionClassification = result[1];
        },
      );

      // Формируем результат классификации в виде текста
      String resultText = Tr.get(TranslationKeys.couldNotClassifyText);

      if (classification != null && emotionClassification != null) {
        resultText = _formatClassificationResult(classification, emotionClassification);
      }

      // Создаем ответное сообщение от бота
      final botMessage = Message(
        text: resultText,
        isUser: false,
        timestamp: DateTime.now(),
        classificationResult: classification,
        classificationEmotionsResult: emotionClassification,
      );

      // Обновляем список сообщений
      final updatedMessages = [...currentMessages, userMessage, botMessage];

      // Сохраняем обновленный список сообщений
      await chatRepository.saveChat('current', updatedMessages);

      return Right(updatedMessages);
    } catch (e) {
      return Left(UnknownFailure(
          message: 'Произошла ошибка при отправке сообщения: $e'
      ));
    }
  }

  String _formatClassificationResult(
      List<List<double>>? classification,
      List<List<double>>? emotionClassification
      ) {
    // Проверяем на null в начале метода
    if (classification == null || emotionClassification == null) {
      return Tr.get(TranslationKeys.couldNotClassifyText);
    }
    // Реализация форматирования результатов классификации

    final results = <String>[];

    // Обрабатываем каждую строку отдельно
    for (int i = 0; i < classification.length; i++) {
      final categoryScores = classification[i];
      final emotionScore = i < emotionClassification.length
          ? emotionClassification[i][0]
          : 0.0;

      // Получаем наиболее вероятную категорию
      final predictedLabel = _getPredictedLabel(categoryScores);

      // Получаем уровень уверенности
      final confidence = _getConfidence(categoryScores);

      // Нормализуем эмоциональную оценку от 0 до 100%
      final emotionPercent = ((emotionScore + 1) / 2 * 100).toStringAsFixed(2);

      results.add(
          "${Tr.get(TranslationKeys.category)}: $predictedLabel\n"
              "${Tr.get(TranslationKeys.confidence)}: ${(confidence * 100).toStringAsFixed(2)}%\n"
              "${Tr.get(TranslationKeys.emotionalTone)}: $emotionPercent%"
      );
    }

    // Соединяем результаты в одну строку, разделяя их пустой строкой
    return results.join('\n\n');
  }

  String _getPredictedLabel(List<double> scores) {
    // Получаем индекс максимального значения
    int maxIndex = 0;
    double maxValue = scores[0];

    for (int i = 1; i < scores.length; i++) {
      if (scores[i] > maxValue) {
        maxValue = scores[i];
        maxIndex = i;
      }
    }

    // Возвращаем соответствующую метку из констант
    if (maxIndex < ClassificationConstants.labels.length) {
      return ClassificationConstants.labels[maxIndex];
    }

    return 'UNKNOWN';
  }

  double _getConfidence(List<double> scores) {
    final normalizedScores = _softmax(scores);
    return normalizedScores.reduce((a, b) => a > b ? a : b);
  }

  List<double> _softmax(List<double> scores) {
    // Создаем ключ для кэша
    final key = scores.map((s) => s.toStringAsFixed(6)).join(':');

    // Проверяем кэш
    if (_softmaxCache.containsKey(key)) {
      return _softmaxCache[key]!;
    }

    // Находим максимальное значение для числовой стабильности
    final maxScore = scores.reduce((a, b) => a > b ? a : b);

    // Вычисляем e^(x - max) для каждого x
    final expScores = scores.map((score) =>
        Math.exp(score - maxScore)).toList();

    // Находим сумму всех e^(x - max)
    final sumExpScores = expScores.reduce((a, b) => a + b);

    // Вычисляем softmax: e^(x - max) / sum(e^(x - max))
    final result = expScores.map((score) => score / sumExpScores).toList();

    // Сохраняем в кэш
    _softmaxCache[key] = result;

    return result;
  }
}