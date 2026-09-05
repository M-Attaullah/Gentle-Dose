import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_assets.dart';

/// Onboarding Screen 3 - "Share progress with caregivers for better support"
class Onboarding3Screen extends StatelessWidget {
  const Onboarding3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Skip Button
            Positioned(left: 335, top: 35, child: _buildSkipButton(cs)),

            // Main Image
            Positioned(left: 32, top: 140, child: _buildMainImage()),

            // Title Text
            Positioned(
              left: 78,
              top: 515,
              width: 274,
              height: 80,
              child: _buildTitleText(cs),
            ),

            // Progress Indicators
            Positioned(left: 40, top: 705, child: _buildProgressIndicators(cs, isDark)),

            // Next Button Circle
            Positioned(left: 310, top: 679, child: _buildNextButton(cs)),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton(ColorScheme cs) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        },
        child: Text(
          'Skip',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFA1A8B0),
          ),
        ),
      ),
    );
  }

  Widget _buildMainImage() {
    return SizedBox(
      width: 326,
      height: 430,
      child: Image.asset(
        AppAssets.onboarding3,
        width: 326,
        height: 430,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildTitleText(ColorScheme cs) {
    return Text(
      'Share progress with\ncaregivers for better support.',
      textAlign: TextAlign.left,
      style: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: cs.onBackground,
        height: 1.2,
      ),
    );
  }

  Widget _buildProgressIndicators(ColorScheme cs, bool isDark) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: isDark ? Colors.white24 : Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: isDark ? Colors.white24 : Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton(ColorScheme cs) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: cs.primary,
            shape: BoxShape.circle,
          ),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.arrow_forward,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
