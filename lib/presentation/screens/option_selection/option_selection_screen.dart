import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assets.dart';

/// Option Selection Screen - Choose between Patient and Caregiver
/// Screen size: 360x248
class OptionSelectionScreen extends StatefulWidget {
  const OptionSelectionScreen({super.key});

  @override
  State<OptionSelectionScreen> createState() => _OptionSelectionScreenState();
}

class _OptionSelectionScreenState extends State<OptionSelectionScreen> {
  int? selectedOption; // Track selected option: 1 for Patient, 2 for Caregiver

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Choose an option title text
          Positioned(
            left: 85,
            top: 260,
            width: 211,
            height: 30,
            child: _buildTitleText(),
          ),

          // Option 1 - I am a Patient (Left card)
          Positioned(
            left: 30,
            top: 313,
            width: 164,
            height: 281,
            child: _buildOptionCard1(),
          ),

          // Option 2 - I am a Caregiver (Right card)
          Positioned(
            left: 200,
            top: 313,
            width: 163,
            height: 281,
            child: _buildOptionCard2(),
          ),

          // Confirm button
          Positioned(
            left: 30,
            right: 30,
            bottom: 80,
            child: _buildConfirmButton(),
          ),
        ],
      ),
    );
  }

  /// Title text - "Choose an option"
  Widget _buildTitleText() {
    return Text(
      'Choose an option',
      style: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700, // Bold
        color: Theme.of(context).colorScheme.onBackground,
        height: 1.0,
      ),
    );
  }

  /// Option Card 1 - Patient
  Widget _buildOptionCard1() {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = 1; // Select Patient option
        });
      },
      child: Container(
        width: 164,
        height: 281,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: selectedOption == 1
              ? Border.all(color: const Color(0xFF407CE2), width: 3)
              : null, // Blue stroke when selected
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            AppAssets.optionSelection1, // option_selection_1.png
            width: 164,
            height: 281,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// Option Card 2 - Caregiver
  Widget _buildOptionCard2() {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = 2; // Select Caregiver option
        });
        print('Caregiver selected');
      },
      child: Container(
        width: 163,
        height: 281,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: selectedOption == 2
              ? Border.all(color: const Color(0xFF407CE2), width: 3)
              : null, // Blue stroke when selected
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            AppAssets.optionSelection2, // option_selection_2.png
            width: 163,
            height: 281,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// Confirm Button
  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: selectedOption != null
            ? () => Navigator.pushNamed(
                  context,
                  '/login',
                  arguments: selectedOption == 1 ? 'patient' : 'caregiver',
                )
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedOption != null
              ? const Color(0xFF407CE2)
              : const Color(0xFFE0E0E0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: Text(
          'Confirm',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: selectedOption != null
                ? Colors.white
                : const Color(0xFF9E9E9E),
          ),
        ),
      ),
    );
  }
}
