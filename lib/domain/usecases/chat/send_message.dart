import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import '../../entities/message.dart';
import '../../repositories/chat_repository.dart';
import '../../repositories/classifier_repository.dart';
import '../../repositories/translator_repository.dart';
import '../classification/classify_text.dart';
// Импорт для экспоненты
import 'dart:math' as Math;

class SendMessage {
  final ChatRepository chatRepository;
  final ClassifierRepository classifierRepository;
  final TranslatorRepository translatorRepository;

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
            classification = result[0].cast<List<double>>();
            emotionClassification = result[1].cast<List<double>>();
          }
      );

      // Формируем результат классификации в виде текста
      String resultText = 'Не удалось классифицировать текст';

      if (classification != null && emotionClassification != null) {
        resultText = _formatClassificationResult(classification!, emotionClassification!);
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
      List<List<double>> classification,
      List<List<double>> emotionClassification
      ) {
    // Реализация форматирования результатов классификации
    // Это упрощенная версия, в реальном приложении нужно учитывать локализацию

    final results = <String>[];

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
          "Категория: $predictedLabel\n"
              "Уверенность: ${(confidence * 100).toStringAsFixed(2)}%\n"
              "Эмоциональная окраска: $emotionPercent%"
      );
    }

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

    // Возвращаем соответствующую метку
    final labels = [
      'ARTS & CULTURE', 'BUSINESS & FINANCES', 'COMEDY', 'CRIME',
      'DIVORCE', 'EDUCATION', 'ENTERTAINMENT', 'ENVIRONMENT',
      'FOOD & DRINK', 'GROUPS VOICES', 'HOME & LIVING', 'IMPACT',
      'MEDIA', 'OTHER', 'PARENTING', 'POLITICS', 'RELIGION',
      'SCIENCE & TECH', 'SPORTS', 'STYLE & BEAUTY', 'TRAVEL',
      'U.S. NEWS', 'WEDDINGS', 'WEIRD NEWS', 'WELLNESS',
      'WOMEN', 'WORLD NEWS'
    ];

    if (maxIndex < labels.length) {
      return labels[maxIndex];
    }

    return 'UNKNOWN';
  }

  double _getConfidence(List<double> scores) {
    final normalizedScores = _softmax(scores);
    return normalizedScores.reduce((a, b) => a > b ? a : b);
  }

  List<double> _softmax(List<double> scores) {
    // Находим максимальное значение для числовой стабильности
    final maxScore = scores.reduce((a, b) => a > b ? a : b);

    // Вычисляем e^(x - max) для каждого x
    final expScores = scores.map((score) =>
        Math.exp(score - maxScore)).toList();

    // Находим сумму всех e^(x - max)
    final sumExpScores = expScores.reduce((a, b) => a + b);

    // Вычисляем softmax: e^(x - max) / sum(e^(x - max))
    return expScores.map((score) => score / sumExpScores).toList();
  }
}