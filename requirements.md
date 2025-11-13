TASK:

Create a fully functional mobile app called ElimuApp, designed for rural primary school students in Grades 6, 7, 8, and 9. The app must display textbooks, notes, PDFs, and videos, allow downloads for offline use, and include footer navigation icons linking to different sections. The app must be built completely — including interface, authentication, data handling, survey, downloads, and navigation — without the user having to code anything manually.

🏫 APP PURPOSE

ElimuApp aims to provide affordable, offline-accessible educational resources to rural primary school students. The goal is to bridge the learning gap by providing curriculum-aligned textbooks, notes, PDFs, and videos accessible anytime, even without an internet connection.

⚙️ TECHNICAL REQUIREMENTS

Framework: Flutter (Dart)
Backend: Firebase (for cloud sync, uploads & authentication) + local storage (Hive or SharedPreferences for offline data)
Supported Platforms: Android (main), iOS (optional)
Minimum SDK: Android 6.0 (API 23)
Local Storage: Allow saving files (PDFs, videos, notes) for offline access
Video Player: video_player or chewie
PDF Reader: flutter_pdfview or advance_pdf_viewer
File Downloader: dio + path_provider
Offline Management: Cache resources in device storage and sync when online
State Management: Provider or Riverpod

Folder Structure:
lib/
├── main.dart
├── screens/
│   ├── splash_screen.dart
│   ├── auth_screen.dart
│   ├── survey_screen.dart
│   ├── home_screen.dart
│   ├── category_screen.dart
│   ├── downloads_screen.dart
│   ├── storybook_screen.dart
│   ├── settings_screen.dart
├── widgets/
│   ├── footer_nav.dart
│   ├── grade_button.dart
│   ├── resource_card.dart
├── models/
│   ├── resource_model.dart
├── services/
│   ├── download_service.dart
│   ├── firebase_service.dart
│   ├── offline_service.dart
├── assets/
│   ├── icons/
│   ├── images/
│   ├── sample_pdfs/
│   ├── sample_videos/
├── data/
│   ├── grade6.json
│   ├── grade7.json
│   ├── grade8.json
│   ├── grade9.json

🎨 UI/UX DESIGN DETAILS

Primary Color: #4CAF50 (Green)
Accent Color: #FFC107 (Amber)
Background: #E3F2FD (Light Blue)
Text Color: #212121 (Dark Gray)
Font: Poppins or Nunito

Style:
Kid-friendly, colorful interface with rounded buttons, large icons, and simple layouts.

📱 APP SCREENS
1️⃣ Splash (Loading) Screen

Light blue background

App logo (Book + Lightbulb) centered

Text below: “Learning Made Easy for Every Child”

Auto transition after 3 seconds

Flow:
After splash screen → Check authentication state

If new user → Go to Authentication Screen

If authenticated but first time → Go to Survey Screen

Otherwise → Redirect to Home Screen

2️⃣ Authentication Screen (New)

Purpose: Simple user registration/login for personalization and saving progress

Firebase Authentication (Email/Password or Google Sign-In)

UI:

App name on top

Input fields: Email, Password

Buttons: “Login” / “Create Account”

Option: “Continue as Guest”

Successful login → Redirect to Survey (if first-time) or Home Screen

3️⃣ First-Time User Survey Screen (New)

Displayed only after first login or guest entry

Purpose: To gather user info for better personalization

Simple questions:

“What grade are you in?” (Dropdown: 6, 7, 8, 9)

“Which subjects do you find most challenging?” (Checkboxes: Math, Science, English, etc.)

“Do you prefer reading, watching videos, or both?” (Radio buttons)

“Do you have regular internet access?” (Yes/No)

Submit button → Saves locally (SharedPreferences) and on Firebase

Redirect → Home Screen

4️⃣ Main Screen (Home Page)

Header: App name ElimuApp + small profile icon
Body: Four large tiles
🎒 Grade 6
📘 Grade 7
📗 Grade 8
📕 Grade 9
Each leads to its respective Category Screen

Footer Navigation:
🏠 Home | ⭐ Offline | 📖 Storybook | ⚙️ Settings

5️⃣ Category Screen

Title: “Grade [X] Learning Hub”

Buttons: Textbooks, Notes, PDFs, Videos, Downloads

Each shows list of subjects/resources with download/view options

6️⃣ Offline Downloads Screen

Shows all saved files (PDFs, notes, videos)

Tapping opens resource

Option to delete

Empty state if none

7️⃣ Storybook Corner Screen

Colorful thumbnails of storybooks

Reading + optional audio

Offline access

8️⃣ Settings Screen

Change language (English/Swahili)

Check for updates

About (“ElimuApp v1.0 – Made for learners everywhere”)

Help/Contact info

📤 UPLOAD SYSTEM

Structured Firebase/JSON data per grade:

{
  "textbooks": [{"title": "Math Book 1", "subject": "Math", "url": "https://..."}],
  "notes": [{"title": "Science Notes", "subject": "Science", "url": "https://..."}],
  "pdfs": [{"title": "Social Studies Revision", "url": "https://..."}],
  "videos": [{"title": "Math Lesson 1", "url": "https://..."}]
}

💾 OFFLINE MODE LOGIC

Save downloads in /elimuapp/downloads/

Cached for offline viewing

Sync updates when online

🔔 USER INTERACTIONS

Progress bar when downloading

Toast: “Downloaded Successfully!”

Offline view message

Persistent footer icons

🧱 ADDITIONAL COMPONENTS

Footer Navigation Widget – 4 icons with route highlighting

Grade Button Widget – Color-coded with ripple

Resource Card Widget – Thumbnail + buttons

🌐 FIREBASE SETUP

Enable Firestore, Storage, and Authentication

Collections: grade6, grade7, grade8, grade9

Store user data and survey responses in users collection

📦 PERMISSIONS

Internet

Storage read/write

Media playback

🧩 ICON SET

Use flutter_icons or font_awesome_flutter
Book → Icons.menu_book
Video → Icons.play_circle_fill
PDF → Icons.picture_as_pdf
Notes → Icons.note
Download → Icons.download
Home → Icons.home
Settings → Icons.settings
Storybook → Icons.auto_stories

📱 APP BEHAVIOR FLOW

Launch app → Splash Screen (3s)

Check if user authenticated

If not → Authentication Screen

If authenticated but first time → Survey Screen

Else → Home Screen

Home → Grade → Category → Resource

Download → View offline

Storybook → Reading fun

Settings → Preferences

🧩 TESTING REQUIREMENTS

Runs on Android 6.0+

Offline viewing functional

Auth flow and survey save correctly

Navigation consistent

Persistent downloads

✅ EXPECTED OUTPUT

AI must generate:

All Dart files

UI layouts

Authentication + Survey logic

Download + Offline system

Firebase integration

JSON data

Functional navigation

Ready-to-build APK

💬 Final Instruction:

Build the entire ElimuApp exactly as described above — including authentication, first-time user survey, downloads, offline system, Firebase, all screens, and footer navigation.
The app must be complete, working, and ready for deployment.