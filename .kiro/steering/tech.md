---
inclusion: always
---

# Technology Stack

## Framework & Language

- **Flutter** (SDK 3.9.2+)
- **Dart** programming language
- **Material Design 3** UI components

## Dependencies

- `http: ^1.2.0` - HTTP client for API communication
- `flutter_lints: ^5.0.0` - Linting rules (dev dependency)

## Build System

Flutter's standard build system with support for multiple platforms:
- Android (Gradle/Kotlin)
- iOS (Xcode)
- Web
- Linux (CMake)
- macOS (Xcode)
- Windows (CMake)

## Common Commands

```bash
# Run the app in debug mode
flutter run

# Build for production
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format .

# Get dependencies
flutter pub get

# Clean build artifacts
flutter clean
```

## API Communication

- RESTful API calls using `http` package
- JSON serialization/deserialization
- Base URL: `https://googlespreadsheet.tindecken.xyz/api`
- Endpoints: `/addTransaction`, `/perDay`, `/last5Transactions`, `/undoTransaction`
