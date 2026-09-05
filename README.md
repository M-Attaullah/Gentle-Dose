# 💊 Gentle Dose

**Gentle Dose** is a Flutter-based medication and appointment management mobile application designed to help patients organize their medications, appointments, reminders, and health-related routines while providing a caregiver-oriented view for monitoring connected patients.

The application combines **Flutter, Firebase Authentication, Cloud Firestore, local storage, scheduled local notifications, and Provider-based state management** to provide a structured and user-friendly experience for both patients and caregivers.

## 📱 Overview

Managing medications and medical appointments can become difficult when schedules, reminders, and progress information are spread across different places.

Gentle Dose provides a centralized mobile experience where users can:

* Manage medication schedules
* Manage medical appointments
* Track medication and appointment progress
* View schedules through a calendar
* Receive local reminders
* Connect caregiver information with a patient account
* Allow caregivers to view connected patients and their medication/appointment progress
* Customize application language and theme preferences

The application provides separate experiences for **Patients** and **Caregivers**.

## ✨ Key Features

### 👤 Patient Features

* Patient account registration and login
* Password reset through Firebase Authentication
* Patient profile management
* Add and manage medications
* Set medication dosage and reminder times
* Track medication status
* Add and manage appointments
* Store appointment details including doctor/clinic, date, time, location, reminders, and notes
* Mark medications and appointments as completed
* View upcoming, completed, and missed items
* Medication history
* Calendar-based schedule view
* Progress tracking for medications and appointments
* Caregiver information management
* Notification settings
* Language settings
* Light and dark theme support
* About application section

### 👨‍⚕️ Caregiver Features

Gentle Dose provides a dedicated caregiver experience for monitoring connected patients.

Caregivers can:

* Create a caregiver account
* Sign in securely
* Add and manage caregiver profile information
* View connected patients
* View patient progress
* View medication and appointment statistics
* View missed medications and appointments
* Open individual patient details
* View patient medication information
* Access caregiver-specific navigation and dashboard views

Patient-caregiver information is retrieved through **Cloud Firestore** based on the caregiver relationship stored with the patient account.

## 💊 Medication Management

Users can create medication records with information such as:

* Medication name
* Dosage
* Schedule/time
* Reminder times
* Medication status

Medication records support different states including:

* Upcoming
* Completed
* Missed

Users can also mark medication items as completed, allowing the application to calculate medication progress.

## 🏥 Appointment Management

The application allows users to maintain appointment information including:

* Appointment title
* Doctor / clinic name
* Date and time
* Location
* Reminder preference
* Additional notes

Appointments also support status tracking and are included in the application's progress and calendar views.

## 📅 Calendar & Progress Tracking

Gentle Dose provides two dedicated ways to review health-related schedules.

### Calendar

The calendar displays medication and appointment events according to their scheduled information.

### Track Progress

The Track screen provides separate progress views for:

* Medications
* Appointments

Progress is calculated from completed versus total records and displayed using visual progress indicators.

## 🔔 Local Notifications & Reminders

The application includes local notification functionality using:

* `flutter_local_notifications`
* `timezone`
* `cron`

The notification service initializes Android local notifications and supports displaying medication and appointment-related reminder notifications.

> Caregiver notification actions that require backend-based delivery are currently represented as pending/TODO functionality in the implementation and are not presented as completed features.

## 🔐 Authentication

User authentication is implemented using **Firebase Authentication**.

The application supports:

* Patient registration
* Caregiver registration
* Email/password sign in
* Password validation
* Password confirmation during registration
* Password reset
* Sign out
* Authentication state monitoring
* Role-based patient/caregiver application flow

## ☁️ Firebase Integration

**Cloud Firestore** is used for cloud-based user and caregiver-related information.

The application uses Firebase for:

* User authentication
* User profile information
* Caregiver profile information
* Patient-caregiver relationship information
* Retrieving connected patient information
* Real-time streams for caregiver patient data

Medication and appointment records are currently managed through the application's local storage service rather than being presented as Firestore-backed medication/appointment collections.

## 💾 Local Data Storage

Gentle Dose uses **SharedPreferences** for local persistence.

Local storage is used for:

* Medication records
* Appointment records
* Medication status updates
* Appointment status updates
* Theme preference

This allows medication and appointment information to remain available locally between application sessions.

## 🌙 Theme & Personalization

The application includes:

* Light theme
* Dark theme
* Persistent dark-mode preference
* Language selection screen
* Custom application styling
* Google Fonts integration
* Responsive Flutter UI components

The theme state is managed using **Provider** and persisted locally.

## 🏗️ Architecture & Project Structure

The project follows a structured Flutter application organization separating core functionality, services, models, screens, and reusable widgets.

```text
Gentle-Dose/
│
├── android/
│
├── assets/
│   └── images/
│
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── services/
│   │   └── theme/
│   │
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── auth/
│   │   │   ├── home/
│   │   │   ├── calendar/
│   │   │   ├── track/
│   │   │   ├── caregiver/
│   │   │   ├── profile/
│   │   │   ├── onboarding/
│   │   │   └── ...
│   │   │
│   │   └── widgets/
│   │
│   ├── firebase_options.dart
│   └── main.dart
│
├── pubspec.yaml
└── README.md
```

## 🛠️ Technology Stack

| Technology                      | Purpose                                         |
| ------------------------------- | ----------------------------------------------- |
| **Flutter**                     | Cross-platform mobile application development   |
| **Dart**                        | Application programming language                |
| **Firebase Authentication**     | User registration, login, and password reset    |
| **Cloud Firestore**             | User, caregiver, and patient-related cloud data |
| **Provider**                    | Application state and theme management          |
| **SharedPreferences**           | Local persistence                               |
| **flutter_local_notifications** | Local notifications                             |
| **timezone**                    | Notification scheduling support                 |
| **cron**                        | Scheduling support                              |
| **Google Fonts**                | Application typography                          |
| **image_picker**                | Profile image selection                         |
| **intl_phone_field**            | Phone number input and validation               |

## 🚀 Getting Started

### Prerequisites

Make sure the following are installed:

* Flutter SDK
* Dart SDK
* Android Studio or another Flutter-supported development environment
* Android emulator or physical Android device
* Firebase project configured for the application

### Installation

Clone the repository:

```bash
git clone https://github.com/your-username/Gentle-Dose.git
cd Gentle-Dose
```

Install Flutter dependencies:

```bash
flutter pub get
```

### Firebase Configuration

The application uses Firebase Authentication and Cloud Firestore.

Before running the application, configure the Firebase project for your Flutter environment and provide the required Firebase configuration.

Do not commit private credentials, API secrets, or environment-specific configuration that should remain private.

### Run the Application

```bash
flutter run
```

## 🎯 Project Goals

Gentle Dose was developed with the goal of creating a simple and organized mobile experience for medication and appointment management.

The project focuses on:

* Improving medication schedule organization
* Providing appointment management in one place
* Helping users monitor completion progress
* Supporting caregiver visibility into connected patients
* Applying Firebase authentication and cloud data services
* Combining local persistence with cloud-based user information
* Building a clean and accessible Flutter mobile interface

## 📚 Learning Outcomes

Through this project, I gained practical experience in:

* Flutter mobile application development
* Dart programming
* Firebase Authentication
* Cloud Firestore integration
* Local data persistence
* State management using Provider
* Local notification implementation
* Form handling and validation
* Role-based application flows
* Building reusable Flutter UI components
* Theme management
* Structuring a multi-screen mobile application
* Integrating multiple Flutter packages into a complete application

## 🔮 Future Improvements

Potential future improvements include:

* Backend-based caregiver notifications
* More robust medication reminder scheduling
* Expanded medication history and analytics
* Improved caregiver-patient interaction
* Additional accessibility improvements
* More comprehensive cloud synchronization
* Production-ready security and deployment configuration

## 📌 Project Status

**Status: Developed Flutter Application**

The core patient and caregiver application flows, authentication, medication and appointment management, local persistence, progress tracking, calendar views, caregiver patient monitoring, theme support, and local notification functionality are implemented in the current project.


## 👤 Author

**M. Attaullah**

BS Software Engineering Student
