# 🌲 UTCMS - Environment Management Mobile System

A premium, production-ready Flutter application for the **Uarakhand Tree Compensation Management System (UTCMS)**. Designed for forest officers and executive users with a "Government-grade" aesthetic and secure role-based access.

---

## 🏗 1. Project Architecture (MVVM)

The project strictly follows the **Model-View-ViewModel** pattern for maximum scalability and decoupling:

- **View**: UI components using only business-logic-free code (`lib/features/*/view/`).
- **ViewModel**: Reactive state management and business logic powered by **Riverpod** (`lib/features/*/viewmodel/`).
- **Repository**: Data access layer handling **Dio** networking and caching (`lib/features/*/repository/`).
- **Model**: Immutable data structures and JSON serialization (`lib/features/*/model/`).

---

## 🚀 2. Tech Stack

| Technology | Purpose |
| :--- | :--- |
| **Flutter** | Cross-platform framework |
| **Riverpod** | State management (StateNotifier + AsyncNotifier) |
| **GoRouter** | Centralized, declarative navigation |
| **Dio** | Advanced HTTP networking with Interceptors |
| **Google Fonts** | Modern typography (Inter) |
| **FL Chart** | Professional interactive data visualization |
| **Flutter Animate** | Micro-interactions and rich animations |

---

## 📂 3. Folder Structure

```
lib/
 ├── core/              # Global utilities (Theme, Network, Widgets)
 │   ├── network/       # Dio instance and interceptors
 │   ├── theme/         # Color tokens and Material 3 design system
 │   └── widgets/       # Reusable premium components (AppButton, AppCard, etc.)
 ├── features/          # Independent business modules
 │   ├── auth/          # Splash, Login (Step 1), and OTP (Step 2)
 │   └── dashboard/     # Executive overview, KPI grid, and Charts
 ├── routes/            # GoRouter centralized setup
 ├── providers/         # Global Riverpod provider registrations
 └── main.dart          # App entry point
```

---

## 🛠 4. Setup & Running

1. **Environment Setup**:
   Ensure **FVM** (Flutter Version Management) is installed.
   ```bash
   # Initialize project
   fvm install
   fvm use
   ```

2. **Run Application**:
   ```bash
   fvm flutter pub get
   fvm flutter run
   ```

3. **Build Runner**:
   If modifying models/providers:
   ```bash
   fvm flutter pub run build_runner build --delete-conflicting-outputs
   ```

---

## 🔐 5. 2-Step Authentication Flow

1. **Step 1 (Login)**: User selects **Role**, enters **ID** and **Password** + **CAPTCHA**.
2. **Step 2 (OTP)**: A 6-digit secure code is sent for verification.
3. **Session**: Secure JWT token is handled via `Dio` interceptors for authorized requests.

---

## 📊 6. Executive Dashboard

The dashboard provides a high-level overview for forest officers:
- **KPI Grid**: Real-time tracking of Applications, Tree Counts, and Compensation.
- **Interactive Line Charts**: Monthly progress tracking for environmental goals.
- **Recent Activity**: Quick access to the latest verification logs.

---

## 🎯 7. Project Rules (STRICT)

- **One Class Per File**: Keep logic focused and clean.
- **Max File Length**: 300 lines (Refactor into sub-widgets/mixins if exceeded).
- **Navigation**: Use `GoRouter` only. No `Navigator.push`.
- **Styling**: Use global `AppTheme` constants. No hardcoded colors/fonts in UI.
- **Error Handling**: All API calls must utilize `try-catch` within repositories and be handled by the ViewModel.

---

## 🧪 8. Testing

- **Unit Tests**: All ViewModels and Repositories must have corresponding tests.
- **Widget Tests**: Critical UI components (AppButton, OTPScreen).

---

© 2026 Uarakhand Environment Protection Agency. All rights reserved.
