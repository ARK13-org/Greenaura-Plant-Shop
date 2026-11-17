# 🌿 GreenAura – Plant Shopping App

**GreenAura** is a Flutter-based mobile application designed to make discovering and shopping for plants simple and enjoyable.

The app provides a clean, nature-inspired shopping experience where users can explore different plants, view their details, save favorites, and manage their shopping cart.

The current version focuses on the frontend and uses local simulated data. A **FastAPI backend** will be developed and integrated in a future stage.

## ✨ Features

- **Onboarding Screens:** Introduction to the GreenAura application.
- **Home Page:** Browse plants, explore categories, and search for products.
- **Plant Details:** View plant descriptions, prices, ratings, sizes, humidity, and temperature information.
- **Favorites:** Add plants to or remove plants from your favorites.
- **Shopping Cart:** Add and remove products, update quantities, and calculate the subtotal and total.
- **Profile Page:** View and edit basic profile information.
- **Plant Scanner UI:** Capture plant photos using the camera or select images from the gallery.
- **Bottom Navigation:** Easily navigate between the main sections of the application.

## 🛠️ Technologies Used

- **Flutter** – Cross-platform mobile application development.
- **Dart** – Programming language.
- **Material Design** – User interface components.
- **Image Picker** – Camera and gallery image selection.
- **Animated Bottom Navigation Bar** – Custom bottom navigation.
- **Page Transition** – Screen transition animations.

## 📱 Application Screens

| Screen | Description |
|---|---|
| Onboarding | Introduction to GreenAura |
| Home | Plant browsing, search, and categories |
| Details | Plant information and product details |
| Favorites | Saved plants |
| Cart | Shopping cart and quantity management |
| Profile | User profile and account options |
| Scanner | Camera and gallery image selection |

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

## 📌 Current Development Status

The Flutter frontend is implemented with local simulated plant data and local application state.

The camera and gallery features currently support selecting and displaying plant images. Automatic plant identification is not implemented.

The shopping cart, favorites, and profile currently operate locally and are not connected to a real backend.

## 🔮 Backend Development

The next development stage is to build a backend using **FastAPI** and integrate it with the Flutter application.

Planned backend integration will provide real API-based data and application functionality.

## 👨‍💻 Developer

Developed as a portfolio project to practice Flutter mobile application development and prepare for backend integration with FastAPI.

---

**GreenAura – Bring Nature Home 🌱**
