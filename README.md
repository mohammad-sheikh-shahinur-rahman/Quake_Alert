# 🌍 Quake Alert — ভূমিকম্প অ্যালার্ট  
[![GitHub Repo](https://img.shields.io/badge/GitHub-Repo-181717?logo=github&logoColor=white)](https://github.com/mohammad-sheikh-shahinur-rahman/Quake_Alert)
[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?logo=flutter&logoColor=white)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

> A **real-time earthquake alert application** for Bangladesh & surrounding regions — with safety, multilingual support, and critical emergency tools. Built with ❤️ in Flutter.

![Quake Alert Banner](https://github.com/mohammad-sheikh-shahinur-rahman/Quake_Alert/blob/main/Screenshot%202025-12-06%20153503.png?raw=true)

---

## 🌟 About the App

**Quake Alert** delivers timely, accurate earthquake data from USGS, empowering users in high-risk seismic zones with actionable insights. Designed for accessibility and urgency, it features:
- ✅ Real-time alerts
- 🗺️ Interactive map with custom zones
- 🚨 Emergency siren + vibration
- 📚 Safety guides & emergency kit planner
- 🌐 **Fully bilingual: English & Bengali (বাংলা)**

---

## ✨ Key Features

| Feature | Description |
|--------|-------------|
| 🗺️ **Interactive Map** | Powered by `flutter_map` & `latlong2` — shows quakes, your location, tectonic plates, and user-defined alert zones |
| 🔔 **Smart Alerts** | Push notifications for quakes ≥ threshold magnitude *inside your custom zones* |
| 🎯 **Custom Zones** | Draw, edit, and delete circular monitoring zones (persisted via `shared_preferences`) |
| 📋 **Quake Details** | Tap any quake for: magnitude, depth, time, USGS link (`url_launcher`) |
| 📜 **Filterable List** | Sort (time/mag), filter (date/event type), and search globally |
| 🚨 **Emergency Siren** | Full-screen flashing siren + device vibration (`audioplayers` + `vibration`) + emergency contacts |
| 🧰 **Safety Hub** | Before/During/After tips & interactive emergency kit checklist |
| ⚙️ **Smart Settings** | Adjust magnitude threshold, refresh interval, plate visibility, map reset |

---

## 🛠️ Tech Stack

| Category | Packages |
|---------|----------|
| **Core** | `Flutter SDK ≥3.22`, `setState` |
| **Localization** | [`easy_localization`](https://pub.dev/packages/easy_localization) (en/bn) |
| **Notifications** | [`flutter_local_notifications`](https://pub.dev/packages/flutter_local_notifications) |
| **Mapping & Geo** | [`flutter_map`](https://pub.dev/packages/flutter_map), [`latlong2`](https://pub.dev/packages/latlong2), [`geolocator`](https://pub.dev/packages/geolocator) |
| **Media & Haptics** | [`audioplayers`](https://pub.dev/packages/audioplayers), [`vibration`](https://pub.dev/packages/vibration) |
| **Data & Storage** | [`http`](https://pub.dev/packages/http), [`shared_preferences`](https://pub.dev/packages/shared_preferences) |
| **UI/UX** | [`curved_navigation_bar`](https://pub.dev/packages/curved_navigation_bar), [`url_launcher`](https://pub.dev/packages/url_launcher), [`share_plus`](https://pub.dev/packages/share_plus), [`package_info_plus`](https://pub.dev/packages/package_info_plus) |

---

## 🖼️ Screenshots

| Home (Map) | Quake List | Settings & Safety |
|:---:|:---:|:---:|
| ![Home](https://github.com/mohammad-sheikh-shahinur-rahman/Quake_Alert/blob/main/Screenshot%202025-12-06%20153358.png?raw=true) | ![List](https://github.com/mohammad-sheikh-shahinur-rahman/Quake_Alert/blob/main/Screenshot%202025-12-06%20153437.png?raw=true) | ![Safety](https://github.com/mohammad-sheikh-shahinur-rahman/Quake_Alert/blob/main/Screenshot%202025-12-06%20153503.png?raw=true) |

> 📸 *All screenshots from live Android build (v1.0.0)*

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (≥3.22) — [Install Guide](https://flutter.dev/docs/get-started/install)
- Android Studio / VS Code + Flutter plugin

### Installation & Setup

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/mohammad-sheikh-shahinur-rahman/Quake_Alert.git
    cd Quake_Alert
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Run the app:**
    ```sh
    flutter run
    ```
  ## 🤝 Contributing

Contributions are welcome! If you have ideas for new features or find any bugs, feel free to open an issue or submit a pull request.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License  

**MIT License**

Copyright © 2025 **Mohammad Sheikh Shahinur Rahman**

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  
SOFTWARE.

---
*Developed by Mohammad Sheikh Shahinur Rahman*
[shahinurrahman.com](https://shahinurrahman.com/)
  

    
