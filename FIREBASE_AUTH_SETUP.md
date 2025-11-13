# 🔐 Firebase Authentication Setup Guide

## ✅ Current Status

Your ElimuApp is now configured with:
- ✅ Firebase initialized
- ✅ Email/Password authentication ready
- ✅ Google Sign-In ready
- ✅ SHA-1 and SHA-256 keys generated
- ✅ Package name: `com.fj.elimu`
- ✅ google-services.json configured

## 🔑 Your SHA Keys

### SHA-1 (Debug)
```
15:99:5B:36:81:96:DA:F5:ED:4F:6A:9B:A2:B8:9F:A1:3C:B3:3F:2A
```

### SHA-256 (Debug)
```
F5:F6:8F:19:1F:24:AB:2A:2F:FC:1D:D1:31:65:BC:29:91:21:CF:42:BB:65:6D:0B:DE:52:C5:F3:45:2E:9B:7C
```

## 📋 Step-by-Step Firebase Console Setup

### Step 1: Add SHA Keys to Firebase

1. **Open Firebase Console**
   - Go to: https://console.firebase.google.com/
   - Select project: **elimu-d3b0c**

2. **Navigate to Project Settings**
   - Click the ⚙️ gear icon next to "Project Overview"
   - Click **Project settings**

3. **Scroll to "Your apps" section**
   - Find your Android app: `com.fj.elimu`

4. **Add SHA-1 Fingerprint**
   - Click **Add fingerprint** button
   - Paste: `15:99:5B:36:81:96:DA:F5:ED:4F:6A:9B:A2:B8:9F:A1:3C:B3:3F:2A`
   - Click **Save**

5. **Add SHA-256 Fingerprint**
   - Click **Add fingerprint** button again
   - Paste: `F5:F6:8F:19:1F:24:AB:2A:2F:FC:1D:D1:31:65:BC:29:91:21:CF:42:BB:65:6D:0B:DE:52:C5:F3:45:2E:9B:7C`
   - Click **Save**

### Step 2: Enable Authentication Methods

1. **Go to Authentication**
   - In Firebase Console, click **Build** > **Authentication**
   - Click **Get started** (if not already enabled)

2. **Enable Email/Password**
   - Click **Sign-in method** tab
   - Click **Email/Password**
   - Toggle **Enable** ON
   - Click **Save**

3. **Enable Google Sign-In**
   - Still in **Sign-in method** tab
   - Click **Google**
   - Toggle **Enable** ON
   - Enter **Project support email**: (your email address)
   - Click **Save**

### Step 3: Set Up Firestore Database (Optional but Recommended)

1. **Create Firestore Database**
   - Click **Build** > **Firestore Database**
   - Click **Create database**
   - Select **Start in test mode** (for development)
   - Choose your region (closest to your users)
   - Click **Enable**

2. **Security Rules (Test Mode)**
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if request.time < timestamp.date(2025, 12, 31);
       }
     }
   }
   ```

### Step 4: Download Updated google-services.json (If Needed)

1. **Download Configuration File**
   - In Project Settings > Your apps
   - Click **Download google-services.json**
   - Replace the file in: `android/app/google-services.json`

## 🚀 Running the App

### Prerequisites Check

1. **Enable Developer Mode (Windows)**
   ```powershell
   start ms-settings:developers
   ```
   - Toggle **Developer Mode** ON
   - This enables symlink support for Flutter

2. **Connect Android Device or Start Emulator**
   - **Physical Device**: Enable USB Debugging
   - **Emulator**: Start from Android Studio AVD Manager

3. **Verify Device Connection**
   ```bash
   flutter devices
   ```

### Build and Run

1. **Clean Build**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Run the App**
   ```bash
   flutter run
   ```

3. **Or Run in Release Mode**
   ```bash
   flutter run --release
   ```

## 🧪 Testing Authentication

### Test Email/Password Authentication

1. **Sign Up New User**
   - Launch the app
   - You'll see the Auth Screen
   - Click **Sign Up** tab
   - Enter email: `test@example.com`
   - Enter password: `Test123!`
   - Click **Sign Up** button

2. **Verify in Firebase Console**
   - Go to Firebase Console > Authentication > Users
   - You should see the new user listed

3. **Sign In**
   - Sign out from the app
   - Click **Login** tab
   - Enter same credentials
   - Click **Login** button

### Test Google Sign-In

1. **Click Google Sign-In Button**
   - On Auth Screen, click **Sign in with Google**
   - Select your Google account
   - Grant permissions

2. **Verify Success**
   - You should be redirected to Survey Screen (first time)
   - Or Home Screen (returning user)

3. **Check Firebase Console**
   - Go to Authentication > Users
   - You should see the Google user listed

## 🎨 App Features

### Authentication Screen Features
- ✅ Email/Password Login
- ✅ Email/Password Sign Up
- ✅ Google Sign-In
- ✅ Guest Mode (Continue without login)
- ✅ Password visibility toggle
- ✅ Form validation
- ✅ Error handling with user-friendly messages

### After Authentication
- **First-time users**: Redirected to Survey Screen
- **Returning users**: Redirected to Home Screen
- **Guest users**: Limited access to features

## 🐛 Troubleshooting

### Issue: "Default FirebaseApp is not initialized"

**Solution:**
- Ensure `google-services.json` is in `android/app/`
- Run: `flutter clean && flutter pub get`
- Rebuild the app

### Issue: "PlatformException: sign_in_failed"

**Solution:**
- Verify SHA-1 and SHA-256 are added to Firebase Console
- Download updated `google-services.json`
- Ensure Google Sign-In is enabled in Firebase Authentication
- Run: `flutter clean && flutter pub get`

### Issue: "API not enabled"

**Solution:**
- Go to Google Cloud Console
- Enable **Google Sign-In API**
- Wait 5-10 minutes for propagation
- Try again

### Issue: "Email already in use"

**Solution:**
- This is expected if you try to sign up with an existing email
- Use the Login tab instead
- Or use a different email address

### Issue: "Weak password"

**Solution:**
- Firebase requires passwords to be at least 6 characters
- Use a stronger password (e.g., `Test123!`)

### Issue: "Invalid email"

**Solution:**
- Ensure email format is correct (e.g., `user@example.com`)
- Check for extra spaces

## 📱 App Configuration Details

**Package Name**: `com.fj.elimu`  
**Project ID**: `elimu-d3b0c`  
**Project Number**: `74514713263`  
**Storage Bucket**: `elimu-d3b0c.firebasestorage.app`  
**Minimum SDK**: API 23 (Android 6.0)  
**Target SDK**: Latest  

## 🔐 Security Notes

### For Development
- Test mode Firestore rules are open (expires Dec 31, 2025)
- Debug keystore is used (not secure for production)

### For Production
1. **Update Firestore Rules**
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       match /resources/{resourceId} {
         allow read: if request.auth != null;
         allow write: if false; // Only admins can write
       }
     }
   }
   ```

2. **Generate Release Keystore**
   ```bash
   keytool -genkey -v -keystore release.keystore -alias release -keyalg RSA -keysize 2048 -validity 10000
   ```

3. **Get Release SHA Keys**
   ```bash
   keytool -list -v -keystore release.keystore -alias release
   ```

4. **Add Release SHA Keys to Firebase**

## 📞 Support

If you encounter issues:
1. Check Firebase Console for error messages
2. Review logs: `flutter run --verbose`
3. Verify all steps are completed
4. Check internet connection

## ✅ Final Checklist

Before running the app, ensure:

- [ ] SHA-1 key added to Firebase Console
- [ ] SHA-256 key added to Firebase Console
- [ ] Email/Password enabled in Firebase Authentication
- [ ] Google Sign-In enabled in Firebase Authentication
- [ ] google-services.json is in `android/app/`
- [ ] Developer Mode enabled on Windows
- [ ] Device/Emulator connected
- [ ] `flutter pub get` completed successfully

## 🎉 You're Ready!

Once all steps are complete, run:

```bash
flutter run
```

Your ElimuApp with Firebase Authentication is ready to use! 🚀

---

**Generated**: November 6, 2025  
**App Version**: 1.0.0  
**Firebase Project**: elimu-d3b0c

