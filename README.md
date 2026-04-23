<<<<<<< HEAD
# ⬡ Network Engineering Assistant

A professional, cross-platform Flutter application for network design, subnetting calculations, and Cisco IOS configuration generation.

Built for **students**, **network administrators**, and **CCNA/CCNP candidates**.

---

## ✨ Features

| Module | Capabilities |
|---|---|
| **Addressing Tools** | IPv4 subnetting with step-by-step, IPv6 analysis, VLSM calculator |
| **Network Designer** | VLAN planner, Router-on-a-Stick config generator |
| **Routing Assistant** | Static route generator, RIP & OSPF concepts |
| **Network Services** | NAT planner (Static/Dynamic/PAT), ACL builder (Standard/Extended) |
| **Learning Mode** | 10 full networking lessons with Cisco IOS examples |

---

## 📸 Architecture

```
lib/
├── app/              → Navigation, screens, providers (state)
├── core/             → Pure calculation logic (no UI)
│   ├── ipv4_calculator.dart
│   ├── ipv6_calculator.dart
│   ├── vlsm_calculator.dart
│   ├── vlan_calculator.dart
│   └── acl_builder.dart
├── engine/           → Config generation and lesson content
│   ├── config_generator.dart
│   ├── explanation_engine.dart
│   └── router_config_engine.dart
├── models/           → Immutable data types
├── components/       → Reusable UI widgets
└── utils/            → IP math helpers, validators
```

**Key principle:** No calculations happen in the UI layer. All business logic lives in `/core` and `/engine` — fully testable and UI-independent.

---

## 🚀 Running the App (Developers)

### 1. Install Flutter

```bash
# macOS/Linux
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.24.0-stable.zip
unzip flutter_macos_arm64_3.24.0-stable.zip
export PATH="$PWD/flutter/bin:$PATH"

# Or via Homebrew (macOS)
brew install --cask flutter

# Verify
flutter doctor
```

For Windows, download the Flutter SDK from https://docs.flutter.dev/get-started/install

### 2. Clone and run

```bash
git clone https://github.com/YOUR_USERNAME/network-engineering-assistant.git
cd network-engineering-assistant

# Install dependencies
flutter pub get

# Run on connected device or desktop
flutter run                    # auto-detects
flutter run -d macos           # macOS
flutter run -d windows         # Windows
flutter run -d linux           # Linux
flutter run -d android         # Android emulator/device
```

---

## 📦 Building Executables for End Users

### Android APK (direct install)

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android AAB (Google Play Store)

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS IPA (requires macOS + Xcode)

```bash
flutter build ipa --release
# Output: build/ios/archive/Runner.xcarchive
# Then export via Xcode Organizer or:
xcodebuild -exportArchive \
  -archivePath build/ios/archive/Runner.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath build/ios/ipa
```

### Windows EXE

```bash
flutter build windows --release
# Output: build/windows/x64/runner/Release/
# Zip the entire Release/ folder for distribution
```

### macOS App / DMG

```bash
flutter build macos --release
# Output: build/macos/Build/Products/Release/network_engineering_assistant.app

# Create DMG (requires create-dmg):
brew install create-dmg
create-dmg \
  --volname "Network Engineering Assistant" \
  --window-size 600 400 \
  --icon-size 100 \
  --app-drop-link 400 150 \
  "NetworkEngineeringAssistant.dmg" \
  "build/macos/Build/Products/Release/"
```

### Linux AppImage

```bash
flutter build linux --release
# Output: build/linux/x64/release/bundle/

# Wrap with appimagetool:
# https://appimage.github.io/appimagetool/
```

---

## 🌐 Uploading to GitHub

```bash
# 1. Create a new repo on github.com (no README, no .gitignore)

# 2. Initialize and push
cd network-engineering-assistant
git init
git add .
git commit -m "feat: initial release — Network Engineering Assistant"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/network-engineering-assistant.git
git push -u origin main
```

---

## 📱 Distribution for Testing

### Android — Firebase App Distribution / Direct APK
```bash
flutter build apk --release
# Share the APK via email, Drive, or Firebase App Distribution
# Testers: Settings → Install unknown apps → enable
```

### iOS — TestFlight
1. Build IPA in Xcode
2. Upload to App Store Connect
3. Add testers via TestFlight

### Desktop — Direct download
- Windows: ZIP the `Release/` folder
- macOS: Share the `.app` or `.dmg`
- Linux: Share the `bundle/` folder or AppImage

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Language | Dart 3.x |
| State | Provider |
| Navigation | GoRouter |
| Architecture | Clean Architecture |
| Platforms | Android, iOS, Windows, macOS, Linux |

---

## 📚 Networking Topics Covered

- IPv4 Subnetting (CIDR, binary, step-by-step)
- IPv6 Addressing (expansion, compression, types)
- VLSM (Variable Length Subnet Masking)
- VLAN Design (IEEE 802.1Q)
- Router-on-a-Stick (inter-VLAN routing)
- Static Routing (IPv4/IPv6, floating static)
- RIP v2 (concepts, limitations)
- OSPF (link-state, areas, DR/BDR)
- NAT (Static, Dynamic, PAT/Overload)
- ACL (Standard, Extended, named, wildcard masks)

---

## 📄 License

MIT License — free to use, modify, and distribute.
=======
# Network_Enginnering_Assistant
>>>>>>> 6a45f67040659e66cb9e94b9f6d7c47629848759
