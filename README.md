# Flurrent – Torrent Client for Windows

**Flurrent** is a modern, Fluent UI-powered Windows desktop app built with Flutter, designed to interact with a running [qBittorrent](https://www.qbittorrent.org/) instance via its Web API.

![screenshot](screenshots/main_ui.png)

---

## 🚀 Features

- ✅ **qBittorrent Web API integration**
- 🎯 Add torrents via **magnet links**
- 📄 View detailed torrent info: progress, ETA, ratio, status
- ⏸ Pause / ▶️ Resume / ❌ Delete torrents
- 📊 Group torrents by status (Downloading, Completed)
- 🌗 Light / Dark mode switch (Fluent UI)
- 🔄 Auto-sync every 3 seconds
- 🪟 Native Windows look with **Fluent UI**

---

## 🧰 Built With

- **Flutter** (Windows Desktop)
- [`qbittorrent_api`](https://pub.dev/packages/qbittorrent_api)
- [`fluent_ui`](https://pub.dev/packages/fluent_ui)
- `provider` for state management

---

## 📦 Installation

1. **Clone the repo**

```bash
git clone git@github.com:AmrSabbagh35/torrent-client-flutter-windows.git
cd torrent-client-flutter-windows
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run the app**

```bash
flutter run -d windows
```

> ✅ Make sure `qBittorrent` is running with the Web UI enabled on `http://localhost:8080`.

---

## ⚙️ Configuration

By default, the app connects to:

- **Host:** `localhost`
- **Port:** `8080`
- **Username:** `admin`
- **Password:** `adminadmin`

> You can change this in the service class or expose config options in the UI.

---

## 📸 Screenshots

> Add `screenshots/main_ui.png` and more to show off your interface!

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributions

Feel free to fork the repo and submit pull requests! Ideas and improvements are welcome.

---

## 👨‍💻 Author

Made with 💻 by [Amr Sabbagh](https://github.com/AmrSabbagh35)