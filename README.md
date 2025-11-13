# ElimuApp - Learning Made Easy for Every Child 📚

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)
![License](https://img.shields.io/badge/License-Proprietary-red)

ElimuApp is a mobile educational application designed to provide affordable, offline-accessible educational resources to rural primary school students in Grades 6-9.

## 🌟 Features

### Core Functionality
- ✅ **Multi-Grade Support**: Resources for Grades 6, 7, 8, and 9
- ✅ **Offline Access**: Download and access content without internet
- ✅ **Multiple Resource Types**: Textbooks, Notes, PDFs, and Videos
- ✅ **User Authentication**: Email/Password, Google Sign-In, and Guest mode
- ✅ **Storybook Corner**: Engaging stories for young learners
- ✅ **Multi-Language**: English and Swahili support

### User Experience
- 🎨 **Kid-Friendly UI**: Colorful, intuitive interface
- 📱 **Responsive Design**: Works on various screen sizes
- 🌙 **Offline-First**: Designed for areas with limited connectivity
- 💾 **Smart Downloads**: Track and manage downloaded content
- 📊 **Progress Tracking**: Monitor learning progress

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Android Studio or VS Code
- Firebase account
- Android device or emulator

### Installation

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Set up Firebase**
   - Follow the detailed guide in [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
   - Place `google-services.json` in `android/app/`

3. **Run the app**
   ```bash
   flutter run
   ```

For detailed setup instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md).




## 📁 Project Structure

```
elimu_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   ├── screens/                  # UI screens
│   ├── widgets/                  # Reusable widgets
│   └── services/                 # Business logic
├── assets/                       # Images, fonts, icons
├── data/                         # JSON resource files
├── android/                      # Android configuration
└── ios/                          # iOS configuration
```

## 🎯 Key Screens

1. **Splash Screen** - Animated logo with navigation
2. **Authentication** - Login, Sign-up, Google Sign-In, Guest mode
3. **Survey** - First-time user data collection
4. **Home** - Grade selection with bottom navigation
5. **Category** - Browse textbooks, notes, PDFs, videos
6. **Downloads** - Manage offline content
7. **Storybook** - Read engaging stories
8. **Settings** - Language, cache, about, help

## 🛠️ Technologies

- **Flutter & Dart** - Cross-platform development
- **Firebase** - Authentication, Firestore, Storage
- **Provider** - State management
- **Hive** - Local database
- **Dio** - File downloads
- **Video Player & PDF Viewer** - Media playback

## 🎨 Design System

- **Primary Color**: #4CAF50 (Green)
- **Accent Color**: #FFC107 (Amber)
- **Background**: #E3F2FD (Light Blue)
- **Font**: Poppins

## 📦 Building

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

## 📝 Documentation

- [Setup Guide](SETUP_GUIDE.md) - Complete installation guide
- [Firebase Setup](FIREBASE_SETUP.md) - Firebase configuration
- [Requirements](requirements.md) - Project requirements

## 📞 Support

- **Email**: faithjudith03@gmail.com
- **Phone**: +254 733 331 039

## 📄 License

© 2025 ElimuApp. All rights reserved.

---

**Made with ❤️ for students in rural areas**
