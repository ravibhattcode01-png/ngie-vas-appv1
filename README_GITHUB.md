# Building the APK via GitHub Actions

You don't need Flutter installed locally. Push this project to GitHub and the
included workflow (.github/workflows/build-apk.yml) builds the APK for you.

## One-time: create the repo and push

```bash
cd ngie_vas_app

# set the backend URL first (edit lib/config.dart -> AppConfig.apiBaseUrl)
#   'https://telcom.ngie.in/api'

git init
git add .
git commit -m "NGiE VAS client app"
git branch -M main
git remote add origin https://github.com/<your-username>/ngie-vas-app.git
git push -u origin main
```

## Get the APK
1. Open your repo on GitHub → **Actions** tab.
2. The **Build APK** workflow runs automatically on push (or click
   "Run workflow" to trigger manually).
3. When it finishes (green tick), open the run → **Artifacts** →
   download **ngie-vas-apk** → inside is `app-release.apk`.
4. Copy the APK to an Android phone and install (enable "Install from
   unknown sources").

## Notes
- The workflow generates the android/ folder in CI, adds INTERNET permission
  and sets minSdk 21 automatically — nothing to do by hand.
- This APK is signed with the default debug key: perfect for testing/sideloading.
  For a Play Store upload you'll add a release keystore later (separate step).
- If you change code, just `git push` again — a fresh APK builds each time.
