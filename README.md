# GeoAttend – Geo-Tagged Attendance App

GeoAttend is a Flutter-based attendance management system that allows employees to **check in and check out using real-time GPS location**.  
The app stores attendance records with **date, time, latitude, and longitude**, and displays full history tracking.

Built as part of a Flutter intern assessment project.

---

## Features

- Real-time GPS-based Check In / Check Out
- Attendance history tracking
- Live date & time display
- Stores latitude & longitude for each record
- Recent attendance summary
- State management using Riverpod

---

## Tech Stack

- Flutter 3.29.2
- Dart 3.7.2
- Riverpod (State Management)
- Geolocator (GPS service)
- GoRouter (Navigation)
- Intl (Date formatting)

---

## Permissions Required

This app requires:

- Location permission (Precise GPS access)
- Location services enabled

---

## Setup Instructions

### 1. Clone repository
```bash
git clone https://github.com/PathumDilhara/GeoAttend.git
cd GeoAttend
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Run the app
```bash
flutter run
```