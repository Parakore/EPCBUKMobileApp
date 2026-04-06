# 🌲 Forest Management System - EPCBUK Mobile App

A professional, scalable Flutter application for managing forest ecosystems and tree plantation.

## 🏗 Architecture (MVVM)

The app follows the **Model-View-ViewModel (MVVM)** pattern:

- **Model**: Data structures and API response models.
- **View**: UI components using only business-logic-free code.
- **ViewModel**: State management logic powered by Riverpod.
- **Repository**: Data access layer handles Dio networking and caching.

## 🚀 Tech Stack

- **State Management**: [Riverpod](https://pub.dev/packages/flutter_riverpod)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Networking**: [Dio](https://pub.dev/packages/dio)
- **Styling**: [Material 3](https://m3.material.io/) with nature-inspired themes.

## 📂 Folder Structure

```
lib/
 ├── core/              # Global utilities (Theme, Network, Widgets)
 ├── features/          # Modular business logic
 │   ├── auth/          # Login/Signup module
 │   └── dashboard/     # Metrics and stats overview
 ├── routes/            # GoRouter centralized setup
 ├── providers/         # Global Riverpod providers
 └── main.dart          # Entry point
```

## 🛠 Setup & Run

1.  Clone the repository.
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Set up environment:
    ```bash
    cp .env.example .env
    ```
4.  Run the application:
    ```bash
    flutter run
    ```

## 🎨 Theme System

Inspired by nature:
- **Primary**: Forest Green (#2E7D32)
- **Earth**: Brown (#6D4C41)
- **Background**: Soft Natural (#F1F8E9)

---
*Developed by Antigravity AI*
