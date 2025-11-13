# SHA Keys for Firebase Configuration

## 🔑 Debug SHA Keys (Generated)

### SHA-1 (Debug)
```
15:99:5B:36:81:96:DA:F5:ED:4F:6A:9B:A2:B8:9F:A1:3C:B3:3F:2A
```

### SHA-256 (Debug)
```
F5:F6:8F:19:1F:24:AB:2A:2F:FC:1D:D1:31:65:BC:29:91:21:CF:42:BB:65:6D:0B:DE:52:C5:F3:45:2E:9B:7C
```

## 📝 How to Add SHA Keys to Firebase

### Step 1: Go to Firebase Console
1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **elimu-d3b0c**

### Step 2: Navigate to Project Settings
1. Click the **gear icon** (⚙️) next to "Project Overview"
2. Select **Project settings**

### Step 3: Add SHA Keys
1. Scroll down to **Your apps** section
2. Find your Android app: `com.fj.elimu`
3. Click **Add fingerprint** button
4. Paste the **SHA-1** key: `15:99:5B:36:81:96:DA:F5:ED:4F:6A:9B:A2:B8:9F:A1:3C:B3:3F:2A`
5. Click **Save**
6. Click **Add fingerprint** again
7. Paste the **SHA-256** key: `F5:F6:8F:19:1F:24:AB:2A:2F:FC:1D:D1:31:65:BC:29:91:21:CF:42:BB:65:6D:0B:DE:52:C5:F3:45:2E:9B:7C`
8. Click **Save**

### Step 4: Download Updated google-services.json
1. After adding SHA keys, download the updated `google-services.json`
2. Replace the existing file in `android/app/google-services.json`

### Step 5: Enable Google Sign-In in Firebase
1. Go to **Build** > **Authentication**
2. Click **Get started** (if not already enabled)
3. Click on **Sign-in method** tab
4. Click **Google** provider
5. Click **Enable** toggle
6. Enter support email (your email)
7. Click **Save**

### Step 6: Enable Email/Password Sign-In
1. In the same **Sign-in method** tab
2. Click **Email/Password** provider
3. Click **Enable** toggle
4. Click **Save**

## 🔐 Certificate Information

**Keystore Location**: `C:\Users\FAITH\.android\debug.keystore`  
**Alias**: androiddebugkey  
**Store Password**: android  
**Key Password**: android  

**Valid From**: Thu Nov 06 15:20:51 EAT 2025  
**Valid Until**: Sat Oct 30 15:20:51 EAT 2055  

## 📱 App Configuration

**Package Name**: `com.fj.elimu`  
**Project ID**: `elimu-d3b0c`  
**Project Number**: `74514713263`  
**Storage Bucket**: `elimu-d3b0c.firebasestorage.app`

## ✅ Verification Checklist

After adding SHA keys to Firebase:

- [ ] SHA-1 key added to Firebase Console
- [ ] SHA-256 key added to Firebase Console
- [ ] Google Sign-In enabled in Firebase Authentication
- [ ] Email/Password enabled in Firebase Authentication
- [ ] Updated google-services.json downloaded (if needed)
- [ ] App rebuilt: `flutter clean && flutter pub get`

## 🚀 Testing Authentication

### Test Email/Password Login
1. Run the app: `flutter run`
2. Click **Sign Up** tab
3. Enter email and password
4. Click **Sign Up**
5. Verify account is created in Firebase Console

### Test Google Sign-In
1. Run the app: `flutter run`
2. Click **Sign in with Google** button
3. Select Google account
4. Verify login is successful

## 🐛 Troubleshooting

### Google Sign-In Not Working
- Ensure SHA-1 and SHA-256 are added to Firebase
- Download updated google-services.json
- Run: `flutter clean && flutter pub get`
- Rebuild the app

### "PlatformException" Error
- Check that package name matches: `com.fj.elimu`
- Verify google-services.json is in `android/app/`
- Ensure Firebase is initialized in main.dart

### "API not enabled" Error
- Go to Google Cloud Console
- Enable **Google Sign-In API**
- Wait a few minutes and try again

## 📞 Support

If you encounter any issues:
1. Check Firebase Console for error messages
2. Verify all authentication methods are enabled
3. Ensure SHA keys are correctly added
4. Rebuild the app after any changes

---

**Generated**: November 6, 2025  
**Debug Keystore**: C:\Users\FAITH\.android\debug.keystore

