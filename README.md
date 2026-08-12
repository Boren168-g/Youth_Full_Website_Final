# Code4Youth Flutter Project

This project is a mobile-first learning application built with Flutter and connected to a MySQL backend.

## 🚀 How to Run

### 1. Start the Backend
```bash
cd backend
npm install
node server.js
```
*Ensure your MySQL server is running on port 3306.*

### 2. Start the Flutter App
```bash
flutter pub get
flutter run
```

## 🖼️ Important: Fixing Images (Web only)
If you are running the project in a **Web Browser** and images are not showing, it is because of browser CORS security. To fix this, run the app with the **HTML renderer**:

```bash
flutter run -d chrome --web-renderer html
```

## 🛠️ Features
- **MySQL Integration**: Login, Sign Up, Contact messages, and Event bookings are all saved to your local database.
- **Practice Editor**: A built-in code editor that looks and feels like VS Code.
- **Interactive Learning**: Dynamic lesson paths with progress tracking and confetti celebrations.
- **Glassmorphism UI**: Modern blurred navbar and smooth animations.
