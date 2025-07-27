# DirDir Flutter App (Android Only)

A Flutter application for Android platform. This is a public repository containing only the Android implementation.

## 📱 Platform Support
- ✅ Android
- ❌ iOS, Web, Windows, Linux, macOS (excluded from public repo)

## 🚀 Features
- Modern Flutter UI
- Image picker functionality
- Local notifications
- HTTP networking
- State management with Provider
- Dependency injection with GetIt

## ⚙️ Setup Instructions

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Android Studio / VS Code
- Android SDK

### Installation

1. **Clone the repository:**
```bash
git clone <your-repo-url>
cd app_dirdir_public
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Configure Firebase (Optional):**
   - This repo doesn't include Firebase configuration files for security
   - If you want to use Firebase features, you need to:
     - Create your own Firebase project
     - Add `google-services.json` to `android/app/`
     - Add Firebase dependencies back to `pubspec.yaml`
     - Create `lib/firebase_options.dart`

4. **Run the app:**
```bash
flutter run
```

## 🏗️ Project Structure
```
lib/
├── App/              # Main app configuration
├── CommonWidget/     # Reusable UI components
├── model/           # Data models
├── Repository/      # Data layer
├── services/        # Business logic services
├── ViewModel/       # View models for state management
└── main.dart        # App entry point
```

## 🔒 Security Note
This public repository excludes:
- Firebase configuration files
- API keys and secrets
- iOS/Web/Desktop platform code
- Backend/Cloud Functions
- Signing keys and certificates

## 📖 Development Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Android Development](https://developer.android.com/docs)

## 📄 License
This project is available under the MIT License.
