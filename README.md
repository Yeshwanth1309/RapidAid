
# 🚑 RapidAid

**RapidAid** is a Flutter-based emergency support application that enables users to quickly connect with emergency services, share live locations, and notify trusted contacts during critical situations. The app integrates Firebase for authentication and cloud services, and Twilio for SMS alerts.

---

## 📱 Features

- 🔐 Secure user authentication (Firebase Auth)
- 📍 Real-time location tracking
- 📞 Emergency contact management
- ✉️ SMS alerts using Twilio
- 🌙 Light/Dark Theme toggle
- 🎯 First-time user onboarding

---

## 🛠️ Tech Stack

- **Flutter** (Frontend UI)
- **Firebase** (Auth, Firestore, Realtime DB, etc.)
- **Twilio** (SMS API)
- **GetX** (State Management)
- **flutter_dotenv** (Environment variable management)

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.0.0)
- Firebase project with necessary services enabled
- Twilio account with valid credentials

### Setup Instructions

1. **Clone the repository**:

   ```bash
   git clone https://github.com/Yeshwanth1309/RapidAid.git
   cd RapidAid
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Create `.env` file** in the root folder:

   ```
   # Firebase
   FIREBASE_API_KEY=your_api_key_here
   FIREBASE_APP_ID=your_app_id
   FIREBASE_MESSAGING_SENDER_ID=your_sender_id
   FIREBASE_PROJECT_ID=your_project_id
   FIREBASE_STORAGE_BUCKET=your_bucket
   FIREBASE_AUTH_DOMAIN=your_auth_domain
   FIREBASE_MEASUREMENT_ID=your_measurement_id

   # Twilio
   TWILIO_ACCOUNT_SID=your_twilio_sid
   TWILIO_AUTH_TOKEN=your_twilio_token
   TWILIO_PHONE_NUMBER=+1234567890
   ```

4. **Run the app**:

   ```bash
   flutter run
   ```

---

## 🔒 Environment & Security

- API keys are **not hardcoded** and are securely loaded from a `.env` file using `flutter_dotenv`.
- `.env` file is **excluded from version control** via `.gitignore`.

---

## 📂 Project Structure (Overview)

```
lib/
│
├── constants/            # Theme, color constants
├── providers/            # GetX controllers
├── screens/              # All UI screens
├── services/             # Twilio and helper services
├── firebase_env.dart     # FirebaseOptions via dotenv
├── main.dart             # App entry point
```

---

## ✅ TODO (Future Scope)

- Push notifications
- Emergency call integration
- Multilingual support

---

## 👨‍💻 Author

**Yeshwanth Reddy**  
[GitHub](https://github.com/Yeshwanth1309) | [LinkedIn](https://www.linkedin.com/in/gootyyeshwanthreddy)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
