# 👥 GHUsers

GHUsers is a lightweight, modern GitHub user browser built with UIKit, MVVM-C, Core Data, Combine, and async/await. It supports offline caching, infinite scroll, and real-time user detail updates with zero 3rd party dependencies.

---

## 🚀 Features

- ✅ Browse all GitHub users
- ✅ View detailed user information (followers, following, blog link, etc.)
- ✅ Infinite scroll with pagination
- ✅ Offline-first experience (cached data shown immediately on app relaunch)
- ✅ Unit tested core logic
- ✅ UI testing with simulated user interactions

---

## 🛠️ Tech Stack

- **UIKit**: For the UI
- **MVVM-C**: Clean separation of concerns with coordinator pattern
- **Combine**: Reactive state updates and bindings
- **Core Data**: Local storage and efficient fetching with `NSFetchedResultsController`
- **Async/Await**: Modern concurrency for API calls
- **XCTest**: Comprehensive unit & UI test coverage

---

## 🧪 Testing

- ✅ **Unit Tests** cover view models and services
- ✅ **Integration tests** with in-memory Core Data stack
- ✅ **UI Tests** for common user flows

---

## 📦 Folder Structure

```
GHUsers/
├── GHUsers/                     # Main app target
├── GHUsersCore/                 # Business logic and persistence
├── GHUsersCoreTests/            # Unit tests
└── GHUsersUITests/              # UI tests
```

---

## 🔄 Offline Caching

- On first launch, fetches from API and caches in Core Data
- On subsequent launches, loads instantly from Core Data via `NSFetchedResultsController`
- New users fetched via pagination are appended and stored

---

## 📸 Showcase

[GHUsers Demo](https://drive.google.com/file/d/16eAD3vWOFe4-vEvRTAE3Id2G4H6W_fFh/view?usp=sharing)

---

## 🚀 Getting Started

1. Clone the repo:
   ```bash
   git clone https://github.com/quangthai206/GHUsers
   cd GHUsers
   ```

2. Open `GHUsers.xcodeproj` in Xcode

3. Run the app on simulator or device

4. Run tests with ⌘U

---

## 🛠 Requirements

- iOS 16.0+
- Xcode 15+
- Swift 5+

---

## 📄 License

MIT License

---

## 📬 Contact

If you have any questions or feedback, feel free to reach out via GitHub Issues.
