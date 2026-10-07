# studentsaccomodations

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## CI builds

GitHub Actions runs `flutter analyze`, `flutter test`, and a debug Android APK
build on pushes, pull requests, and manual runs. The APK is uploaded as the
`studentsaccomodations-debug-apk` workflow artifact.

Before the first run, add these repository secrets under **Settings → Secrets
and variables → Actions**:

- `FIREBASE_OPTIONS_DART`: the complete contents of `lib/firebase_options.dart`.
- `GOOGLE_SERVICES_JSON`: the complete contents of
	`android/app/google-services.json`.

These config files are excluded from Git, so the workflow restores them from
secrets. The Android artifact is for testing; publishing to Google Play or
Firebase App Distribution requires a separate release/signing setup.
