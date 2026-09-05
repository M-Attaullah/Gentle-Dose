import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Colors - Extracted from the design
class AppColors {
  static const Color primary = Color(
    0xFF1446A1,
  ); // EXACT color from design: #1446a1, rgb(20,70,161)
  static const Color primaryLight = Color(0xFF87CEEB); // Light blue from logo
  static const Color primaryDark = Color(0xFF2E5A9E); // Darker blue from logo

  static const Color background = Color(0xFFF8F9FA); // Light background
  static const Color surface = Colors.white;
  static const Color onPrimary = Colors.white;
  static const Color onSurface = Color(0xFF1446A1);

  // Text colors - EXACT from design #1446a1, rgb(20,70,161)
  static const Color textPrimary = Color(0xFF1446A1);
  static const Color textSecondary = Color(
    0xFF1446A1,
  ); // Same color for tagline

  // Logo gradient colors
  static const Color logoLightBlue = Color(0xFF87CEEB);
  static const Color logoDarkBlue = Color(0xFF2E5A9E);

  // Language Selection Screen Colors
  static const Color languageButtonColor = Color(0xFF407CE2);
  static const Color languageButtonSelectedText = Color(0xFFFFFFFF);
  static const Color backgroundGray = Color(
    0xFFFFFFFF,
  ); // Pure white background to match Figma exactly
}

/// App Typography
class AppTextStyles {
  // Splash screen styles
  static TextStyle appTitle = GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle tagline = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.3,
    letterSpacing: 0.1,
  );

  // Language Selection Screen Styles
  static TextStyle languageTitle = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static TextStyle languageSubtitle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black54,
  );

  static TextStyle languageButtonText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.languageButtonColor,
  );

  static TextStyle languageButtonSelectedText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.languageButtonSelectedText,
  );
}

/// App Dimensions
class AppDimensions {
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // Logo size
  static const double logoSize = 120.0;
}
