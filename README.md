# 🍽️ FoodCal Scanner

A modern, minimalistic Flutter app that uses AI to identify food and calculate nutritional information from photos. Built with Google's Gemini AI for accurate food recognition and nutrition analysis.

![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey.svg)

## ✨ Features

- 📸 **Camera Integration** - Take photos or select from gallery
- 🤖 **AI Food Recognition** - Powered by Google Gemini AI
- 📊 **Nutrition Analysis** - Calories, protein, carbs, and fat content
- 💾 **Local Storage** - SQLite database for offline access
- 📱 **Modern UI** - Clean, minimalistic design with smooth animations
- 🔒 **Secure** - Environment variables for API key protection
- 🆓 **Free** - No backend costs, uses free Gemini API tier

## 🎨 Screenshots

| Home Screen                                   | Scanner                  | Results                       | History                 |
| --------------------------------------------- | ------------------------ | ----------------------------- | ----------------------- |
| Clean interface with scan and history buttons | Camera/Gallery selection | AI-powered nutrition analysis | View all previous scans |

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Android Studio / VS Code
- Android/iOS device or emulator
- Google account for Gemini API

### Installation

1. **Clone the repository**

   ```bash
   git clone <your-repo-url>
   cd foodcalscanner
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Set up environment variables**

   ```bash
   # Copy the example environment file
   cp .env.example .env

   # Edit .env and add your Gemini API key
   # Get your free API key from: https://aistudio.google.com/app/apikey
   ```

4. **Add your API key to .env**

   ```env
   GEMINI_API_KEY=your_actual_api_key_here
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── food_scan.dart       # Data model for food scans
├── services/
│   ├── database_helper.dart # SQLite database operations
│   └── gemini_service.dart  # AI service for food analysis
└── screens/
    ├── home_screen.dart     # Main landing page
    ├── scanner_screen.dart  # Camera/gallery interface
    └── history_screen.dart  # Scan history viewer
```

## 🔧 Configuration

### Environment Variables

The app uses environment variables to keep sensitive data secure:

- `GEMINI_API_KEY`: Your Google Gemini AI API key

### API Setup

1. Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Sign in with your Google account
3. Create a new API key
4. Copy the key to your `.env` file

**Free Tier Limits:**

- 1,500 requests per day
- No cost for basic usage

## 🎯 How It Works

1. **Capture**: Take a photo of food or select from gallery
2. **Analyze**: Gemini AI identifies the food and calculates nutrition
3. **Store**: Results are saved locally using SQLite
4. **Review**: Browse scan history with detailed nutrition info

## 🛠️ Built With

- **[Flutter](https://flutter.dev/)** - UI framework
- **[Google Generative AI](https://pub.dev/packages/google_generative_ai)** - Food recognition
- **[SQLite](https://pub.dev/packages/sqflite)** - Local database
- **[Image Picker](https://pub.dev/packages/image_picker)** - Camera/gallery access
- **[Flutter Dotenv](https://pub.dev/packages/flutter_dotenv)** - Environment variables

## 📱 Supported Platforms

- ✅ Android 5.0+ (API 21+)
- ✅ iOS 11.0+
- ❌ Web (camera limitations)
- ❌ Desktop (not optimized)

## 🔒 Security

- API keys stored in environment variables
- `.env` file excluded from version control
- No sensitive data in source code
- Local data storage only

## 🧪 Testing

```bash
# Run all tests
flutter test

# Check for issues
flutter analyze

# Check dependencies
flutter pub deps
```

## 📋 TODO

- [ ] Add more detailed nutrition information
- [ ] Implement food portion size estimation
- [ ] Add meal planning features
- [ ] Support for multiple food items in one photo
- [ ] Export data functionality
- [ ] Dark mode theme

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Google Gemini AI for food recognition
- Flutter team for the amazing framework
- Contributors and testers

## 📞 Support

If you encounter any issues:

1. Check the [troubleshooting guide](SETUP_INSTRUCTIONS.md)
2. Create an issue on GitHub
3. Ensure your API key is properly configured

## 🔗 Links

- [Flutter Documentation](https://docs.flutter.dev/)
- [Google AI Studio](https://aistudio.google.com/)
- [Gemini API Documentation](https://ai.google.dev/docs)

---

**Made with ❤️ using Flutter**
