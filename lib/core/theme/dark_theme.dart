import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDarkTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF5B9BFF),
          secondary: Color(0xFF7EB3FF),
          surface: Color(0xFF1E2533),
          background: Color(0xFF12161F),
          onPrimary: Colors.white,
          onSurface: Color(0xFFE8EDF5),
          onBackground: Color(0xFFE8EDF5),
          error: Color(0xFFFF6B6B),
        ),
        scaffoldBackgroundColor: const Color(0xFF12161F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1F2E),
          foregroundColor: Color(0xFFE8EDF5),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFFE8EDF5)),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E2533),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        dividerColor: const Color(0xFF2A3144),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E2533),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: const BorderSide(color: Color(0xFF2A3144)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: const BorderSide(color: Color(0xFF2A3144)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color(0xFF5B9BFF), width: 2),
          ),
          hintStyle: const TextStyle(color: Color(0xFF6B7A99)),
          labelStyle: const TextStyle(color: Color(0xFFE8EDF5)),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith(
            (s) => s.contains(MaterialState.selected)
                ? const Color(0xFF5B9BFF)
                : const Color(0xFF3A4155),
          ),
          trackColor: MaterialStateProperty.resolveWith(
            (s) => s.contains(MaterialState.selected)
                ? const Color(0xFF5B9BFF).withOpacity(0.4)
                : const Color(0xFF2A3144),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1F2E),
          selectedItemColor: Color(0xFF5B9BFF),
          unselectedItemColor: Color(0xFF6B7A99),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFE8EDF5)),
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          bodyLarge: const TextStyle(color: Color(0xFFE8EDF5)),
          bodyMedium: const TextStyle(color: Color(0xFFB8C4D9)),
          titleLarge: const TextStyle(color: Color(0xFFE8EDF5), fontWeight: FontWeight.w600),
          titleMedium: const TextStyle(color: Color(0xFFE8EDF5), fontWeight: FontWeight.w500),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5B9BFF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF5B9BFF),
            side: const BorderSide(color: Color(0xFF2A3144)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      );
}
