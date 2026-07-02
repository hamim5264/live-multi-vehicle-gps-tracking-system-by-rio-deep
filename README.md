<div align="center">

# 🚗 FleetLive
### Live Multi-Vehicle GPS Tracking System

**Developed for Rio Deep Technologies — Assessment Project**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![OpenStreetMap](https://img.shields.io/badge/OpenStreetMap-7EBC6F?style=for-the-badge&logo=openstreetmap&logoColor=white)](https://www.openstreetmap.org)

> *"Track every vehicle. Anywhere. Anytime."*

</div>

---

## 📋 Table of Contents

1. [Brief Project Overview](#-brief-project-overview)
2. [Platform & Technology Choice](#-platform--technology-choice)
3. [Planning & Architecture Approach](#-planning--architecture-approach)
4. [Project Folder Structure](#-project-folder-structure)
5. [Packages & Libraries Used](#-packages--libraries-used)
6. [User Interface — Fleet Manager](#-user-interface--fleet-manager)
7. [Driver Interface](#-driver-interface)
8. [Vehicle–Driver Connection](#-vehicledriver-connection)
9. [Live & Simulated Tracking](#-live--simulated-tracking)
10. [Role-Based Access Control](#-role-based-access-control)
11. [Setup & Installation](#-setup--installation)
12. [Design Reference](#-design-reference)
13. [Prototype Limitations](#️-prototype-limitations)
14. [Developer Information](#-developer-information)

---

## 📌 Brief Project Overview

**FleetLive** is a full-featured, real-time multi-vehicle GPS tracking mobile application built with **Flutter** and **Firebase**. It was developed as the assessment project for **Rio Deep Technologies** (Submission Deadline: 4th July 2026).

The application creates a seamless bridge between **fleet managers (users)** and **drivers** through real-time data synchronization. A driver can register, add their vehicle, and start broadcasting their location — while a fleet manager on the other side sees the vehicle appear instantly on a live map with full driver details, status, and speed.

### ✅ All Requirements Fulfilled

| # | Requirement | Status |
|---|-------------|--------|
| 1 | User Interface with live map and vehicle types | ✅ Done |
| 2 | Driver Interface with registration and tracking | ✅ Done |
| 3 | Vehicle–Driver connection clearly displayed | ✅ Done |
| 4 | Live / Simulated GPS tracking on map | ✅ Done |
| 5 | Mobile App-Based Platform (Flutter) | ✅ Done |
| 6 | Prototype fully functional end-to-end | ✅ Done |
| 7 | Complete documentation | ✅ Done (this README) |

---

## 📱 Platform & Technology Choice

| Decision | Choice | Reason |
|---|---|---|
| **Platform** | Mobile App (Android & iOS) | Flutter allows a single codebase to target both platforms with native-level performance |
| **Framework** | Flutter (Dart) | Best-in-class cross-platform UI, hot reload for fast development, and rich ecosystem |
| **Backend** | Firebase Auth + Realtime Database | Sub-second data sync, zero backend server cost (free tier), and easy auth management |
| **Map** | OpenStreetMap via `flutter_map` | Completely free, no API key required, highly customizable, open-source |
| **State Mgmt** | Provider (MVVM pattern) | Lightweight, Flutter-native, no boilerplate — perfect for this scale of app |

---

## 🧠 Planning & Architecture Approach

### Phase 1 — Requirements Analysis
I carefully read the assessment requirements and identified two distinct user roles (Driver and Fleet Manager), their separate workflows, and the data flow between them. I also noted the technical flexibility (any map library, any framework) and decided on **Flutter + Firebase** for speed and reliability.

### Phase 2 — UI/UX Design (Figma)
Before writing any code, I created a complete UI design in Figma covering all screens for both roles. This ensured a coherent design system and avoided mid-development rework.

🎨 **Figma Design**: [FleetLive UI/UX Design](https://www.figma.com/design/AZBkvDGMG9UAnG0wd24YQA/FLEETLIVE?node-id=0-1&t=l3ErFoaCZvQgkB5f-1)

### Phase 3 — Architecture Selection (MVVM)
I adopted the **Model–View–ViewModel (MVVM)** pattern to ensure a clean separation of concerns:
- **Models** hold data contracts (pure Dart classes with `copyWith`, `toJson`, `fromJson`)
- **ViewModels** handle all business logic, Firebase calls, and state changes (using `Provider`)
- **Views** are purely reactive UI — they read from ViewModels and rebuild when state changes

This means the UI is never directly responsible for fetching data or managing state, making the codebase maintainable and testable.

### Phase 4 — Data Flow Design
```
Driver App → [Start Tracking] → GPS/Simulation → Firebase Realtime DB
                                                         ↓
User App ←── [Live Map Update] ←── StreamSubscription ←──┘
```
The data pipeline is unidirectional and event-driven, ensuring minimal latency between a driver's movement and the fleet manager seeing it on the map.

### Phase 5 — Role Separation & Security
Both roles share the same Firebase Auth project but are **strictly isolated** — a driver account cannot access the user dashboard and vice versa. Role is stored per-email in SharedPreferences with enforcement at login.

---

## 📂 Project Folder Structure

```
lib/
│
├── constants/
│   ├── app_colors.dart         # Central color palette (Dark & Light mode tokens)
│   └── app_theme.dart          # ThemeData definitions for both themes
│
├── core/
│   └── app_router.dart         # Named route definitions and navigation logic
│
├── models/
│   ├── vehicle.dart            # Vehicle data model (VehicleType enum, VehicleStatus enum,
│   │                           #   Vehicle class with fromJson/toJson/copyWith)
│   └── driver.dart             # Driver profile model
│
├── services/
│   ├── firebase_service.dart   # All Firebase interactions:
│   │                           #   - Real-time DB stream subscriptions
│   │                           #   - CRUD for vehicles (registerVehicle, updateLocation)
│   │                           #   - Local in-memory fallback for offline/dev mode
│   └── simulation_service.dart # GPS path simulation engine using math offsets
│
├── viewmodels/
│   ├── auth_viewmodel.dart     # Authentication state: login, register, logout,
│   │                           #   session persistence, role-per-email enforcement
│   ├── driver_viewmodel.dart   # Driver state: vehicle management, start/stop tracking,
│   │                           #   GPS/simulation switching, real-time location updates
│   └── user_viewmodel.dart     # Fleet manager state: vehicle list, search, category
│                               #   filter, real-time stream from FirebaseService
│
└── views/
    ├── splash_screen.dart          # Animated splash with auto-redirect based on saved session
    ├── role_selection_screen.dart  # Role picker (Driver Portal vs User Portal)
    ├── login_screen.dart           # Shared login screen, role-aware, with error display
    ├── signup_screen.dart          # Registration screen, role-aware with duplication check
    ├── privacy_policy_screen.dart  # App privacy policy
    ├── help_support_screen.dart    # Help & support page
    │
    ├── driver/
    │   ├── driver_main_screen.dart       # Bottom nav shell for driver (Dashboard/Map/Vehicle/Profile)
    │   ├── driver_dashboard_screen.dart  # Stats overview: trips, distance, speed, active vehicle
    │   ├── driver_tracking_screen.dart   # Full-screen live map with polylines, speed overlay,
    │   │                                 #   start/stop controls, and vehicle marker
    │   ├── add_edit_vehicle_screen.dart  # Vehicle registration form: name, number, type,
    │   │                                 #   image picker, Firebase save
    │   ├── driver_profile_screen.dart    # Profile editor: name, theme toggle, logout
    │   └── widgets/
    │       ├── tracking_header.dart       # Live/Tracking Off status badge overlay
    │       ├── speedometer_overlay.dart   # Speed readout on top of map
    │       ├── tracking_details_card.dart # Floating card: driver info, coords, Start/Stop buttons
    │       ├── tracking_detail_item.dart  # Individual stat chip (speed, lat, lng)
    │       ├── current_vehicle_card.dart  # Card showing the active registered vehicle
    │       ├── driver_action_button.dart  # Reusable action button for dashboard
    │       ├── driver_header.dart         # Dashboard header with greeting and initials avatar
    │       ├── driver_stat_card.dart      # KPI stat card (trips, distance, speed)
    │       ├── map_icon_button.dart       # Small icon button overlay for map controls
    │       ├── vehicle_image_picker.dart  # Image picker widget with Base64 preview
    │       └── vehicle_type_dropdown.dart # Dropdown for selecting vehicle type
    │
    ├── user/
    │   ├── user_main_screen.dart       # Bottom nav shell for user (Home/Vehicles/Profile)
    │   ├── user_home_screen.dart       # Dashboard: stat cards, category filter, live map card,
    │   │                               #   nearby vehicles list
    │   ├── vehicle_list_screen.dart    # Full searchable/filterable vehicle list
    │   ├── user_profile_screen.dart    # User profile: name editor, theme toggle, logout
    │   └── widgets/
    │       ├── home_map_card.dart        # Compact live map widget with vehicle markers
    │       ├── home_header.dart          # Dashboard header with greeting and avatar
    │       ├── category_selector.dart    # Horizontal scroll category filter chips
    │       ├── filter_selector.dart      # Status filter (All/Online/Idle/Offline)
    │       ├── nearby_vehicle_card.dart  # Vehicle list item: type icon, driver, status badge
    │       ├── user_home_stat_card.dart  # KPI card: total vehicles, online drivers, deliveries
    │       ├── vehicle_list_card.dart    # Detailed card for vehicle list screen
    │       ├── vehicle_search_bar.dart   # Search input with real-time filtering
    │       └── map_button.dart           # Zoom/locate buttons on map overlay
    │
    └── widgets/
        └── vehicle_details_sheet.dart   # Bottom sheet: full vehicle details, driver info,
                                         #   live speed, rating system
```

---

## 📦 Packages & Libraries Used

| Package | Version | Purpose | Why Chosen |
|---|---|---|---|
| `flutter` | SDK | Core framework | Enables single codebase for Android & iOS with native performance |
| `provider` | ^6.1.2 | State management | Lightweight, Flutter-native, no code generation needed. Clean MVVM integration |
| `firebase_core` | ^3.1.0 | Firebase initialization | Required foundation for all Firebase services |
| `firebase_auth` | ^5.1.0 | Authentication | Secure user registration & login with email/password. Free tier is sufficient |
| `firebase_database` | ^11.1.0 | Real-time data sync | Sub-100ms latency for pushing/pulling vehicle locations between driver and user |
| `flutter_map` | ^6.1.0 | Map rendering | **Free**, no API key. Uses OpenStreetMap tiles. Highly customizable markers & layers |
| `latlong2` | ^0.9.1 | GPS coordinate types | Provides `LatLng` type used across the entire map and location stack |
| `flutter_map_cache` | ^2.1.0 | Tile caching | Caches map tiles to disk — reduces data usage and enables offline map viewing |
| `http_cache_file_store` | ^2.0.1 | File-based tile store | Backend store for `flutter_map_cache`; persists tiles using the file system |
| `geolocator` | ^12.0.0 | Device GPS | Accesses real hardware GPS for live tracking mode with high accuracy |
| `path_provider` | ^2.1.3 | File paths | Provides platform-appropriate temp/app directories for map tile cache storage |
| `shared_preferences` | ^2.3.2 | Session persistence | Stores user session (role, email, name) so the user stays logged in across app restarts |
| `google_fonts` | ^8.1.0 | Typography | "Plus Jakarta Sans" — a modern, tech-focused typeface that elevates UI premium feel |
| `image_picker` | ^1.1.2 | Vehicle photo upload | Lets drivers pick a vehicle photo from gallery/camera for their vehicle profile |
| `dio` | ^5.5.0 | HTTP client | Reliable HTTP client used as base for advanced networking needs |
| `url_launcher` | ^6.3.1 | External links | Opens URLs (GitHub, email, website) from profile and help screens |
| `cupertino_icons` | ^1.0.8 | iOS icons | Standard Flutter icon pack for cross-platform icon compatibility |

**Dev Dependencies:**
| Package | Purpose |
|---|---|
| `flutter_launcher_icons` | Generates custom app launcher icons from a single source image |
| `flutter_native_splash` | Generates a native splash screen before Flutter loads |
| `flutter_lints` | Enforces Dart/Flutter best practices via static analysis |

---

## 👤 User Interface — Fleet Manager

The **User (Fleet Manager) Interface** provides a comprehensive, real-time overview of the entire vehicle fleet.

### Features

**1. Smart Dashboard (Home)**
- **Live Stat Cards**: Displays total active vehicles, online drivers count, and delivery vehicle count — all updated in real-time from Firebase streams.
- **Category Filter**: Horizontal scroll chips to filter vehicles by type — `All`, `Car`, `Motorcycle`, `Rickshaw`, `CNG`, `Delivery Van`, `Truck`.
- **Compact Live Map**: A 220px interactive map showing all vehicle markers on OpenStreetMap. Tapping any marker opens a detailed bottom sheet. Includes zoom controls and a "my location" button.
- **Nearby Vehicles List**: A scrollable list of filtered vehicles with status badges (🟢 Online / 🟡 Idle / ⚫ Offline), driver name, registration number, and last updated time.
- **Pull-to-Refresh**: Swipe down to force a fresh data sync from Firebase.

**2. Vehicle List Screen**
- Full-screen searchable vehicle list with real-time text search across vehicle name, driver name, and registration number.
- Filter by status: All / Online / Idle / Offline.
- Tapping any vehicle opens the vehicle details bottom sheet.

**3. Vehicle Details Bottom Sheet**
- Displays: vehicle name, registration number, driver name, vehicle type, current speed, live GPS coordinates, last updated timestamp, and photo (if uploaded).
- Includes a **star rating system** for drivers — ratings persist to Firebase.

**4. User Profile**
- Edit display name.
- Toggle Light/Dark theme.
- Logout with session cleanup.

---

## 🚗 Driver Interface

The **Driver Interface** gives individual drivers full control over their vehicle profile and location broadcasting.

### Features

**1. Dashboard**
- **KPI Cards**: Total trips, total distance covered, and average speed.
- **Active Vehicle Card**: Displays the driver's currently registered vehicle with quick-action buttons.
- **Quick Actions**: Direct shortcuts to Start Tracking, Add Vehicle, and View History.

**2. Live Tracking Map**
- Full-screen OpenStreetMap with a pre-drawn route polyline for context.
- **Vehicle Marker**: A custom animated marker showing the registered vehicle type icon with a pulsing ring animation while tracking is active.
- **Speed Overlay**: Real-time speed readout in the top-right corner.
- **Status Badge**: "🟢 Live Tracking" / "⚫ Tracking Off" badge at the top center.
- **Control Card**: Floating bottom card showing driver info, live coordinates (latitude/longitude), and **Start / Stop / Recenter** buttons.

**3. Vehicle Management**
- **Add Vehicle**: Form to enter vehicle name, registration number, select vehicle type from a dropdown, and upload a photo.
- **Edit Vehicle**: All fields are editable. Changes sync instantly to Firebase.
- The vehicle is stored under the driver's unique ID, creating a one-to-one binding.

**4. Driver Profile**
- Edit name (synced to Firebase Auth display name).
- Toggle Light/Dark theme.
- Logout.

---

## 🔗 Vehicle–Driver Connection

The system maintains a strict and transparent **one-to-one binding** between a driver and their vehicle.

### How It Works

```
[Driver Registers] → [Adds Vehicle with driver name & avatar]
       ↓
[Vehicle stored in Firebase: /vehicles/<vehicleId>]
       with fields: { driver: "Hamim", avatar: "HA", driverEmail: "..." }
       ↓
[User App reads /vehicles/* via StreamSubscription]
       ↓
[Map marker rendered at vehicle's lat/lng]
[Tapping marker shows: Vehicle name + Driver name + Registration]
```

### Visibility in the UI

- Every **map marker** in the User Interface displays the vehicle type icon.
- Every **vehicle list card** explicitly shows the **driver's name** alongside the vehicle registration number.
- The **Vehicle Details Bottom Sheet** prominently features the driver's avatar, full name, and their vehicle's registration number.
- The **Dashboard stats** count how many drivers are currently online.

There is **no ambiguity** — the fleet manager always knows exactly which driver is responsible for each vehicle shown on the map.

---

## 📡 Live & Simulated Tracking

The system supports **dual-mode tracking**, making it functional both in field conditions and during development/demos.

### Mode 1: Live Hardware GPS
- Uses the `geolocator` package to access the device's GPS hardware.
- Requires location permission granted by the user.
- Streams high-accuracy coordinates (latitude, longitude, speed) at regular intervals.
- Each new coordinate is:
  1. Pushed to `FirebaseService.updateVehicleLocation()`
  2. Written to Firebase Realtime Database at `/vehicles/<id>`
  3. Instantly picked up by all User apps via their `StreamSubscription`

### Mode 2: Simulated GPS (Prototype Demo)
- Implemented in `SimulationService` using **mathematical path generation**.
- Generates a circular movement path around a starting coordinate using trigonometric offsets (`sin`, `cos` over time).
- Simulates realistic speed values (20–60 km/h range).
- Follows the exact same write path as live GPS — the User Interface **cannot tell the difference**.
- This makes the prototype fully demonstrable without needing a real vehicle or outdoor movement.

### Data Flow Summary

```
[Driver taps START]
      ↓
[GPS / Simulation → new LatLng + speed]
      ↓
[DriverViewModel.updateLocation()]
      ↓
[FirebaseService.updateVehicleLocation(id, lat, lng, speed)]
      ↓
[Firebase Realtime DB → /vehicles/<id> updated]
      ↓
[UserViewModel StreamSubscription fires]
      ↓
[UserViewModel notifyListeners()]
      ↓
[Map markers redraw at new position — no page reload needed]
```

---

## 🔐 Role-Based Access Control

A critical security feature ensures that **drivers cannot access the user dashboard** and **users cannot access the driver dashboard**, even if they share the same email address.

### Implementation

1. **At Registration**: The chosen role (`driver` or `user`) is stored in `SharedPreferences` under the key `role_<email>`.
2. **At Login**: Before authenticating, the system checks if a role is already stored for that email. If the attempted portal does **not match** the stored role, login is **blocked immediately** with a clear error message:
   > *"This account is registered as a Driver. Please use the Driver Portal."*
3. **At Splash Screen**: On app restart, the saved session (role + email) is restored — the user is taken directly to their correct dashboard, bypassing the login screen.

---

## ⚙️ Setup & Installation

### Prerequisites
- **Flutter SDK** `^3.11.1` — [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Android Studio** or **VS Code** with the Flutter and Dart extensions
- **Android SDK** (API 21+) or **Xcode** (iOS 12+)
- **Firebase project** with Android app registered (optional — local simulation mode works without Firebase)

### Step-by-Step Installation

**1. Clone the repository:**
```bash
git clone https://github.com/hamim5264/live-multi-vehicle-gps-tracking-system-by-rio-deep.git
cd live-multi-vehicle-gps-tracking-system-by-rio-deep
```

**2. Install dependencies:**
```bash
flutter pub get
```

**3. Firebase Setup (Optional — for real-time sync):**
- The `firebase_options.dart` and `google-services.json` files are included in the repo for the test Firebase project.
- If setting up your own Firebase project, replace these files using the [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/).

**4. Run the app:**
```bash
flutter run
```

> **Note:** The app includes a local simulation fallback. Even without Firebase, the Driver can start tracking in simulation mode and the User can see mock vehicles. Full real-time sync requires a Firebase connection.

### Test Accounts (Pre-configured)
You can register any email via the app's signup screen. For a quick demo:
- Go to **Driver Portal** → Sign Up → create a driver account → add a vehicle → Start Tracking.
- Open a second instance (or another device) → **User Portal** → Sign In with a different email → observe the vehicle appear live on the map.

---

## 🎨 Design Reference

The complete UI/UX design was created in **Figma** before development began:

🔗 **[View Figma Design](https://www.figma.com/design/AZBkvDGMG9UAnG0wd24YQA/FLEETLIVE?node-id=0-1&t=l3ErFoaCZvQgkB5f-1)**

**Design System Highlights:**
- **Color Palette**: Dark navy (`#0F172A`) base with electric blue (`#3B82F6`) primary accents and emerald green (`#10B981`) for success/online states.
- **Typography**: *Plus Jakarta Sans* (Google Fonts) — modern, geometric, and highly legible.
- **Dark/Light Modes**: Both fully implemented with a toggle in the Profile screen.
- **Micro-animations**: Splash screen logo animation, pulsing GPS marker, animated tracking dots, shimmer on stat cards.
- **Glassmorphism**: Semi-transparent overlays on the map screen for a premium feel.

---

## ⚠️ Prototype Limitations

These are known constraints of the current prototype version that would be addressed in a production release:

| Limitation | Current State | Production Solution |
|---|---|---|
| **Background Tracking** | Tracking stops when app is backgrounded on some devices | Implement a Flutter foreground service / background isolate |
| **Image Storage** | Vehicle photos stored as Base64 strings in Realtime DB | Use **Firebase Storage** or a CDN for efficient media storage |
| **Real-time Scalability** | Optimized for small/medium fleets (< 100 vehicles) | Implement geohash-based spatial queries for 1000+ concurrent vehicles |
| **Push Notifications** | Not yet implemented | Integrate **Firebase Cloud Messaging (FCM)** for alerts when a vehicle goes offline |
| **Route History Playback** | Sessions are tracked but playback is not animated | Store coordinate arrays per session and replay with animation |
| **Offline Support** | Map tiles cache, but Firebase data requires connectivity | Implement local SQLite caching for vehicle data with sync-on-reconnect |
| **Web Support** | Developed and tested on Android | Full web support requires `flutter_map` web-safe tile provider configuration |

---

## 👨‍💻 Developer Information

<table>
  <tr>
    <td><strong>Name</strong></td>
    <td>MD. ABDUL HAMIM LEON</td>
  </tr>
  <tr>
    <td><strong>Role</strong></td>
    <td>Software Developer</td>
  </tr>
  <tr>
    <td><strong>Company</strong></td>
    <td>DMA Technologies Ltd.</td>
  </tr>
  <tr>
    <td><strong>Assessment For</strong></td>
    <td>Rio Deep Technologies</td>
  </tr>
  <tr>
    <td><strong>Submission Date</strong></td>
    <td>July 2026</td>
  </tr>
</table>

---

<div align="center">

**Rio Deep Technologies**
9, Shahid Tajuddin Ahmed Sharani, Moghbazar, Ramna, Dhaka-1217
📞 +880 1311-124123 | ✉️ riodeeptech@gmail.com | 🌐 www.riodeep.com.bd

---

*Developed with 💙 for the Rio Deep Technologies Assessment.*
*"We look forward to seeing your creativity, technical skills, and problem-solving ability."*
— *Engr. Md. Razim Bhuiyan, CEO, Rio Deep Technologies*

</div>
