# Brainwave

## A Mental Health Monitoring App

Brainwave is a mobile application that helps users track and understand the correlation between their smartphone usage, daily activities, and mental well-being. Using machine learning, it provides personalized insights to help users improve their mental health.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![TensorFlow](https://img.shields.io/badge/TensorFlow-%23FF6F00.svg?style=for-the-badge&logo=TensorFlow&logoColor=white)

## ✨ Features

- **User Authentication**: Secure sign-up and login with Firebase Authentication
- **App Usage Tracking**: Monitor time spent on different applications
- **Daily Activity Logging**: Record activities that may impact mental health
- **Mental Health Questionnaires**: Regular assessments to track mental well-being
- **ML-powered Analysis**: Get predictions and insights about your mental health based on usage patterns
- **Beautiful UI**: Starry animated background and intuitive interface
- **Push Notifications**: Stay informed with Firebase Cloud Messaging
- **User Profiles**: View and manage your personal information

## 🚀 Technologies Used

- **Frontend**: Flutter
- **Backend**: Firebase Cloud Functions
- **Authentication**: Firebase Auth
- **Database**: Cloud Firestore
- **ML Model Management**: Firebase ML Model Downloader
- **ML Inference**: TensorFlow Lite
- **Notifications**: Firebase Cloud Messaging

## 📁 Project Structure

```
lib/
├── animations/              # Animated UI components
│   ├── star_background.dart # Animated starry background component
│   ├── star_model.dart      # Star object model
│   └── star_painter.dart    # Custom painter for star animations
│
├── components/              # Reusable UI components
│   ├── app_usage_card.dart            # Card displaying app usage data
│   ├── attributes_choices.dart         # App attribute selection component
│   ├── daily_activity_checkbox.dart    # Daily activity selection widget
│   └── mental_health_questions_dropdown.dart # Mental health questionnaire widget
│
├── models/                  # Data models
│   ├── app_user.dart        # User profile data model
│   ├── app_user_usage.dart  # App usage statistics model
│   ├── report_models.dart   # Models for report generation
│   └── user_report.dart     # Mental health report model
│
├── providers/               # State management
│   ├── app_user_usage_provider.dart # App usage data state management
│   ├── auth_provider.dart           # Authentication state management
│   └── user_report_provider.dart    # Report data state management
│
├── screens/                 # Application screens
│   ├── app_usage_screen.dart    # Screen showing app usage stats
│   ├── login_screen.dart        # User login screen
│   ├── profile_screen.dart      # User profile screen
│   ├── register_screen.dart     # New user registration screen
│   ├── report_detail_screen.dart # Detailed report view
│   ├── report_screen.dart       # Report creation screen
│   └── welcome_screen.dart      # Main dashboard screen
│
├── services/                # Backend services
│   ├── app_user_usage_service.dart # App usage data service
│   ├── auth_service.dart           # Authentication service
│   └── user_report_service.dart    # Report management service
│
├── themes/                  # UI theme definitions
│   └── themes.dart          # App-wide theme configuration
│
├── utils/                   # Utility functions
│   ├── firebase_msg.dart    # Firebase messaging utilities
│   └── usage_formatter.dart # Format usage data for display
│
├── firebase_options.dart    # Firebase configuration
└── main.dart                # Application entry point
```

The project follows a clean architecture approach with clear separation of concerns:

- **Data Layer**: Models and services handle data representation and API communication
- **Business Logic**: Providers manage state and business logic
- **Presentation Layer**: Screens and components handle UI rendering and user interaction
- **Utilities**: Helper classes and functions for common tasks

## 📱 Usage

1. **Register/Login**: Create an account or login with your email and password
2. **App Usage**: The app will automatically track your app usage patterns
3. **Daily Report**: Submit daily reports about your activities and mental state
4. **View Insights**: Check your dashboard for ML-powered insights and recommendations
5. **Profile**: View and update your profile information

## 🙏 Acknowledgements

- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)
- [TensorFlow](https://www.tensorflow.org/)
- [Provider Package](https://pub.dev/packages/provider)
- All other open-source packages used in this project
