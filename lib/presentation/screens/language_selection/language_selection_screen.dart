import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../onboarding/onboarding_1_screen.dart';

/// Language Selection Screen
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 286),
              Text(
                'Choose your Language',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: cs.onBackground,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 2),
              Text(
                'اپنی زبان کا انتخاب کریں',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: cs.onBackground.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),
              Center(
                child: _buildLanguageButton(language: 'English', value: 'en', cs: cs, isDark: isDark),
              ),

              const SizedBox(height: 15),
              Center(
                child: _buildLanguageButton(language: 'اردو', value: 'ur', cs: cs, isDark: isDark),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton({
    required String language,
    required String value,
    required ColorScheme cs,
    required bool isDark,
  }) {
    final bool isSelected = selectedLanguage == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = value;
        });

        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Onboarding1Screen()),
          );
        });
      },
      child: Container(
        width: 250,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : (isDark ? cs.surface : Colors.white),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: cs.primary,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            language,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : cs.primary,
            ),
          ),
        ),
      ),
    );
  }
}
