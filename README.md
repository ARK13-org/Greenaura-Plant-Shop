# 🌿 GreenAura – Plant Shopping App

**GreenAura** is a Flutter-based mobile application designed to make discovering and shopping for plants simple, enjoyable, and accessible.

With a clean, nature-inspired interface, users can explore different plants, browse categories, view detailed product information, save their favorite plants, and manage their shopping cart.

The Flutter frontend is complete and currently uses simulated data. A **FastAPI backend** is being developed as the next stage of the project.

## ✨ Features

- **Onboarding:** Introduction to the GreenAura application.
- **Home Page:** Browse plants, explore categories, and search for products.
- **Plant Details:** View plant descriptions, prices, ratings, sizes, humidity, and temperature information.
- **Favorites:** Add plants to or remove plants from your favorites.
- **Shopping Cart:** Add and remove products, update quantities, and calculate subtotals and totals.
- **Profile:** View and edit basic profile information.
- **Plant Scanner UI:** Select plant images using the camera or gallery.
- **Navigation:** Navigate between application sections using a custom bottom navigation bar.

## 📱 Application Screenshots

### Onboarding

| Splash Screen 1 | Splash Screen 2 | Splash Screen 3 |
|:---:|:---:|:---:|
| ![Splash Screen 1](assets/screenshots/splash_one.png) | ![Splash Screen 2](assets/screenshots/splash_two.png) | ![Splash Screen 3](assets/screenshots/splash_three.png) |

### Main Application

| Home Page | Plant Details |
|:---:|:---:|
| ![Home Page](assets/screenshots/home_page.png) | ![Plant Details](assets/screenshots/detaile_page.png) |

| Favorites | Shopping Cart |
|:---:|:---:|
| ![Favorites](assets/screenshots/favorited_page.png) | ![Shopping Cart](assets/screenshots/cart_page.png) |

| Profile |
|:---:|
| ![Profile](assets/screenshots/profile_page.png) |

## 🛠️ Technologies Used

- **Flutter** – Cross-platform mobile application development.
- **Dart** – Programming language.
- **Material Design** – User interface components.
- **Image Picker** – Camera and gallery image selection.
- **Animated Bottom Navigation Bar** – Navigation experience.
- **Page Transition** – Screen transition animations.

## 📂 Project Structure

```text
lib/
├── const/
│   └── constant.dart
│
├── models/
│   └── plant.dart
│
├── screens/
│   ├── cart_page.dart
│   ├── detail_page.dart
│   ├── favorite_page.dart
│   ├── home_page.dart
│   ├── profile_page.dart
│   ├── root.dart
│   ├── scan_page.dart
│   └── splash_screen.dart
│
└── main.dart

assets/
├── images/
└── screenshots/
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code

### Installation

1. Clone the repository:

```bash
git clone https://github.com/ARK13-org/Greenaura-Plant-Shop.git
```

2. Navigate to the project directory:

```bash
cd Greenaura-Plant-Shop
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the application:

```bash
flutter run
```

## 📌 Development Status

- [x] Flutter frontend implementation
- [x] Application navigation and UI
- [x] Plant browsing and product details
- [x] Favorites functionality
- [x] Shopping cart functionality
- [x] Local profile management
- [x] Camera and gallery image selection UI
- [ ] FastAPI backend development
- [ ] Flutter and FastAPI integration
- [ ] Real API-based data management

**Current limitations:**

- Plant data is currently provided through simulated local data.
- Favorites, cart, and profile functionality use local application state.
- The plant scanner supports image selection, but automatic plant identification is not implemented yet.
- Backend integration is not yet complete.

## 🔮 Backend

The backend is being developed separately using **FastAPI**.

The planned integration will replace simulated data with API-based data management and connect the Flutter application to a backend service.

## 👨‍💻 Developer

Developed as a portfolio project to demonstrate Flutter mobile application development, UI design, application architecture, and preparation for backend integration using FastAPI.

---

**GreenAura – Bring Nature Home 🌱**
