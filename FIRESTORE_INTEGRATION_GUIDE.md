# 🔥 Firestore Integration Guide

## Overview

ElimuApp now integrates with Cloud Firestore to store and retrieve educational resources. The app uses a **hybrid approach**:
- **Primary**: Fetch resources from Firestore (cloud)
- **Fallback**: Load from local JSON files if Firestore is unavailable

This ensures the app works both online and offline.

---

## 📊 Firestore Database Structure

### Collections

#### 1. **`resources`** Collection
Stores all educational resources (textbooks, notes, PDFs, videos)

**Document Structure:**
```json
{
  "id": "auto-generated-id",
  "title": "Mathematics Textbook",
  "subject": "Mathematics",
  "type": "textbook",  // textbook | note | pdf | video
  "url": "https://storage.googleapis.com/...",
  "thumbnailUrl": "https://storage.googleapis.com/...",
  "grade": "6",  // 6 | 7 | 8 | 9
  "fileSize": 5242880,  // in bytes
  "description": "Grade 6 Mathematics textbook covering algebra and geometry"
}
```

**Indexes Required:**
- `grade` (Ascending) + `subject` (Ascending)
- `grade` (Ascending) + `type` (Ascending) + `subject` (Ascending)

#### 2. **`users`** Collection
Stores user profile data

**Document Structure:**
```json
{
  "id": "user-uid",
  "email": "student@example.com",
  "name": "John Doe",
  "grade": "7",
  "challengingSubjects": ["Mathematics", "Science"],
  "learningPreference": "videos",  // reading | videos | both
  "hasRegularInternet": false,
  "isFirstTime": false
}
```

**Subcollections:**

##### `users/{userId}/progress`
Tracks user progress on resources
```json
{
  "resourceId": "resource-id",
  "progress": 0.75,  // 0.0 to 1.0
  "lastAccessed": "2025-11-12T10:30:00Z"
}
```

##### `users/{userId}/downloads`
Tracks user downloads
```json
{
  "resourceId": "resource-id",
  "downloadedAt": "2025-11-12T10:30:00Z"
}
```

---

## 🚀 Setup Instructions

### Step 1: Enable Firestore in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **elimu-d3b0c**
3. Click **Build** > **Firestore Database**
4. Click **Create database**
5. Choose **Start in test mode** (for development)
6. Select a location (choose closest to your users, e.g., `us-central1`)
7. Click **Enable**

### Step 2: Configure Firestore Security Rules

In Firebase Console > Firestore Database > Rules, paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Resources collection - read-only for all users
    match /resources/{resourceId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
    
    // Users collection - users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // User progress subcollection
      match /progress/{progressId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      // User downloads subcollection
      match /downloads/{downloadId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

Click **Publish** to save the rules.

### Step 3: Create Firestore Indexes

1. Go to **Firestore Database** > **Indexes** tab
2. Click **Create Index**

**Index 1:**
- Collection ID: `resources`
- Fields:
  - `grade` (Ascending)
  - `subject` (Ascending)
- Query scope: Collection
- Click **Create**

**Index 2:**
- Collection ID: `resources`
- Fields:
  - `grade` (Ascending)
  - `type` (Ascending)
  - `subject` (Ascending)
- Query scope: Collection
- Click **Create**

Wait for indexes to build (usually 1-2 minutes).

### Step 4: Upload Initial Data to Firestore

You have two options:

#### Option A: Using the App (Recommended for Testing)

1. Run the app
2. Go to **Settings** screen
3. Scroll down to **Developer Options**
4. Tap **Upload Data to Firestore**
5. Wait for confirmation message
6. Verify in Firebase Console > Firestore Database

#### Option B: Manual Upload via Firebase Console

1. Go to Firestore Database
2. Click **Start collection**
3. Collection ID: `resources`
4. Add documents manually using the JSON structure above

---

## 🔧 How It Works

### Resource Loading Flow

```
1. User opens Category Screen
   ↓
2. App tries to fetch from Firestore
   ↓
3a. SUCCESS → Display Firestore data
   ↓
3b. FAILURE → Fallback to local JSON
   ↓
4. Check which resources are downloaded locally
   ↓
5. Display resources with download status
```

### Code Implementation

**FirebaseService** (`lib/services/firebase_service.dart`):
- `getResourcesByGrade(grade)` - Fetch all resources for a grade
- `getResourcesByGradeAndType(grade, type)` - Filter by type
- `searchResources(query)` - Search resources
- `saveUserProgress(userId, resourceId, progress)` - Track progress
- `saveUserDownload(userId, resourceId)` - Track downloads

**CategoryScreen** (`lib/screens/category_screen.dart`):
- Tries Firestore first
- Falls back to local JSON if Firestore fails
- Merges with local download status

---

## 📱 Testing Firestore Integration

### Test 1: Online Mode (Firestore)

1. Ensure device has internet connection
2. Open the app
3. Navigate to any grade (e.g., Grade 6)
4. Check console logs: Should see "Loaded X resources from Firestore"
5. Resources should display

### Test 2: Offline Mode (Local JSON)

1. Turn off internet connection
2. Open the app
3. Navigate to any grade
4. Check console logs: Should see "Firestore error... Falling back to local JSON"
5. Resources should still display from local JSON

### Test 3: User Progress Tracking

1. Sign in with an account
2. View a resource
3. Check Firestore Console > users > {userId} > progress
4. Should see progress document

### Test 4: Download Tracking

1. Download a resource
2. Check Firestore Console > users > {userId} > downloads
3. Should see download document

---

## 🔍 Monitoring & Debugging

### View Firestore Data

1. Go to Firebase Console
2. Click **Firestore Database**
3. Browse collections: `resources`, `users`
4. Click on documents to view data

### Check Firestore Usage

1. Go to Firebase Console > **Firestore Database** > **Usage** tab
2. Monitor:
   - Document reads
   - Document writes
   - Storage size

### Debug Logs

The app prints helpful logs:
```
✅ Loaded 25 resources from Firestore
❌ Firestore error: [error]. Falling back to local JSON.
✅ Loaded 25 resources from local JSON
```

---

## 💰 Firestore Pricing (Free Tier)

**Spark Plan (Free):**
- 50,000 document reads/day
- 20,000 document writes/day
- 20,000 document deletes/day
- 1 GB storage

**For ElimuApp:**
- ~100 resources total (all grades)
- ~50 users
- Estimated reads: ~500/day
- **Well within free tier!** ✅

---

## 🔐 Security Best Practices

### Production Security Rules

Before going to production, update rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Resources - read-only for authenticated users
    match /resources/{resourceId} {
      allow read: if request.auth != null;
      allow write: if false;  // Only via admin SDK
    }
    
    // Users - strict access control
    match /users/{userId} {
      allow read, write: if request.auth != null 
                         && request.auth.uid == userId;
      
      match /progress/{progressId} {
        allow read, write: if request.auth != null 
                           && request.auth.uid == userId;
      }
      
      match /downloads/{downloadId} {
        allow read, write: if request.auth != null 
                           && request.auth.uid == userId;
      }
    }
  }
}
```

### Data Validation

Add validation to security rules:

```javascript
match /users/{userId} {
  allow create: if request.auth != null 
                && request.auth.uid == userId
                && request.resource.data.keys().hasAll(['email', 'id']);
  
  allow update: if request.auth != null 
                && request.auth.uid == userId
                && request.resource.data.id == userId;
}
```

---

## 🎯 Next Steps

1. ✅ Enable Firestore in Firebase Console
2. ✅ Set up security rules
3. ✅ Create indexes
4. ✅ Upload initial data
5. ✅ Test online/offline modes
6. 🔄 Add more resources via Firebase Console
7. 🔄 Monitor usage and performance
8. 🔄 Update security rules for production

---

## 📚 Additional Resources

- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Security Rules Guide](https://firebase.google.com/docs/firestore/security/get-started)
- [Firestore Pricing](https://firebase.google.com/pricing)
- [Best Practices](https://firebase.google.com/docs/firestore/best-practices)

---

**Status**: ✅ Firestore Integration Complete  
**Last Updated**: November 12, 2025  
**Version**: 1.0.0

