
<div align="center">
  <img src="https://img.shields.io/badge/Platform-Android-green?logo=android" alt="Android" />
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="MIT License" />
  <h1>DirDir Flutter App <sub><sup>(Android Only)</sup></sub></h1>
  <p>A modern Flutter application for Android. <br> <b>Only Android implementation is public.</b></p>
</div>

---

## 📱 Platform Support
| Android | iOS | Web | Windows | Linux | macOS |
|:-------:|:---:|:---:|:-------:|:-----:|:-----:|
| ✅      | ❌  | ❌  | ❌      | ❌    | ❌    |

---

## 🚀 Features

<ul>
  <li>✨ Modern Flutter UI</li>
  <li>🖼️ Image picker functionality</li>
  <li>🔔 Local notifications</li>
  <li>🌐 HTTP networking</li>
  <li>🪄 State management with <b>Provider</b></li>
  <li>🧩 Dependency injection with <b>GetIt</b></li>
</ul>

---

## ⚙️ Setup Instructions

### Prerequisites
- <img src="https://img.shields.io/badge/Flutter-3.7.2%2B-blue?logo=flutter" alt="Flutter" />
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
     - Add <code>google-services.json</code> to <code>android/app/</code>
     - Add Firebase dependencies back to <code>pubspec.yaml</code>
     - Create <code>lib/firebase_options.dart</code>
4. **Run the app:**
   ```bash
   flutter run
   ```

---

## 🏗️ Project Structure

```text
lib/
├── App/              # Main app configuration
├── CommonWidget/     # Reusable UI components
├── model/            # Data models
├── Repository/       # Data layer
├── services/         # Business logic services
├── ViewModel/        # View models for state management
└── main.dart         # App entry point
```

---

## 🔒 Security Note
> **This public repository excludes:**
> - Firebase configuration files
> - API keys and secrets
> - iOS/Web/Desktop platform code
> - Backend/Cloud Functions
> - Signing keys and certificates

---

## 📖 Development Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Android Development](https://developer.android.com/docs)

---

## 📄 License

This project is available under the [MIT License](https://opensource.org/licenses/MIT).
