lib/
├── main.dart                # Точка входа приложения
├── app.dart                 # Корневой виджет с провайдерами
│
├── config/                  # Конфигурации приложения
│   ├── routes.dart          # Маршруты навигации
│   ├── dependency_injection.dart # Настройка инъекции зависимостей
│   └── app_config.dart      # Общие настройки приложения
│
├── core/                    # Базовые компоненты
│   ├── constants/           # Константы приложения
│   │   ├── app_constants.dart
│   │   └── classification_constants.dart
│   │
│   ├── errors/              # Обработка ошибок
│   │   ├── app_exception.dart       # Исключения приложения
│   │   ├── failure.dart             # Классы ошибок для Either
│   │   └── error_handler.dart       # Обработчик ошибок
│   │
│   ├── services/            # Общие сервисы
│   │   └── translation_service.dart # Сервис для работы с переводами
│   │
│   ├── utils/               # Утилиты
│   │   ├── file_utils.dart          # Безопасные операции с файлами
│   │   ├── string_utils.dart        # Утилиты для работы со строками  
│   │   ├── datetime_utils.dart      # Утилиты для работы с датами
│   │   └── math_utils.dart          # Математические функции
│   │
│   └── logger/              # Система логирования
│       ├── app_logger.dart          # Интерфейс и реализация логирования
│       └── log_level.dart           # Определение уровней логирования
│
├── data/                    # Слой данных
│   ├── datasources/         # Источники данных
│   │   ├── device/
│   │   │   └── speech_datasource.dart      # Доступ к распознаванию речи
│   │   │
│   │   ├── local/
│   │   │   ├── chat_local_datasource.dart  # Локальное хранение чатов
│   │   │   ├── preferences_datasource.dart # Настройки (тема, язык)
│   │   │   └── secure_storage_datasource.dart # Защищенное хранилище
│   │   │
│   │   └── remote/
│   │       ├── classifier_datasource.dart  # API классификатора
│   │       └── translator_datasource.dart  # API перевода
│   │
│   ├── models/              # Модели данных
│   │   ├── message_model.dart        # Модель сообщения
│   │   └── chat_model.dart           # Модель чата
│   │
│   └── repositories/        # Реализации репозиториев
│       ├── chat_repository_impl.dart        # Реализация репозитория чатов
│       ├── settings_repository_impl.dart    # Реализация репозитория настроек
│       ├── classifier_repository_impl.dart  # Реализация репозитория классификатора
│       ├── translator_repository_impl.dart  # Реализация репозитория переводчика
│       └── speech_repository_impl.dart      # Реализация репозитория речи
│
├── domain/                  # Бизнес-логика
│   ├── entities/            # Бизнес-объекты
│   │   ├── message.dart               # Сущность сообщения
│   │   ├── chat.dart                  # Сущность чата
│   │   ├── classification_result.dart # Результат классификации
│   │   └── user_settings.dart         # Пользовательские настройки
│   │
│   ├── repositories/        # Интерфейсы репозиториев
│   │   ├── chat_repository.dart       # Интерфейс репозитория чатов
│   │   ├── settings_repository.dart   # Интерфейс репозитория настроек
│   │   ├── classifier_repository.dart # Интерфейс репозитория классификатора
│   │   ├── translator_repository.dart # Интерфейс репозитория переводчика
│   │   └── speech_repository.dart     # Интерфейс репозитория речи
│   │
│   └── usecases/            # Сценарии использования
│       ├── chat/
│       │   ├── send_message.dart        # Отправка сообщения
│       │   ├── get_message_history.dart # Получение истории
│       │   ├── save_chat.dart           # Сохранение чата
│       │   ├── delete_chat.dart         # Удаление чата
│       │   └── export_chat.dart         # Экспорт чата
│       │
│       ├── settings/
│       │   ├── get_settings.dart        # Получение настроек
│       │   ├── toggle_theme.dart        # Переключение темы
│       │   └── change_language.dart     # Изменение языка
│       │
│       ├── classification/
│       │   └── classify_text.dart       # Классификация текста
│       │
│       ├── translation/
│       │   └── translate_text.dart      # Перевод текста
│       │
│       └── speech/
│           └── listen_to_speech.dart    # Прослушивание речи
│
└── presentation/           # Пользовательский интерфейс
    ├── bloc/               # BLoC компоненты
    │   ├── chat/
    │   │   ├── chat_bloc.dart           # BLoC для чата
    │   │   ├── chat_event.dart          # События чата
    │   │   └── chat_state.dart          # Состояния чата
    │   │
    │   ├── theme/          # Отдельный блок для темы
    │   │   ├── theme_bloc.dart          # BLoC для темы
    │   │   ├── theme_event.dart         # События темы
    │   │   └── theme_state.dart         # Состояния темы
    │   │
    │   └── language/       # Отдельный блок для языка
    │       ├── language_bloc.dart       # BLoC для языка
    │       ├── language_event.dart      # События языка
    │       └── language_state.dart      # Состояния языка
    │
    ├── screens/            # Экраны приложения
    │   ├── chat_screen.dart             # Экран чата
    │   ├── settings_screen.dart         # Экран настроек
    │   └── chat_list_screen.dart        # Экран списка чатов
    │
    └── widgets/            # Переиспользуемые виджеты
        ├── message_bubble.dart          # Виджет сообщения
        ├── message_actions_menu.dart    # Меню действий с сообщением
        ├── chat_input.dart              # Ввод сообщения
        ├── chat_message_list.dart       # Список сообщений
        ├── chat_app_bar.dart            # Верхняя панель чата
        ├── confidence_indicator.dart    # Индикатор уверенности
        ├── speech_button.dart           # Кнопка речи
        ├── theme_toggle_button.dart     # Кнопка темы
        ├── settings_section.dart        # Секция настроек
        │
        └── dialogs/
            ├── save_chat_dialog.dart            # Диалог сохранения
            ├── confirmation_dialog.dart         # Диалог подтверждения
            ├── language_selection_dialog.dart   # Диалог выбора языка
            ├── new_chat_dialog.dart             # Диалог нового чата
            ├── load_chat_dialog.dart            # Диалог загрузки чата
            └── emoji_picker_dialog.dart         # Диалог выбора эмодзи