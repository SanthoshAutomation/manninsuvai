# Mannin Suvai — Setup Guide

## How It Works

```
Your server (PHP / JSONBin.io)
       ↑ read products
       ↓ save products (admin)
   Flutter App
       ↓ buy order → WhatsApp
       ↓ notifications → OneSignal (free)
```

No database. No SQL. **Pure JSON file on your server.**

---

## Step 1 — Set Up Your JSON Server

### Option A: JSONBin.io (Recommended — free, no server needed)

1. Go to [jsonbin.io](https://jsonbin.io) and create a free account.
2. Click **Create a New Bin**.
3. Paste the contents of `server/products.json` into the editor and save.
4. Copy your **Bin ID** from the URL (looks like `65f3a...`).
5. Go to **API Keys** in the dashboard, copy your **Master Key**.

In the app → Admin Settings:
| Field | Value |
|---|---|
| Use JSONBin headers | ON |
| Read URL | `https://api.jsonbin.io/v3/b/YOUR_BIN_ID/latest` |
| Write URL | `https://api.jsonbin.io/v3/b/YOUR_BIN_ID` |
| API Key | `$2a$10$...` (your Master Key) |

---

### Option B: Your Own Server (Shared Hosting / VPS)

1. Upload `server/api.php` and `server/products.json` to your server (e.g., via cPanel File Manager or FTP).
2. Open `server/api.php` and change the `$SECRET_KEY` to any random string.
3. Note your API URL: `https://yourserver.com/path/api.php`

In the app → Admin Settings:
| Field | Value |
|---|---|
| Use JSONBin headers | OFF |
| Read URL | `https://yourserver.com/path/api.php` |
| Write URL | `https://yourserver.com/path/api.php` |
| API Key | (your `$SECRET_KEY` from api.php) |

---

## Step 2 — Upload Initial Products

After configuring the server URL and API key:

1. Open the app → tap the **🌾 logo 7 times** on the About screen.
2. Enter PIN: **1234** (default).
3. Go to **Settings** → enter the server URLs and API key → tap **Save Settings**.
4. Tap **"Upload Default Products to Server"** — this seeds your server with all 25 products.

---

## Step 3 — Set Up Push Notifications (Optional)

Uses **OneSignal** (free — unlimited push notifications).

1. Go to [onesignal.com](https://onesignal.com) and create a free account.
2. Create a new app → choose **Google Android** and/or **Apple iOS**.
3. Follow the setup wizard. Download the `google-services.json` for Android.
4. From the dashboard → **Settings → Keys & IDs**:
   - Copy **OneSignal App ID**
   - Copy **REST API Key**

In the app → Admin Settings → paste the App ID and REST API Key.

For Android, place `google-services.json` in `android/app/`.

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
│   ├── main.dart               # App entry point
│   ├── config/app_config.dart  # Settings key names
│   ├── models/product.dart     # Product + variant with discount/stock
│   ├── services/
│   │   ├── product_service.dart    # HTTP fetch/save JSON
│   │   └── notification_service.dart # OneSignal bulk push
│   ├── providers/
│   │   ├── products_provider.dart  # Dynamic product state
│   │   └── cart_provider.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── products_screen.dart
│   │   ├── product_detail_screen.dart
│   │   ├── cart_screen.dart
│   │   ├── about_screen.dart       # 7-tap logo → admin gate
│   │   └── admin/
│   │       ├── admin_gate_screen.dart         # PIN entry
│   │       ├── admin_dashboard_screen.dart    # Product list
│   │       ├── admin_product_form_screen.dart # Add/Edit
│   │       ├── admin_send_notification_screen.dart
│   │       └── admin_settings_screen.dart     # Server + OneSignal config
│   └── widgets/
│       ├── product_card.dart  # Shows discount badge + out-of-stock overlay
│       └── category_card.dart
├── server/
│   ├── api.php          # Drop on any PHP hosting
│   └── products.json    # Initial product data
└── SETUP.md             # This file
```

---

## Contact

- **WhatsApp:** 8754077890 / 9994846501
- **Email:** manninsuvai25@gmail.com
- **Instagram:** @manninsuvai25
- **FSSAI:** 22426379000200 (Valid: 12-03-2031)
