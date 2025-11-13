# 🚀 ElimuApp - Quick Start Guide

## ⚡ 3-Minute Setup

### Step 1: Add SHA Keys to Firebase (2 minutes)

1. Go to: https://console.firebase.google.com/
2. Select project: **elimu-d3b0c**
3. Click ⚙️ > **Project settings**
4. Scroll to **Your apps** > Find `com.fj.elimu`
5. Click **Add fingerprint** and paste:
   ```
   15:99:5B:36:81:96:DA:F5:ED:4F:6A:9B:A2:B8:9F:A1:3C:B3:3F:2A
   ```
6. Click **Add fingerprint** again and paste:
   ```
   F5:F6:8F:19:1F:24:AB:2A:2F:FC:1D:D1:31:65:BC:29:91:21:CF:42:BB:65:6D:0B:DE:52:C5:F3:45:2E:9B:7C
   ```

### Step 2: Enable Authentication (1 minute)

1. In Firebase Console: **Build** > **Authentication**
2. Click **Sign-in method** tab
3. Enable **Email/Password** ✅
4. Enable **Google** ✅ (enter your email as support email)

### Step 3: Run the App (30 seconds)

```bash
flutter run
```

## 🎯 That's It!

Your app is now ready with:
- ✅ Email/Password login
- ✅ Google Sign-In
- ✅ Firebase authentication

## 📚 Detailed Guides

- **Full Setup**: See `FIREBASE_AUTH_SETUP.md`
- **SHA Keys**: See `SHA_KEYS.md`
- **Firebase Config**: See `FIREBASE_SETUP.md`

## 🐛 Quick Troubleshooting

**Google Sign-In not working?**
- Make sure you added BOTH SHA keys to Firebase
- Run: `flutter clean && flutter pub get`

**Build errors?**
- Enable Developer Mode: `start ms-settings:developers`
- Run: `flutter clean && flutter pub get`

## 📞 Need Help?

Check `FIREBASE_AUTH_SETUP.md` for detailed troubleshooting.

---

**Happy Coding! 🎉**

