---
inclusion: always
---

# Project Structure

## Directory Organization

```
lib/
├── main.dart                    # App entry point, MaterialApp, HomePage with bottom nav
├── add_section.dart             # Add transaction form UI
├── transactions_section.dart    # Transaction list and undo UI
├── models/
│   └── add_transaction.dart     # Data models and API response classes
└── services/
    └── transaction_service.dart # HTTP API client
```

## Architecture Patterns

### State Management
- StatefulWidget with setState for local UI state
- Callback functions for parent-child communication (e.g., `onPerDayUpdate`)
- No external state management library

### Code Organization
- **UI Components**: Separate files for each major section (`add_section.dart`, `transactions_section.dart`)
- **Models**: Data classes with `toJson()` and `fromJson()` methods in `models/`
- **Services**: API communication logic isolated in `services/`
- **Separation of Concerns**: UI, business logic, and data layers are clearly separated

### Widget Structure
- Stateless widgets for static content
- Stateful widgets for interactive forms and dynamic lists
- Form validation using `GlobalKey<FormState>`
- TextEditingController for form inputs

## Naming Conventions

- **Files**: snake_case (e.g., `add_section.dart`, `transaction_service.dart`)
- **Classes**: PascalCase (e.g., `AddSection`, `TransactionService`)
- **Variables/Functions**: camelCase (e.g., `_isLoading`, `_handleSubmit`)
- **Private members**: Prefix with underscore (e.g., `_currentIndex`, `_loadPerDay`)
- **Constants**: camelCase with `const` keyword

## UI Patterns

- Material Design 3 with ColorScheme
- Form validation with user-friendly error messages
- Loading states with CircularProgressIndicator
- SnackBar for success/error feedback
- Responsive layouts with Expanded and Flexible widgets
