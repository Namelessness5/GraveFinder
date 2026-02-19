# 🍂 GraveFinder (扫墓通)

**GraveFinder** is a privacy-first, offline-only Flutter application designed to serve as a digital memorial, family tree mapper, and visual navigation guide. 

It goes beyond traditional family tree software by offering a unique **"Last Mile" (最后一公里)** feature—allowing users to document the exact, step-by-step physical path (via photos and text) to a loved one's resting place, ensuring that memories and locations are never lost across generations.

## ✨ Key Features

* 🗺️ **Infinite Interactive Canvas:** Manually drag, drop, and arrange family members on a boundless canvas to visually represent your family's unique topology.
* 📖 **Rich Memorial Profiles:** Tap on any node to view or edit their profile, including custom avatars, birth/death dates, and life biographies.
* 🔗 **Dynamic Relationship Mapping:** Connect individuals with custom relationship labels (e.g., Parent-Child, Mentor, Spouse) and manage existing connections effortlessly.
* 📍 **"Last Mile" Visual Guide:** A dedicated timeline for each person to record the specific route to their memorial site using step-by-step photos and descriptions (e.g., "Turn left at the old pine tree").
* 🔒 **100% Offline & Privacy-Focused:** No cloud servers, no account required. All data (`map_data.json`) and images are securely stored in the local device's document sandbox.
* 🎨 **Customizable Typography:** Built-in support for elegant, traditional fonts (like Noto Serif SC) and adjustable font sizes to accommodate elderly users and enhance the "genealogy book" aesthetic.
* 🌐 **Bilingual Support:** Seamlessly switch between English and Simplified Chinese.

## 📸 Screenshots

*(Replace these placeholders with your actual app screenshots)*

| Infinite Canvas | Profile Details | "Last Mile" Guide |
| :---: | :---: | :---: |
| `<img src="docs/canvas.png" width="250"/>` | `<img src="docs/profile.png" width="250"/>` | `<img src="docs/last_mile.png" width="250"/>` |

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version 3.10+ recommended)
* Dart SDK

### Installation

1.  Clone the repository:
    ```bash
    git clone [https://github.com/Namelessness5/GraveFinder](https://github.com/Namelessness5/GraveFinder.git)
    cd GraveFinder
    ```

2.  Install dependencies:
    ```bash
    flutter pub get
    ```

3.  Run the app (Desktop or Mobile):
    ```bash
    flutter run
    ```
    *Note: If running on Windows, ensure Windows desktop support is enabled via `flutter config --enable-windows-desktop`.*

## 🛠️ Tech Stack & Architecture

* **Framework:** Flutter
* **Storage:** `path_provider` for secure local directory access. Custom JSON serialization for graph data.
* **Media:** `image_picker` for camera/gallery integration. Images are automatically copied to the app's secure sandbox to prevent broken links.
* **UI/UX:** `InteractiveViewer` for the pan/zoom canvas, `CustomPainter` for relationship lines, and `ReorderableListView` for the step-by-step navigation timeline.
* **Localization:** `flutter_localizations` with `.arb` files.

## Contact
passbyyyyy@gmail.com

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! 
If you have ideas to make this memorial app more meaningful or user-friendly, feel free to open an issue or submit a pull request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
*“For memory and inheritance. A map that leads you back to where you came from.”*