# Mannin Suvai — Setup Guide (Hostinger)

## How It Works

```
Hostinger Server (PHP files)
   ├── api.php               ← reads / saves products.json
   └── send_notification.php ← sends FCM push notifications
           ↑ admin saves / sends
       Flutter App (Admin)
           ↓ loads products
       Flutter App (Users)
           ↓ places order → WhatsApp
           ↓ receives notifications ← Firebase FCM
```

---

## Step 1 — Upload Server Files to Hostinger

1. Login to **Hostinger → cPanel → File Manager**.
2. Navigate to `public_html` (or create a subfolder like `public_html/manninsuvai/`).
3. Upload these three files from the `server/` folder:
   - `api.php`
   - `products.json`
   - `send_notification.php`
4. Open `api.php` in the editor → find this line:
   ```php
   $SECRET_KEY = 'CHANGE_THIS_TO_A_RANDOM_SECRET';
   ```
   Change it to any password you choose (e.g. `mango2024secret`).
5. Open `send_notification.php` → set the **same** `$SECRET_KEY`.

Your API URL will be: `https://yourdomain.com/api.php`

In the app → Admin → Settings:
| Field | Value |
|---|---|
| Use JSONBin headers | **OFF** |
| Read URL | `https://yourdomain.com/api.php` |
| Write URL | `https://yourdomain.com/api.php` |
| API Key | `mango2024secret` (whatever you set) |

---

## Step 2 — Upload Initial Products

After configuring the server URL and API key:

1. Open the app → tap the **🌾 logo 7 times** on the About screen.
2. Enter PIN: **1234** (default).
3. Go to **Settings** → enter the server URLs and API key → tap **Save Settings**.
4. Tap **"Upload Default Products to Server"** — this seeds your server with all 25 products.

---

## Step 3 — Set Up Push Notifications (Firebase FCM)

Push notifications use **Firebase Cloud Messaging (FCM)** — free, private, and run through Google. No user data is shared with any third party.

### How it works
```
User installs app → silently subscribes to topic "manninsuvai_updates"
Admin opens Admin → Notifications → types message → taps Send
App POSTs to send_notification.php on Hostinger
PHP uses service account to call Google's FCM API
FCM delivers notification to ALL users' phones — even if app is closed
```

### 3a — Create Firebase Project

1. Go to [console.firebase.google.com](https://console.firebase.google.com) → **Add project**.
2. Give it any name (e.g. "manninsuvai") → continue → **Create project**.
3. In the project dashboard, click the **Android icon** to add an Android app.
4. Package name: `com.manninsuvai.app` → Register app.
5. **Download `google-services.json`** → save it.
6. Skip the remaining wizard steps.

### 3b — Place google-services.json in the App

Replace the placeholder file:
```
android/app/google-services.json   ← replace with the one you downloaded
```

Then regenerate `lib/firebase_options.dart`:
```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR-FIREBASE-PROJECT-ID
```
Select Android (and Web if needed) when prompted. This overwrites `lib/firebase_options.dart` with your real values.

### 3c — Get Service Account for the Server

1. In Firebase Console → **Project Settings** (gear icon).
2. Click the **"Service accounts"** tab.
3. Click **"Generate new private key"** → confirm → download the JSON file.
4. **Rename** the file to: `firebase-service-account.json`
5. **Upload** it to Hostinger in the same folder as `api.php`.

> **Keep this file private.** Never share it or commit it to Git.
> It gives admin-level access to send notifications from your Firebase project.

### 3d — Test It

1. Install the app on a real Android device.
2. Open the app once (it subscribes to the topic automatically).
3. In Admin → Send Notification → type a title and message → tap **Send**.
4. You should receive the notification within a few seconds.

---

## Step 4 — Build the App

```bash
# Install dependencies
flutter pub get

# Run on Android device / emulator
flutter run

# Run on Chrome (web)
flutter run -d chrome

# Build Android APK
flutter build apk --release

# Build Android App Bundle (Play Store)
flutter build appbundle --release

# Build Web
flutter build web --release
```

---

## Using the Admin Panel

**How to open:** Tap the **🌾 logo 7 times** on the About screen.

**Default PIN:** `1234` (change it in Admin → Settings).

### What admin can do:
| Action | How |
|---|---|
| Add product | Dashboard → FAB **+** button |
| Edit product | Tap ✏️ on any product |
| Toggle stock | Tap ✅/❌ on any product (instant) |
| Set discount | Edit product → each variant has a Discount % field |
| Delete product | Tap 🗑️ → confirm |
| Save to server | **"Save to Server"** button (saves ALL changes at once) |
| Send notification | Dashboard → 🔔 bell icon |
| Change PIN / API keys | Dashboard → ⚙️ gear icon |

> **Important:** Changes to products are local until you press **"Save to Server"**.
> After saving, all users get the updated products on next app start.

---

## Folder Structure

```
manninsuvai/
├── lib/
│   ├── main.dart
│   ├── firebase_options.dart       # Replace with real values (flutterfire configure)
│   ├── config/app_config.dart
│   ├── models/product.dart
│   ├── services/
│   │   ├── product_service.dart
│   │   └── notification_service.dart
│   ├── providers/
│   │   ├── products_provider.dart
│   │   └── cart_provider.dart
│   ├── screens/ ...
│   └── widgets/ ...
├── android/
│   └── app/
│       └── google-services.json   # Replace with your real Firebase file
├── server/
│   ├── api.php                    # Upload to Hostinger
│   ├── send_notification.php      # Upload to Hostinger
│   ├── products.json              # Upload to Hostinger (initial data)
│   └── firebase-service-account.json  # Download from Firebase → upload to Hostinger (DO NOT commit to Git)
└── SETUP.md
```

---

## Contact

- **WhatsApp:** 8754077890 / 9994846501
- **Email:** manninsuvai25@gmail.com
- **Instagram:** @manninsuvai25
- **FSSAI:** 22426379000200 (Valid: 12-03-2031)

---

## Appendix: Using JSONBin.io (No Server Option)

If you do **not** have your own hosting, you can use [JSONBin.io](https://jsonbin.io) (free) to store product data in the cloud. Note: push notifications still require a PHP server for `send_notification.php`.

1. Create a free account at jsonbin.io.
2. Click **Create a New Bin** → paste contents of `server/products.json` → save.
3. Copy your **Bin ID** from the URL.
4. Copy your **Master Key** from API Keys.

In Admin Settings:
| Field | Value |
|---|---|
| Use JSONBin headers | **ON** |
| Read URL | `https://api.jsonbin.io/v3/b/YOUR_BIN_ID/latest` |
| Write URL | `https://api.jsonbin.io/v3/b/YOUR_BIN_ID` |
| API Key | Your Master Key |
