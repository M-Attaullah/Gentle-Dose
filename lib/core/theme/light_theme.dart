import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLightTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF407CE2),
          secondary: Color(0xFF1446A1),
          surface: Colors.white,
          background: Color(0xFFF8F9FA),
          onPrimary: Colors.white,
          onSurface: Colors.black,
          onBackground: Colors.black,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        dividerColor: const Color(0xFFE0E0E0),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color(0xFF407CE2), width: 2),
          ),
          hintStyle: const TextStyle(color: Colors.grey),
          labelStyle: const TextStyle(color: Colors.black87),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith(
            (s) => s.contains(MaterialState.selected)
                ? const Color(0xFF407CE2)
                : Colors.grey[300],
          ),
          trackColor: MaterialStateProperty.resolveWith(
            (s) => s.contains(MaterialState.selected)
                ? const Color(0xFF407CE2).withOpacity(0.4)
                : Colors.grey[200],
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF407CE2),
          unselectedItemColor: Colors.grey,
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          bodyLarge: const TextStyle(color: Colors.black87),
          bodyMedium: const TextStyle(color: Colors.black87),
          titleLarge: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          titleMedium: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF407CE2),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      );
}
