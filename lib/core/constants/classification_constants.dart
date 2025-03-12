class ClassificationConstants {
  static const List<String> labels = [
    'ARTS & CULTURE',
    'BUSINESS & FINANCES',
    'COMEDY',
    'CRIME',
    'DIVORCE',
    'EDUCATION',
    'ENTERTAINMENT',
    'ENVIRONMENT',
    'FOOD & DRINK',
    'GROUPS VOICES',
    'HOME & LIVING',
    'IMPACT',
    'MEDIA',
    'OTHER',
    'PARENTING',
    'POLITICS',
    'RELIGION',
    'SCIENCE & TECH',
    'SPORTS',
    'STYLE & BEAUTY',
    'TRAVEL',
    'U.S. NEWS',
    'WEDDINGS',
    'WEIRD NEWS',
    'WELLNESS',
    'WOMEN',
    'WORLD NEWS'
  ];

  static const double highConfidenceThreshold = 0.8;
  static const double mediumConfidenceThreshold = 0.5;

  // Приватный конструктор для предотвращения инстанцирования
  ClassificationConstants._();
}