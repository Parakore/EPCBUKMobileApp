# VERSION.md - Project Tracking

[0.5.0] - 2026-04-08

### Added
- [FEATURE] Enhanced High-Fidelity Analytics: 12-month trend tracking across all modules (Env, Financial, Ops).
- [FEATURE] Multi-Metric Correlation Charts: Grouped visualizations for Trees Cut vs Planted and CAMPA Fund matching.
- [FEATURE] Financial Payment Flow: Real-time visualization of Treasury released vs pending payments.
- [UI] Reusable Monthly Chart Components: Optimized `fl_chart` integration for government-grade aesthetics.

### Updated
- `ReportsRepository`: Implemented 12-month historical data generation for realistic state-wide reporting.
- `ReportsScreen`: Full UI refactor to support interactive high-fidelity month-over-month analysis.

[0.4.0] - 2026-04-07

### Added
- [FEATURE] AI Intelligence Hub: Advanced risk scoring and predictive analytics with glassmorphism UI.
- [FEATURE] GIS Intelligence Map: Real-time asset tracking using OpenStreetMap and marker clustering.
- [FEATURE] Geo-Tagging & Field Survey: Capture precise coordinates (Geolocator) and site evidence (Image Picker).
- [FEATURE] Valuation Engine: Automated compensation arithmetic based on Uttarakhand forest land/tree value rules.
- [FEATURE] Approval & Verification Queue: Centralized workflow for officers to review, approve, or reject field cases.
- [CORE] `image_picker` and `geolocator` integration for field operations.

### Updated
- `DashboardScreen`: Integrated live navigation links for GIS, AI, and Valuation modules.
- `AppRouter`: Registered all new field and intelligence module routes.
- `Providers`: Centralized all repository and viewmodel providers for new features.

[0.3.0] - 2026-04-06

### Added
- [FEATURE] Persistent Login: Users remain logged in after app restart via `shared_preferences`.
- [FEATURE] Executive Command Center: A high-fidelity screen with 40+ KPIs across 5 categories (State, Financial, Env, Ops, Compliance).
- [FEATURE] Interactive Advanced Analytics: District-wise compensation and afforestation progress charts (fl_chart).
- [UI] Live status indicator for real-time monitoring.
- [CORE] `StorageService` for secure local session management.

### Updated
- `SplashView` logic to support auto-login redirects.
- `AuthViewModel` with role-based persistence initialization.
- `AppRouter` with specific routes for Command Center.

[0.2.0] - 2026-04-06

### Added
- [FEATURE] Premium Animated Splash Screen with forest-inspired branding.
- [FEATURE] Modernized Login Screen with 8 user roles, functional CAPTCHA UI, and 2-step authentication flow.
- [FEATURE] New Secure OTPScreen with 6-digit numeric entry and countdown timer.
- [FEATURE] Advanced Executive Dashboard with interactive Line Charts (fl_chart) and responsive metrics grid.
- [UI] Refined premium widgets: AppButton, AppTextField, AppCard, and AppOTPField.
- [CORE] Integrated `flutter_animate` for a polished, lively user experience.
- [CORE] Centralized `Dio` client with logging interceptors.
- [CORE] Dynamic Routing setup via GoRouter.

### Fixed
- Navigation flow logic (Splash → Login → OTP → Dashboard).
- Global theme consistency for Material 3.

[0.1.0] - 2026-04-06
- Initial project setup with MVVM and Riverpod.
