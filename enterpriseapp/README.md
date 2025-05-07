# enterpriseapp

A new Flutter project.

lib/
├── app/
│   ├── app.dart                # Root MaterialApp
│   ├── routes.dart             # Screen routing setup
│   └── theme.dart              # App theme & styling
│
├── core/
│   ├── constants/              # Keys, enums, hardcoded strings
│   ├── services/               # Timer, API, SharedPreferences, network, etc.
│   │   ├── timer_service.dart
│   │   ├── api_service.dart
│   │   └── local_storage_service.dart
│   └── utils/                  # General utilities (validators, formatters, etc.)
│
├── models/                     # All data classes
│   ├── form_data.dart
│   └── config.dart
│
├── providers/                 # Global shared state
│   ├── form_data_notifier.dart
│   ├── config_notifier.dart
│   └── app_state_notifier.dart
│
├── data/                      # Data access layer (repositories)
│   ├── repositories/
│   │   ├── form_repository.dart
│   │   └── config_repository.dart
│
├── viewmodels/               # Per-screen logic (UI controllers)
│   ├── name_screen_vm.dart
│   ├── email_screen_vm.dart
│   ├── timer_screen_vm.dart
│   └── submit_screen_vm.dart
│
├── views/                    # UI screens & widgets
│   ├── screens/
│   │   ├── name_screen.dart
│   │   ├── email_screen.dart
│   │   └── submit_screen.dart
│   └── widgets/
│       ├── kiosk_button.dart
│       └── input_field.dart
│
└── main.dart                 # Entry point (includes MultiProvider)