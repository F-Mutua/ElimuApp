# Firebase Setup Guide for ElimuApp

This guide will help you set up Firebase for the ElimuApp project.

## Prerequisites

- A Google account
- Flutter SDK installed
- Android Studio or Xcode (for iOS)

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or "Create a project"
3. Enter project name: **ElimuApp**
4. (Optional) Enable Google Analytics
5. Click "Create project"

## Step 2: Register Your Android App

1. In the Firebase Console, click the Android icon to add an Android app
2. Enter the following details:
   - **Android package name**: `com.elimuapp.elimu_app` (or your chosen package name)
   - **App nickname**: ElimuApp Android
   - **Debug signing certificate SHA-1**: (Optional, but recommended for Google Sign-In)
3. Click "Register app"

### Get SHA-1 Certificate (for Google Sign-In)

Run this command in your terminal:

```bash
cd android
./gradlew signingReport
```

Or on Windows:

```bash
cd android
gradlew.bat signingReport
```

Copy the SHA-1 from the debug keystore and paste it in Firebase Console.

## Step 3: Download google-services.json

1. After registering the app, download the `google-services.json` file
2. Place it in the `android/app/` directory of your Flutter project

**File location**: `android/app/google-services.json`

## Step 4: Configure Android Build Files

### 4.1 Project-level build.gradle

File: `android/build.gradle`

Add the Google services classpath:

```gradle
buildscript {
    dependencies {
        // ... other dependencies
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

### 4.2 App-level build.gradle

File: `android/app/build.gradle`

Add at the bottom of the file:

```gradle
apply plugin: 'com.google.gms.google-services'
```

## Step 5: Register Your iOS App (Optional)

1. In the Firebase Console, click the iOS icon to add an iOS app
2. Enter the following details:
   - **iOS bundle ID**: `com.elimuapp.elimuApp` (or your chosen bundle ID)
   - **App nickname**: ElimuApp iOS
3. Click "Register app"
4. Download the `GoogleService-Info.plist` file
5. Place it in the `ios/Runner/` directory

**File location**: `ios/Runner/GoogleService-Info.plist`

## Step 6: Enable Firebase Services

### 6.1 Enable Authentication

1. In Firebase Console, go to **Build** > **Authentication**
2. Click "Get started"
3. Enable the following sign-in methods:
   - **Email/Password**: Enable this
   - **Google**: Enable this (requires SHA-1 certificate)

### 6.2 Enable Cloud Firestore

1. In Firebase Console, go to **Build** > **Firestore Database**
2. Click "Create database"
3. Choose **Start in test mode** (for development)
4. Select a location (choose closest to your target users)
5. Click "Enable"

**Security Rules for Development** (Update before production):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2025, 12, 31);
    }
  }
}
```

**Production Security Rules** (Recommended):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Resources are readable by all authenticated users
    match /resources/{resourceId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
  }
}
```

### 6.3 Enable Firebase Storage (Optional)

1. In Firebase Console, go to **Build** > **Storage**
2. Click "Get started"
3. Choose **Start in test mode**
4. Click "Done"

## Step 7: Create Firestore Collections

Create the following collections in Firestore:

### Collection: `users`

Document structure:
```json
{
  "id": "user_id",
  "email": "user@example.com",
  "name": "User Name",
  "grade": 6,
  "challengingSubjects": ["Math", "Science"],
  "learningPreference": "Visual",
  "hasRegularInternet": false,
  "isFirstTime": false,
  "createdAt": "timestamp"
}
```

### Collection: `resources` (Optional - if storing in Firestore)

Document structure:
```json
{
  "id": "resource_id",
  "title": "Resource Title",
  "subject": "Math",
  "type": "textbook",
  "url": "https://example.com/resource.pdf",
  "thumbnailUrl": null,
  "grade": 6,
  "fileSize": 5242880,
  "description": "Resource description"
}
```

## Step 8: Test Firebase Connection

Run your Flutter app:

```bash
flutter run
```

Check the console for any Firebase initialization errors.

## Step 9: Configure Google Sign-In (Android)

1. In Firebase Console, go to **Authentication** > **Sign-in method**
2. Click on **Google**
3. Enable it
4. Add your support email
5. Download the updated `google-services.json` file
6. Replace the old file in `android/app/`

## Troubleshooting

### Common Issues

1. **"google-services.json not found"**
   - Ensure the file is in `android/app/` directory
   - Run `flutter clean` and `flutter pub get`

2. **"Default FirebaseApp is not initialized"**
   - Make sure `Firebase.initializeApp()` is called in `main.dart`
   - Check that google-services.json is properly configured

3. **Google Sign-In not working**
   - Verify SHA-1 certificate is added in Firebase Console
   - Ensure Google Sign-In is enabled in Authentication
   - Download the updated google-services.json after adding SHA-1

4. **Build errors**
   - Run `flutter clean`
   - Delete `android/.gradle` folder
   - Run `flutter pub get`
   - Rebuild the app

## Security Considerations

⚠️ **Important**: Before deploying to production:

1. Update Firestore security rules to restrict access
2. Enable App Check to prevent abuse
3. Set up proper authentication rules
4. Use environment variables for sensitive data
5. Enable Firebase Analytics for monitoring

## Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)

## Support

If you encounter any issues, please contact the development team or refer to the Firebase documentation.

---

**Last Updated**: 2025-11-06

