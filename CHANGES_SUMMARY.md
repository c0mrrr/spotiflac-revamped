# SpotiFLAC Mobile - Recent Changes Summary

## 1. Environment & Setup
* **Flutter SDK**: Successfully installed and configured Flutter for Android development.
* **Java Development Kit**: Configured to use JDK 17, preventing fallback conflicts with JDK 25.

## 2. Lyrics Functionality
* **Copy Options**: Added support to copy different formats of lyrics directly from the Now Playing screen.
  * Added `Copy Plain Lyrics` button.
  * Added `Copy Time-Synced Lyrics` button.
  * Added `Copy Word-by-Word Synced Lyrics` button (only visible if word-synced lyrics are available).

## 3. Real-Time Terminal Logs
* **Logs Tab**: Created a new `LogsTab` (`lib/screens/logs_tab.dart`) integrated into the main `MainShell` bottom navigation bar.
* **Design**: Styled exactly like a terminal with a monospace font, while maintaining the app's overall Material You design language.
* **Verbosity**: It displays live, verbose logs of all background processes (downloading, metadata fetching, extraction speed, etc.) by polling the Go-side logs via `LogBuffer`.

## 4. Fluid Animated Lyrics
* **Apple Music Style**: Re-wrote the `_SyncedLyricsViewState` inside `now_playing_screen.dart` to support smooth, fluid lyric animations.
* **Synchronization**: Transitioned from a generic playback state provider to using a direct `AudioService.position.listen` stream subscription. This ensures sub-second, frame-accurate synchronization without blocking the main UI thread.
* **Micro-Animations**: Implemented `Color.lerp` and `easeOutCubic` animations to smoothly scale and highlight words one-by-word as they are sung.

## 5. Animated Artwork Background
* **New Setting**: Added a new `Animated Artwork Background` switch inside the Appearance Settings (located under the Dynamic Color option).
* **State Management**: Updated `ThemeSettings` and `ThemeProvider` to persist the new `useArtworkBackground` boolean flag.
* **Visual Effect**: Designed an `_AnimatedArtworkBackground` widget inside `now_playing_screen.dart`. When enabled, it:
  1. Grabs the high-resolution album artwork for the currently playing song.
  2. Creates two massive, scaled-up copies of the artwork.
  3. Slowly rotates and scales the copies in opposite directions.
  4. Applies a heavy Gaussian Blur (`ImageFilter.blur` with high sigma) and a semi-transparent surface overlay.
* **Result**: Creates a beautiful, dynamic, slowly moving background of blended colors extracted precisely from the song's cover art, without any visible image artifacts or "stains".
