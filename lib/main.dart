import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/providers/theme_provider.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';

// Screens
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/signup_screen.dart';
import 'presentation/screens/option_selection/option_selection_screen.dart';
import 'presentation/screens/language_selection/language_selection_screen.dart';
import 'presentation/screens/onboarding/onboarding_1_screen.dart';
import 'presentation/screens/onboarding/onboarding_2_screen.dart';
import 'presentation/screens/onboarding/onboarding_3_screen.dart';
import 'presentation/screens/patient_info/patient_info_screen.dart';
import 'presentation/screens/caregiver_info/caregiver_info_screen.dart';
import 'presentation/screens/caregiver/caregiver_add_details_screen.dart';
import 'presentation/screens/caregiver/caregiver_home_screen.dart';
import 'presentation/screens/caregiver/caregiver_patients_screen.dart';
import 'presentation/screens/caregiver/caregiver_profile_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/add_medication/add_medication_screen.dart';
import 'presentation/screens/calendar/calendar_screen.dart';
import 'presentation/screens/track/track_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/profile/user_profile_screen.dart';
import 'presentation/screens/profile/my_caregiver_screen.dart';
import 'presentation/screens/profile/medication_history_screen.dart';
import 'presentation/screens/profile/settings_screen.dart';
import 'presentation/screens/profile/notification_settings_screen.dart';
import 'presentation/screens/profile/language_settings_screen.dart';
import 'presentation/screens/profile/about_app_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const GentleDoseApp(),
    ),
  );
}

class GentleDoseApp extends StatelessWidget {
  const GentleDoseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Gentle Dose',
          debugShowCheckedModeBanner: false,
          theme: ThemeProvider.lightTheme,
          darkTheme: ThemeProvider.darkTheme,
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          home: const SplashScreen(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/main': (context) => const OptionSelectionScreen(),
            '/language-selection': (context) => const LanguageSelectionScreen(),
            '/onboarding-1': (context) => const Onboarding1Screen(),
            '/onboarding-2': (context) => const Onboarding2Screen(),
            '/onboarding-3': (context) => const Onboarding3Screen(),
            '/patient-info': (context) => const PatientInfoScreen(),
            '/caregiver-info': (context) => const CaregiverInfoScreen(),
            '/home': (context) => const HomeScreen(),
            '/add-medication': (context) => const AddMedicationScreen(),
            '/calendar': (context) =>
                CalendarScreen(medications: const [], appointments: const []),
            '/track': (context) =>
                TrackScreen(medications: const [], appointments: const []),
            '/profile': (context) => const ProfileScreen(),
            '/user-profile': (context) => const UserProfileScreen(),
            '/my-caregiver': (context) => const MyCaregiverScreen(),
            '/medication-history': (context) => const MedicationHistoryScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/notification-settings': (context) =>
                const NotificationSettingsScreen(),
            '/language-settings': (context) => const LanguageSettingsScreen(),
            '/about-app': (context) => const AboutAppScreen(),
            '/caregiver-add-details': (context) =>
                const CaregiverAddDetailsScreen(),
            '/caregiver-home': (context) => const CaregiverHomeScreen(),
            '/caregiver-patients': (context) => const CaregiverPatientsScreen(),
            '/caregiver-profile': (context) => const CaregiverProfileScreen(),
          },
        );
      },
    );
  }
}
