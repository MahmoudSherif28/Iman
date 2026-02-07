# Iman – إيمان 🕌

A comprehensive **Islamic companion app** built with Flutter that provides Muslims with essential daily worship tools — prayer times, Qibla direction, Quran reading & listening, Azkar (supplications), and more.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| **Prayer Times** | Accurate prayer times based on GPS location via the [Aladhan API](https://aladhan.com/prayer-times-api) (Egyptian General Authority method). |
| **Adhan Scheduler** | Automatic adhan notifications scheduled with `android_alarm_manager_plus`. |
| **Qibla Compass** | Real-time Qibla direction using the device compass and geolocation. |
| **Quran Reader** | Full Mushaf (Uthmanic script, Hafs narration) with page-by-page navigation and Tasmee' mode. |
| **Khatma Planner** | Plan your Quran completion with scheduled daily reminders. Set the number of khatmas, duration, and notification times. Receive instant confirmation with scheduled times and daily page count. |
| **Quran Audio** | Browse reciters, stream Quran audio in background via `audio_service`. |
| **Surah Download** | Download surahs for offline listening with real-time progress notifications (0-100%) and automatic completion alerts. Downloads saved to device storage. |
| **Azkar & Du'a** | Categorised supplications (morning, evening, after prayer, before sleep, etc.) with a personal *My Azkar* list. |
| **Hijri Calendar** | Current Hijri date displayed on the home screen. |
| **Onboarding** | First-launch walkthrough introducing the app. |
| **Localisation** | Arabic (primary) & English UI via `flutter_localizations` and ARB files. |
| **Theming** | Light & Dark themes with a consistent colour palette (`AppColors`). |

---

## 🏗️ Architecture

The project follows **Clean Architecture** organised by feature:

```
lib/
├── Core/                  # Shared infrastructure
│   ├── errors/            # Failure & exception models
│   ├── services/          # ApiService, SharedPreferences singleton, GetIt DI
│   ├── theme/             # Light & dark ThemeData
│   └── utils/             # AppColors, AppTextStyles, AppThemes
│
├── Features/
│   ├── Splash/            # Animated splash screen
│   ├── onboard/           # Onboarding walkthrough
│   ├── home/              # Home screen, prayer list, worship categories
│   ├── prayer_times/      # Prayer times feature (data → repo → cubit → UI)
│   ├── qibla/             # Qibla compass (location + calculator repos)
│   ├── quran_audio/       # Reciters list, audio playback service
│   ├── quran_text/        # Mushaf reader (Uthmanic script)
│   └── azkar/             # Azkar categories & items
│
├── generated/             # Auto-generated localisation delegates
├── l10n/                  # ARB translation files (ar / en)
├── constants.dart         # App-wide string constants
└── main.dart              # Entry point
```

Each feature is split into **data** (models, repositories) and **presentation** (cubits / BLoC, views, widgets) layers.

### Key Patterns

- **State Management** — `flutter_bloc` (Cubit) for reactive UI.
- **Dependency Injection** — `get_it` service locator, initialised in `setupGetIt()`.
- **Repository Pattern** — Abstract repo → implementation; data layer returns `Either<Failure, T>` (`dartz`).
- **Singleton Services** — `ApiService`, `Prefs` (SharedPreferences), `PrayerTimesRepoImpl` (with in-memory cache).
- **Responsive Design** — `flutter_screenutil` with a 375 × 812 design size.

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management (Cubit) |
| `get_it` | Service locator / DI |
| `dartz` | Functional `Either` type for error handling |
| `equatable` | Value equality for state classes |
| `http` | HTTP client for API calls |
| `geolocator` | GPS location services |
| `flutter_compass` | Device compass for Qibla |
| `permission_handler` | Runtime permission requests |
| `shared_preferences` | Local key-value storage |
| `android_alarm_manager_plus` | Scheduling adhan alarms |
| `just_audio` + `audio_service` | Background audio playback |
| `cached_network_image` | Image caching for reciter avatars |
| `shimmer` | Loading skeleton UI |
| `hijri` | Hijri calendar conversion |
| `flutter_screenutil` | Responsive sizing |
| `flutter_svg` | SVG rendering |
| `flutter_localizations` + `intl` | i18n / l10n |
| `animated_splash_screen` | Splash animation |

---

## 🎯 Feature Highlights

### Khatma Planner

Plan your Quran completion (Khatma) with smart daily reminders:

1. **Set Your Goals** — Choose the number of khatmas you want to complete and the duration (in days).
2. **Schedule Notifications** — Add one or more daily notification times when you want to be reminded.
3. **Instant Confirmation** — Receive an immediate notification showing:
   - Your scheduled reminder times
   - Number of pages to read daily
   - Total duration
4. **Daily Reminders** — Get notified at your chosen times with the Ayah range you need to read.

**How to Use:**
- Open **Mushaf Reader** → Settings (⚙️) → **Khatma Planner**
- Enter number of khatmas and duration
- Add notification times
- Save and start your journey!

### Surah Download with Progress Tracking

Download your favorite surahs for offline listening with a complete progress experience:

1. **Real-Time Progress** — See download progress from 0% to 100% in your notification bar
2. **Smart Updates** — Progress updates every 5% to avoid overwhelming notifications
3. **Completion Alert** — Automatic success notification when download completes
4. **Error Handling** — Clear error messages with guidance if something goes wrong
5. **Storage Management** — Files saved to device's Download folder for easy access

**How to Use:**
- Open **Audio Player** → Play any surah
- Tap the download icon (⬇️) in the app bar
- Grant audio/storage permission when prompted
- Watch the progress in your notifications!

**Required Permissions:**
- **Android 13+** — "Music and audio" permission (READ_MEDIA_AUDIO)
- **Android 10-12** — Storage permission
- **Android 9 and below** — External storage permission

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** ≥ 3.9.2
- **Dart SDK** (bundled with Flutter)
- **Android Studio** or **VS Code** with Flutter plugin
- An Android device / emulator (API 21+)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/Iman.git
cd Iman

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Build APK

```bash
flutter build apk --release
```

The output APK is located at `build/app/outputs/flutter-apk/app-release.apk`.

---

## 🔧 Configuration

| Item | Details |
|------|---------|
| **Prayer Times API** | [Aladhan v1](https://api.aladhan.com/v1/timings) — method 5 (Egyptian General Authority of Survey). |
| **Kotlin Version** | `1.9.24` (required by `android_alarm_manager_plus`; Flutter deprecation warning is expected). |
| **Design Size** | 375 × 812 (iPhone X baseline for `flutter_screenutil`). |
| **Fonts** | *IBM Plex Sans Arabic* (UI) · *KFGQPC Uthmanic Script HAFS* (Quran text). |

---

## 🌐 Localisation

Translation files are in `lib/l10n/`:

| File | Language |
|------|----------|
| `intl_ar.arb` | Arabic (default) |
| `intl_en.arb` | English |

To add a new locale, create `intl_<code>.arb` and run:

```bash
flutter gen-l10n
```

---

## 📱 Download

Download the latest release APK (v1.3.0) and install it directly on your Android device:

[![Download APK](https://img.shields.io/badge/Download-APK-green?style=for-the-badge&logo=android)](https://github.com/MahmoudSherif28/Iman/releases/download/v1.3.0/Iman-v1.3.0.apk)

> **How to install:** Download the APK → Open it on your Android device → Allow installation from unknown sources if prompted → Install & enjoy!

You can also browse all releases on the [Releases page](https://github.com/MahmoudSherif28/Iman/releases).

---

## 📄 License

This project is for educational and personal use. Feel free to fork and adapt it for your own Islamic app projects.
