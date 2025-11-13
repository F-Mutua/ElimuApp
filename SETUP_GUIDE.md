# ElimuApp - Complete Setup Guide

Welcome to ElimuApp! This guide will help you set up and run the application.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Firebase Setup](#firebase-setup)
4. [Running the App](#running-the-app)
5. [Project Structure](#project-structure)
6. [Troubleshooting](#troubleshooting)

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (version 3.9.2 or higher)
  - Download from: https://flutter.dev/docs/get-started/install
- **Android Studio** or **VS Code** with Flutter extensions
- **Git** (for version control)
- **Java JDK** (version 11 or higher)
- **Google Account** (for Firebase setup)

### Verify Flutter Installation

Run the following command to check your Flutter installation:

```bash
flutter doctor
```

Ensure all checkmarks are green, especially for:
- Flutter SDK
- Android toolchain
- Android Studio / VS Code
- Connected device or emulator

## Installation

### Step 1: Clone or Download the Project

If you have the project as a ZIP file, extract it. If using Git:

```bash
git clone <repository-url>
cd elimu_app
```

### Step 2: Install Dependencies

Run the following command in the project root directory:

```bash
flutter pub get
```

This will download all the required packages specified in `pubspec.yaml`.

### Step 3: Verify Project Structure

Ensure the following directories exist:
- `lib/` - Contains all Dart code
- `assets/` - Contains images, icons, fonts, and sample files
- `data/` - Contains JSON files for grade resources
- `android/` - Android-specific configuration
- `ios/` - iOS-specific configuration (if building for iOS)

## Firebase Setup

Firebase is required for authentication and cloud storage. Follow these steps:

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: **ElimuApp**
4. Follow the setup wizard

### Step 2: Register Android App

1. In Firebase Console, click the Android icon
2. Enter package name: `com.elimuapp.elimu_app`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

### Step 3: Enable Firebase Services

#### Authentication
1. Go to **Build** > **Authentication**
2. Click "Get started"
3. Enable:
   - Email/Password
   - Google Sign-In

#### Cloud Firestore
1. Go to **Build** > **Firestore Database**
2. Click "Create database"
3. Start in **test mode** (for development)
4. Choose your region

#### Firebase Storage (Optional)
1. Go to **Build** > **Storage**
2. Click "Get started"
3. Start in **test mode**

For detailed Firebase setup instructions, see [FIREBASE_SETUP.md](FIREBASE_SETUP.md).

## Running the App

### Step 1: Connect a Device or Start Emulator

**Physical Device:**
1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Connect via USB
4. Run: `flutter devices` to verify connection

**Emulator:**
1. Open Android Studio
2. Go to AVD Manager
3. Create/Start an Android Virtual Device

### Step 2: Run the App

```bash
flutter run
```

Or for release mode:

```bash
flutter run --release
```

### Step 3: Hot Reload

While the app is running, you can make changes and press:
- `r` - Hot reload (quick refresh)
- `R` - Hot restart (full restart)
- `q` - Quit

## Project Structure

```
elimu_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── resource_model.dart   # Data models
│   ├── screens/
│   │   ├── splash_screen.dart    # Splash screen
│   │   ├── auth_screen.dart      # Login/Signup
│   │   ├── survey_screen.dart    # First-time survey
│   │   ├── home_screen.dart      # Home with grade selection
│   │   ├── category_screen.dart  # Resources by category
│   │   ├── downloads_screen.dart # Offline content
│   │   ├── storybook_screen.dart # Storybooks
│   │   └── settings_screen.dart  # App settings
│   ├── widgets/
│   │   ├── footer_nav.dart       # Bottom navigation
│   │   ├── grade_button.dart     # Grade selection button
│   │   └── resource_card.dart    # Resource display card
│   └── services/
│       ├── firebase_service.dart # Firebase operations
│       ├── offline_service.dart  # Local storage
│       └── download_service.dart # File downloads
├── assets/
│   ├── icons/                    # App icons
│   ├── images/                   # Images
│   ├── fonts/                    # Poppins font
│   ├── sample_pdfs/              # Sample PDF files
│   └── sample_videos/            # Sample video files
├── data/
│   ├── grade6.json               # Grade 6 resources
│   ├── grade7.json               # Grade 7 resources
│   ├── grade8.json               # Grade 8 resources
│   └── grade9.json               # Grade 9 resources
├── android/                      # Android configuration
├── ios/                          # iOS configuration
└── pubspec.yaml                  # Dependencies
```

## Key Features

### 1. Authentication
- Email/Password login
- Google Sign-In
- Guest mode

### 2. Grade Selection
- Grades 6-9 support
- Colorful, kid-friendly UI

### 3. Resource Categories
- Textbooks
- Notes
- PDFs
- Videos

### 4. Offline Access
- Download resources for offline viewing
- Track downloaded files
- Manage storage

### 5. Storybook Corner
- Read engaging stories
- Offline access
- Kid-friendly interface

### 6. Settings
- Language selection (English/Swahili)
- Clear cache
- About information
- Help & Support

## Configuration

### Changing App Name

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:label="Your App Name"
    ...>
```

### Changing Package Name

1. Update `android/app/build.gradle.kts`:
   ```kotlin
   applicationId = "com.yourcompany.yourapp"
   ```

2. Update Firebase configuration with new package name

### Changing App Icon

Replace the following files:
- `android/app/src/main/res/mipmap-*/ic_launcher.png`

Or use a tool like [App Icon Generator](https://appicon.co/)

## Troubleshooting

### Common Issues

#### 1. "google-services.json not found"

**Solution:**
- Ensure `google-services.json` is in `android/app/` directory
- Run `flutter clean` and `flutter pub get`

#### 2. "Default FirebaseApp is not initialized"

**Solution:**
- Check that Firebase is properly configured
- Verify `google-services.json` is correct
- Ensure Firebase is initialized in `main.dart`

#### 3. Build Errors

**Solution:**
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

#### 4. Permission Denied Errors

**Solution:**
- Check that all permissions are in `AndroidManifest.xml`
- For Android 13+, request runtime permissions

#### 5. Download Not Working

**Solution:**
- Check internet connection
- Verify storage permissions
- Ensure URLs in JSON files are valid

#### 6. Google Sign-In Not Working

**Solution:**
- Add SHA-1 certificate to Firebase Console
- Download updated `google-services.json`
- Rebuild the app

### Getting SHA-1 Certificate

```bash
cd android
./gradlew signingReport
```

On Windows:
```bash
cd android
gradlew.bat signingReport
```

Copy the SHA-1 from debug keystore and add it to Firebase Console.

## Development Tips

### Hot Reload
- Use `r` for quick UI changes
- Use `R` for state reset

### Debugging
- Use `print()` statements
- Check Flutter DevTools
- Use breakpoints in IDE

### Testing on Real Device
- Always test on a real device before release
- Test with different Android versions
- Test with limited internet connectivity

### Performance
- Use `flutter run --profile` to check performance
- Monitor memory usage
- Optimize images and assets

## Building for Release

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

## Next Steps

1. **Add Real Content**: Replace sample data in JSON files with actual educational resources
2. **Customize UI**: Adjust colors, fonts, and layouts to match your brand
3. **Add More Features**: Implement additional functionality as needed
4. **Test Thoroughly**: Test on multiple devices and Android versions
5. **Deploy**: Publish to Google Play Store

## Support

For issues or questions:
- Email: support@elimuapp.com
- Documentation: See `FIREBASE_SETUP.md` for Firebase details

## License

© 2025 ElimuApp. All rights reserved.

---

**Happy Coding! 🚀**

