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
 │   ├── auth/          # Splash, Login, and OTP
 │   ├── dashboard/     # Executive overview and Charts
 │   ├── ai_insights/   # [NEW] AI Risk Scoring & Predictive Analytics
 │   ├── gis_mapping/   # [NEW] GIS Map, Geo-Tagging & Asset Tracking
 │   ├── valuation/     # [NEW] Automated Compensation Engine
 │   └── verification/  # [NEW] Approval & Field Verification Queue
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

## 🔐 5. 2-Step Authentication & Session Persistence

1. **Step 1 (Login)**: User selects **Role**, enters **ID** and **Password** + **CAPTCHA**.
2. **Step 2 (OTP)**: A 6-digit secure code is sent for verification.
3. **Session Persistence**: Secure JWT token and user profile are persisted via `shared_preferences`. The app bypasses login on subsequent launches if the session is active.
4. **Security**: Session is cleared upon manual logout or expiration.

---

## 🧭 6. Executive Dashboard & Command Center

The application features dual executive monitoring modes:

### Executive Dashboard
- **KPI Grid**: Real-time tracking of Applications, Tree Counts, and Compensation.
- **Interactive Line Charts**: Monthly progress tracking for environmental goals.
- **Recent Activity**: Quick access to the latest verification logs.

### 📡 Command Center (Admin & DM Roles Only)
- **40+ Advanced KPIs**: Split into 5 categories (State, Financial, Environmental, Operational, Compliance).
- **Live Monitoring Hub**: Visual indicators for real-time district sync.
- **Rich Data Visualizations**: Bar and Line Charts for district-wise compensation and afforestation trends.
- **Performance Indexing**: Survival rates, CO2 sequestration, and SLA compliance metrics.

### 📊 Enhanced High-Fidelity Analytics
- **12-Month Historical Tracking**: Deep-dive analytics for monthly application volume, tree felling vs planting, and CAMPA funds.
- **Grouped Comparison Charts**: Unified views for correlating disparate metrics (e.g., Tree Cut vs Tree Planted).
- **Interactive Trend Lines**: Trend analysis with area-mapped visualizations for environmental impact and compensation averages.
- **Financial Payment Flow**: Treasury-integrated tracking of released vs pending compensation payments.

### 🧠 AI Intelligence Hub
- **Risk Scoring**: AI-driven project risk assessment (Model: RandomForest/XGBoost logic).
- **Fraud Detection**: Predictive alerts for potential valuation discrepancies.
- **Survival Analytics**: ML-based sapling survival prediction based on district terrain.

### 🗺 GIS & Geo-Tagging Module
- **Interactive Asset Mapping**: Real-time visual tracking of trees and forest land using `flutter_map` (OpenStreetMap).
- **Precision Geo-Tagging**: Field data collection with high-accuracy GPS coordinates (`geolocator`).
- **Site Evidence**: Multi-photo evidence capture and preview (`image_picker`).

### ⚖ Valuation & Verification Engine
- **Automated Valuation**: Instant compensation arithmetic based on species, girth, and land category laws.
- **Verification Queue**: Streamlined workflow for Range Officers and DFOs to review field data and grant approvals.
- **Audit Logging**: Every transition in the verification state is tracked for transparency.

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
