# ✨ SpotiFLAC Revamped

> A revamped, improved version of [SpotiFLAC Mobile](https://github.com/SpotiFLAC/SpotiFLAC-Mobile) — with enhanced features, polished UI, and better performance.

---

## 🎵 What is SpotiFLAC Revamped?

SpotiFLAC Revamped is a feature-rich mobile music client that lets you search, stream previews, and download high-quality audio tracks (FLAC, MP3, M4A) from multiple music platforms — all wrapped in a beautiful Material You interface.

This fork builds on top of the original SpotiFLAC Mobile project with added features, bug fixes, and UI improvements.

---

## 🚀 Features

### 🎶 Core
- **High-Quality Downloads** — FLAC, MP3, and M4A at up to lossless quality
- **Multi-Platform Support** — Search and download from multiple music services via the extension system
- **Smart Download Queue** — Parallel processing with progress tracking, speed display, and retry logic
- **Metadata Embedding** — Automatically embeds cover art, tags, lyrics, and album info into downloaded files

### 🎤 Lyrics
- **Apple Music-Inspired Lyrics UI** — Left-aligned, bold typography with depth-of-field blur on inactive lines
- **Karaoke-Style Word Highlighting** — Smooth, continuous fill animation synced to audio playback
- **Word-Synced & Line-Synced Support** — Handles both TTML and enhanced LRC formats

### 📦 Downloads & Library
- **Downloads Tab** — Dedicated bottom navigation tab showing all active/pending downloads with cover art, title, speed, and progress
- **Download History** — Track completed, failed, and canceled downloads
- **Library Management** — Browse and manage your downloaded music collection
- **SAF Support** — Android Storage Access Framework for flexible download locations

### 🎨 Design & UX
- **Material You** — Dynamic color theming based on your wallpaper
- **Frosted Glass Effects** — Translucent blur effects across the UI (toggleable)
- **AMOLED Dark Mode** — True black theme for OLED displays
- **Artwork Background** — Album art-based ambient background on the now-playing screen
- **Smooth Animations** — Micro-animations on navigation icons, transitions, and lyrics

### ⚙️ Advanced
- **Extension System** — Add new music sources via installable extensions
- **ReplayGain / R128** — Automatic volume normalization for consistent playback
- **Backup & Restore** — Export and import your app settings and library
- **Detailed Logging** — Debug mode for troubleshooting

---

## 🛠️ Building from Source

### Prerequisites
- [Flutter](https://flutter.dev/) (stable channel)
- [Go](https://go.dev/) with [gomobile](https://pkg.go.dev/golang.org/x/mobile/cmd/gomobile) configured
- **Java 17** — Required for Android Gradle builds
  ```
  set JAVA_HOME=C:\path\to\jdk-17
  ```

### Build Steps
```bash
# Clone the repository
git clone https://github.com/c0mrrr/spotiflac-revamped.git
cd spotiflac-revamped

# Get Flutter dependencies
flutter pub get

# Build the APK
flutter build apk --release
```

> **Note:** The Go backend (`go_backend/`) is compiled via gomobile and linked through JNI. Ensure `gomobile` is properly initialized before building.

---

## 📸 Screenshots

*Coming soon*

---

## 🙏 Credits

- **Original Project** — [SpotiFLAC Mobile](https://github.com/SpotiFLAC/SpotiFLAC-Mobile) by the SpotiFLAC team
- **Original Creator** — The original SpotiFLAC desktop application
- **Logo** — Amonoman

---

## 📄 License

This project follows the same license as the original SpotiFLAC Mobile project.
