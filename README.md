# NGiE VAS — Client Mobile App (Flutter)

Android app for VAS platform clients: login, dashboard, create & track
campaigns (Bulk SMS / WhatsApp / IVR), wallet balance, self-recharge via
Razorpay, and transaction history. Talks to the Laravel backend over its
token-authenticated REST API (`/api`).

## What's included
- `lib/` — the full app source (models, API client, auth state, screens, widgets)
- `pubspec.yaml` — dependencies
- Brand theme (navy / teal / gold), Material 3

Screens: Login · Dashboard · Campaigns (list + create + detail) · Wallet.

## Prerequisites
- Flutter SDK 3.19+ (Dart 3.3+)
- Android Studio / Android SDK
- The Laravel backend deployed and reachable (its `/api` routes)

## Setup & build

```bash
# 1. Generate the Android/iOS platform folders (kept out of this ZIP on purpose)
flutter create . --org in.ngie --project-name ngie_vas_app

# 2. Get packages
flutter pub get

# 3. Point the app at your backend:
#    edit lib/config.dart -> AppConfig.apiBaseUrl
#    e.g. https://vas.ngie.in/api   (emulator local: http://10.0.2.2:8000/api)

# 4. Run on a device/emulator
flutter run

# 5. Build the release APK
flutter build apk --release
# output: build/app/outputs/flutter-apk/app-release.apk
```

## Required Android config (after `flutter create .`)
1. **Internet permission** — add to `android/app/src/main/AndroidManifest.xml`
   inside `<manifest>`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```
2. **minSdkVersion** — Razorpay needs 19+. In `android/app/build.gradle`:
   ```
   minSdkVersion 21
   ```
3. **Razorpay ProGuard** (release builds) — add to `android/app/proguard-rules.pro`:
   ```
   -keep class com.razorpay.** {*;}
   -keepattributes *Annotation*
   ```

## Login (demo, from backend seeder)
- `client@demo.in` / `password`

## How payment works
The app creates a Razorpay order via `POST /api/wallet/recharge`, opens the
Razorpay checkout, and on success the **backend webhook** verifies the signature
and credits the wallet. The app just refreshes the balance — it never credits
the wallet itself (secure by design).

## Notes / honest scope
- This is the client app source; **build the APK with `flutter build apk` on your
  machine** (Flutter SDK required — not compiled in delivery).
- An **admin app** is not included; admin work is done from the web panel.
- WhatsApp/IVR sending depends on the aggregator keys configured in the web
  Admin > Website Settings.

— Nextgen Infotech Enterprises (NGiE), Lucknow
