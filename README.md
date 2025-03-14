lib/
├── main.dart                # Точка входа приложения
├── app.dart                 # Корневой виджет с провайдерами и темами
│
├── config/                  # Конфигурации приложения
│   ├── routes.dart          # Определение маршрутов для навигации
│   ├── dependency_injection.dart # Инъекция зависимостей с GetIt
│   └── app_config.dart      # Конфигурация для разных сред (dev/prod)
│
├── core/                    # Базовые компоненты
│   ├── constants/           
│   │   ├── app_constants.dart        # Общие константы приложения
│   │   └── classification_constants.dart # Константы для классификации
│   │
│   ├── errors/              
│   │   ├── app_exception.dart       # Иерархия исключений
│   │   ├── failure.dart             # Классы ошибок для Either
│   │   └── error_handler.dart       # Обработчик ошибок
│   │
│   ├── services/            
│   │   └── translation_service.dart # Сервис для локализации
│   │
│   ├── utils/               
│   │   ├── file_utils.dart          # Работа с файлами
│   │   ├── string_utils.dart        # Обработка строк
│   │   ├── datetime_utils.dart      # Форматирование дат
│   │   ├── math_utils.dart          # Математические функции
│   │   └── translation_utils.dart   # Утилиты для переводов
│   │
│   └── logger/              
│       ├── app_logger.dart          # Система логирования
│       └── log_level.dart           # Уровни логирования
│
├── data/                    # Слой данных
│   ├── datasources/         
│   │   ├── device/
│   │   │   └── speech_datasource.dart      # Распознавание речи
│   │   │
│   │   ├── local/
│   │   │   ├── chat_local_datasource.dart  # Хранение чатов
│   │   │   └── preferences_datasource.dart # Хранение настроек
│   │   │
│   │   └── remote/
│   │       ├── classifier_datasource.dart  # API классификатора
│   │       └── translator_datasource.dart  # API перевода
│   │
│   ├── models/              
│   │   ├── message_model.dart        # Модель сообщения
│   │   └── chat_model.dart           # Модель чата
│   │
│   └── repositories/        
│       ├── chat_repository_impl.dart        # Реализация репозитория чатов
│       ├── settings_repository_impl.dart    # Реализация репозитория настроек
│       ├── classifier_repository_impl.dart  # Реализация репозитория классификатора
│       ├── translator_repository_impl.dart  # Реализация репозитория переводчика
│       └── speech_repository_impl.dart      # Реализация репозитория речи
│
├── domain/                  # Бизнес-логика
│   ├── entities/            
│   │   ├── message.dart               # Сущность сообщения
│   │   ├── chat.dart                  # Сущность чата
│   │   ├── classification_result.dart # Результат классификации
│   │   └── user_settings.dart         # Настройки пользователя
│   │
│   ├── repositories/        
│   │   ├── chat_repository.dart       # Интерфейс репозитория чатов
│   │   ├── settings_repository.dart   # Интерфейс репозитория настроек
│   │   ├── classifier_repository.dart # Интерфейс репозитория классификатора
│   │   ├── translator_repository.dart # Интерфейс репозитория переводчика
│   │   └── speech_repository.dart     # Интерфейс репозитория речи
│   │
│   └── usecases/            
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
│           └── listen_to_speech.dart    # Распознавание речи
│
└── presentation/           # Пользовательский интерфейс
    ├── bloc/               
    │   ├── chat/
    │   │   ├── chat_bloc.dart           # Блок для управления чатом
    │   │   ├── chat_event.dart          # События чата
    │   │   └── chat_state.dart          # Состояния чата
    │   │
    │   ├── theme/          
    │   │   ├── theme_bloc.dart          # Блок для управления темой
    │   │   ├── theme_event.dart         # События темы
    │   │   └── theme_state.dart         # Состояния темы
    │   │
    │   └── language/       
    │       ├── language_bloc.dart       # Блок для управления языком
    │       ├── language_event.dart      # События языка
    │       └── language_state.dart      # Состояния языка
    │
    ├── screens/            
    │   ├── chat_screen.dart             # Экран чата
    │   ├── settings_screen.dart         # Экран настроек
    │   └── chat_list_screen.dart        # Экран списка чатов
    │
    └── widgets/            
        ├── message_bubble.dart          # Виджет сообщения
        ├── message_actions_menu.dart    # Меню действий с сообщением
        ├── chat_input.dart              # Ввод сообщения
        ├── chat_app_bar.dart            # Верхняя панель чата
        ├── confidence_indicator.dart    # Индикатор уверенности
        ├── speech_button.dart           # Кнопка распознавания речи
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

graph TD
%% Основные слои приложения
App[App] --> Config
App --> Core
App --> Data
App --> Domain
App --> Presentation

    %% Конфигурация
    Config[Config]
    Config --> AppConfig[AppConfig]
    Config --> DependencyInjection[DependencyInjection]
    Config --> AppRoutes[AppRoutes]
    
    %% Ядро приложения
    Core[Core]
    Core --> Constants[Constants]
    Core --> Errors[Errors]
    Core --> Services[Services]
    Core --> Utils[Utils]
    Core --> Logger[Logger]
    
    %% Константы
    Constants --> AppConstants[AppConstants]
    Constants --> ClassificationConstants[ClassificationConstants]
    
    %% Обработка ошибок
    Errors --> AppException[AppException]
    Errors --> Failure[Failure]
    Errors --> ErrorHandler[ErrorHandler]
    
    %% Сервисы
    Services --> TranslationService[TranslationService]
    
    %% Утилиты
    Utils --> FileUtils[FileUtils]
    Utils --> StringUtils[StringUtils]
    Utils --> DateTimeUtils[DateTimeUtils]
    Utils --> MathUtils[MathUtils]
    Utils --> TranslationUtils[TranslationUtils]
    
    %% Логирование
    Logger --> AppLogger[AppLogger]
    Logger --> LogLevel[LogLevel]
    
    %% Слой данных
    Data[Data]
    Data --> DataSources[DataSources]
    Data --> Models[Models]
    Data --> Repositories[RepositoriesImpl]
    
    %% Источники данных
    DataSources --> DeviceSources[Device]
    DataSources --> LocalSources[Local]
    DataSources --> RemoteSources[Remote]
    
    %% Устройство
    DeviceSources --> SpeechDataSource[SpeechDataSource]
    
    %% Локальные источники
    LocalSources --> ChatLocalDataSource[ChatLocalDataSource]
    LocalSources --> PreferencesDataSource[PreferencesDataSource]
    LocalSources --> SecureStorageDataSource[SecureStorageDataSource]
    
    %% Удаленные источники
    RemoteSources --> ClassifierDataSource[ClassifierDataSource]
    RemoteSources --> TranslatorDataSource[TranslatorDataSource]
    
    %% Модели данных
    Models --> MessageModel[MessageModel]
    Models --> ChatModel[ChatModel]
    
    %% Реализации репозиториев
    Repositories --> ChatRepositoryImpl[ChatRepositoryImpl]
    Repositories --> SettingsRepositoryImpl[SettingsRepositoryImpl]
    Repositories --> ClassifierRepositoryImpl[ClassifierRepositoryImpl]
    Repositories --> TranslatorRepositoryImpl[TranslatorRepositoryImpl]
    Repositories --> SpeechRepositoryImpl[SpeechRepositoryImpl]
    
    %% Доменный слой
    Domain[Domain]
    Domain --> Entities[Entities]
    Domain --> Repositories[Repositories]
    Domain --> UseCases[UseCases]
    
    %% Сущности
    Entities --> Message[Message]
    Entities --> Chat[Chat]
    Entities --> ClassificationResult[ClassificationResult]
    Entities --> UserSettings[UserSettings]
    
    %% Интерфейсы репозиториев
    Repositories --> ChatRepository[ChatRepository]
    Repositories --> SettingsRepository[SettingsRepository]
    Repositories --> ClassifierRepository[ClassifierRepository]
    Repositories --> TranslatorRepository[TranslatorRepository]
    Repositories --> SpeechRepository[SpeechRepository]
    
    %% Сценарии использования
    UseCases --> ChatUseCases[Chat]
    UseCases --> SettingsUseCases[Settings]
    UseCases --> ClassificationUseCases[Classification]
    UseCases --> TranslationUseCases[Translation]
    UseCases --> SpeechUseCases[Speech]
    
    %% Сценарии использования для чата
    ChatUseCases --> SendMessage[SendMessage]
    ChatUseCases --> GetMessageHistory[GetMessageHistory]
    ChatUseCases --> SaveChat[SaveChat]
    ChatUseCases --> DeleteChat[DeleteChat]
    ChatUseCases --> ExportChat[ExportChat]
    
    %% Сценарии использования для настроек
    SettingsUseCases --> GetSettings[GetSettings]
    SettingsUseCases --> ToggleTheme[ToggleTheme]
    SettingsUseCases --> ChangeLanguage[ChangeLanguage]
    
    %% Сценарии использования для классификации
    ClassificationUseCases --> ClassifyText[ClassifyText]
    
    %% Сценарии использования для перевода
    TranslationUseCases --> TranslateText[TranslateText]
    
    %% Сценарии использования для речи
    SpeechUseCases --> ListenToSpeech[ListenToSpeech]
    
    %% Слой представления
    Presentation[Presentation]
    Presentation --> Bloc[BLoC]
    Presentation --> Screens[Screens]
    Presentation --> Widgets[Widgets]
    
    %% BLoC компоненты
    Bloc --> ChatBloc[ChatBloc]
    Bloc --> ThemeBloc[ThemeBloc]
    Bloc --> LanguageBloc[LanguageBloc]
    
    %% Экраны приложения
    Screens --> ChatScreen[ChatScreen]
    Screens --> SettingsScreen[SettingsScreen]
    Screens --> ChatListScreen[ChatListScreen]
    
    %% Виджеты
    Widgets --> MessageBubble[MessageBubble]
    Widgets --> MessageActionsMenu[MessageActionsMenu]
    Widgets --> ChatInput[ChatInput]
    Widgets --> ChatMessageList[ChatMessageList]
    Widgets --> ChatAppBar[ChatAppBar]
    Widgets --> ConfidenceIndicator[ConfidenceIndicator]
    Widgets --> SpeechButton[SpeechButton]
    Widgets --> ThemeToggleButton[ThemeToggleButton]
    Widgets --> SettingsSection[SettingsSection]
    Widgets --> Dialogs[Dialogs]
    
    %% Диалоги
    Dialogs --> SaveChatDialog[SaveChatDialog]
    Dialogs --> ConfirmationDialog[ConfirmationDialog]
    Dialogs --> LanguageSelectionDialog[LanguageSelectionDialog]
    Dialogs --> NewChatDialog[NewChatDialog]
    Dialogs --> LoadChatDialog[LoadChatDialog]
    Dialogs --> EmojiPickerDialog[EmojiPickerDialog]
    
    %% Связи между слоями
    ChatBloc --> SendMessage
    ChatBloc --> GetMessageHistory
    ChatBloc --> SaveChat
    ChatBloc --> DeleteChat
    
    ThemeBloc --> ToggleTheme
    ThemeBloc --> GetSettings
    
    LanguageBloc --> ChangeLanguage
    LanguageBloc --> GetSettings
    
    SendMessage --> ChatRepository
    SendMessage --> ClassifierRepository
    SendMessage --> TranslatorRepository
    
    GetMessageHistory --> ChatRepository
    SaveChat --> ChatRepository
    DeleteChat --> ChatRepository
    ExportChat --> ChatRepository
    
    ToggleTheme --> SettingsRepository
    ChangeLanguage --> SettingsRepository
    GetSettings --> SettingsRepository
    
    ClassifyText --> ClassifierRepository
    TranslateText --> TranslatorRepository
    ListenToSpeech --> SpeechRepository
    
    ChatRepositoryImpl --> ChatLocalDataSource
    SettingsRepositoryImpl --> PreferencesDataSource
    ClassifierRepositoryImpl --> ClassifierDataSource
    TranslatorRepositoryImpl --> TranslatorDataSource
    SpeechRepositoryImpl --> SpeechDataSource
    
    ChatScreen --> ChatBloc
    SettingsScreen --> ThemeBloc
    SettingsScreen --> LanguageBloc
    ChatListScreen --> ChatBloc
    
    style App fill:#f9f,stroke:#333,stroke-width:2px
    style Core fill:#bbf,stroke:#333,stroke-width:2px
    style Data fill:#bfb,stroke:#333,stroke-width:2px
    style Domain fill:#fbf,stroke:#333,stroke-width:2px
    style Presentation fill:#fbb,stroke:#333,stroke-width:2px
    style Config fill:#bff,stroke:#333,stroke-width:2px