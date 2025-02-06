# Search News API - Flutter Application

## 📌 Overview
This is a Flutter application that allows users to search for news articles using the **NewsAPI**. It features **state management with BLoC**, **pagination**, and a **clean UI**.

## 🚀 Features
- **Search News**: Search for news articles based on keywords.
- **Filter by Date**: Select a date range (FROM - TO) to filter results.
- **Infinite Scrolling**: Pagination allows loading more articles while scrolling.
- **Error Handling**: Handles API errors, no internet connection, and empty results gracefully.
- **WebView Support**: Open news articles in an in-app web browser.
- **State Management**: Uses BLoC for structured state handling.
- **Unit Tests**: Includes tests for API interactions.

## 🛠️ Tech Stack
- **Flutter** 
- **Dio** - For API calls
- **BLoC** - State management
- **Equatable** - Object comparison in BLoC
- **Intl** - Date formatting
- **WebView_flutter** - Embedded web browser

## 📂 Project Structure
```
lib/
│-- data/
│   ├── models/ (News model)
│   ├── data_providers/ (Handles API requests)
│-- logic/
│   ├── remote_news_bloc/ (BLoC logic, events, and states)
│-- view/
│   ├── widgets/ (Reusable UI components)
│   ├── news_search_page.dart (Main screen with search & filters)
│   ├── web_view_screen.dart (Displays full news article in WebView)
│-- main.dart (App entry point)
```

## 🔧 Installation & Setup
1️⃣ **Clone the repository**
```sh
git clone https://github.com/AlonaLaskar/search_news_api.git
cd search_news_api
```

2️⃣ **Install dependencies**
```sh
flutter pub get
```

3️⃣ **Add API Key**
- Create a `.env` file inside `assets/`.
- Add your **NewsAPI Key**:
```sh
NEWS_API_KEY=your_api_key_here
```

4️⃣ **Run the application**
```sh
flutter run
```

## 🧪 Running Tests
To ensure everything works correctly, run the tests:
```sh
flutter test
```
---
Made with ❤️ using Flutter.

–