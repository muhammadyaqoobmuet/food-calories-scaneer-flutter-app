<!--
  Modern README for FoodCal Scanner
  - Clean structure
  - Badges
  - Quick links (APK)
  - Install / Run / Dev notes
  - .gitignore guidance
-->

# FoodCal Scanner

![Flutter](https://img.shields.io/badge/Flutter-3.9+-02569B?logo=flutter&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)
![License](https://img.shields.io/badge/License-MIT-green)

A modern, minimal Flutter app that uses AI to identify food from photos and estimate nutritional information (calories & macronutrients). Designed for fast capture, offline history, and a clean UX.

Download the latest Android build (APK):

[Download app-release.apk](https://www.mediafire.com/file/99f1kc88dnic2go/app-release.apk/file)

## Table of contents

- [Why this app](#why-this-app)
- [Features](#features)
- [Screenshots](#screenshots)
- [Quick start](#quick-start)
- [Developer notes](#developer-notes)
- [Data & Storage](#data--storage)
- [Security & Secrets](#security--secrets)
- [Recommended .gitignore additions](#recommended-gitignore-additions)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Why this app

Manual food logging is slow and error-prone. FoodCal Scanner makes it simple: take a photo, get an AI-powered estimate of calories and macros, and save the result locally for later review.

## Features

- Fast photo-based food capture (camera + gallery)
- AI-powered food recognition (Google Gemini API)
- Estimated nutrition: calories, protein, carbs, fat
- Local history (SQLite) for offline access
- Clean, responsive UI for mobile devices
- Environment-based API key management



## Quick start
just download apk dont strugle too much LOL
Clone, configure, and run:

```bash
git clone <your-repo-url>
cd foodcalscanner
flutter pub get
# copy example env and add your GEMINI_API_KEY
cp .env.example .env
# Edit .env and set GEMINI_API_KEY and GEMINI_MODEL (no surrounding quotes recommended)
flutter run
```

Notes:

- To build an APK: `flutter build apk --release` (or use Android Studio)
- Web: some AI features may not work in Chrome due to CORS or unsupported native packages; the app includes fallbacks.

## Developer notes

- Entry point: `lib/main.dart`
- Screens: `lib/screens/` (home, scanner, history)
- Services: `lib/services/` (Gemini AI wrapper, database helper)
- Models: `lib/models/` (data classes)
- Utils: `lib/utils/` (platform-aware helpers)

If you change the Gemini integration, keep the `analyzeFoodBytes(Uint8List)` contract so the scanner (which reads image bytes) works across platforms.

## Data & Storage

- Local DB: SQLite (`sqflite`) on mobile. For web, the app currently uses an in-memory fallback; consider using `sembast`/`sembast_web` for persistent web storage.
- Images: stored as base64 data URLs for cross-platform compatibility. This is simple and reliable but increases DB size by ~33% due to base64 expansion.

## Security & Secrets

- Keep your `GEMINI_API_KEY` private. Use `.env` (and `flutter_dotenv`) to load keys at runtime.
- Do not commit `.env`, keystores, or credentials to Git.

## Recommended .gitignore additions

I've updated `.gitignore` with common exclusions; additionally, consider these entries to avoid leaking sensitive files and bulky artifacts:

```
# environment & secrets
.env

# Flutter/Dart
.dart_tool/
/build/

# Android
/android/key.properties
*.keystore
*.jks

# iOS
Pods/
Runner/GeneratedPluginRegistrant.*

# Archives, exports, and big documents you don't want in git
*.apk
*.aab
*.ipa
*.zip
*.tar.gz
*.pdf

# OS files
.DS_Store
Thumbs.db
```

Explanation: PDFs and binary releases (APK/AAB) are commonly large and often not suitable for source control—keep builds in release assets or a separate storage (releases in GitHub, S3, etc.).

## Troubleshooting

- If analysis shows "Error analyzing food":
  - Check terminal logs for the real exception (the app now surfaces Gemini errors).
  - Verify `GEMINI_API_KEY` in `.env` (avoid extra surrounding quotes).
  - If running on web, the AI package may be unsupported or blocked by CORS — run on a mobile emulator/device or use a server proxy.

## Contributing

Contributions are welcome. Follow these steps:

1. Fork the repo
2. Create a branch: `git checkout -b feature/your-feature`
3. Commit and push
4. Open a pull request with a clear description and screenshots

## License

This project is licensed under the MIT License — see `LICENSE` for details.

---

If you want, I can:

- embed real screenshots into this README (I can capture emulator screenshots if you allow me to run the app),
- add a short Troubleshooting section for specific Gemini/API errors we observed,
- switch web storage from in-memory fallback to persistent `sembast_web` and update README with instructions.

Made with ❤️ — update content as your project evolves.
