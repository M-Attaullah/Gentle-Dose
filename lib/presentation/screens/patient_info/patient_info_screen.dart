import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../caregiver_info/caregiver_info_screen.dart';

/// Patient Information Screen - Tell us about yourself
class PatientInfoScreen extends StatefulWidget {
  const PatientInfoScreen({super.key});

  @override
  State<PatientInfoScreen> createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = '';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: cs.onBackground, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tell us about yourself',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: cs.onBackground,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Name field
            _buildTextField(
              label: 'Name',
              placeholder: 'Enter your name',
              controller: _nameController,
              cs: cs,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Age field
            _buildTextField(
              label: 'Age',
              placeholder: 'Enter your age',
              controller: _ageController,
              keyboardType: TextInputType.number,
              cs: cs,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Gender field
            _buildGenderField(cs, isDark),

            const Spacer(),

            // Confirm button
            _buildConfirmButton(cs),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    required ColorScheme cs,
    required bool isDark,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: cs.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: isDark ? cs.surface : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isDark ? cs.primary.withOpacity(0.3) : const Color(0xFFE0E0E0)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(fontSize: 14, color: cs.onSurface),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: isDark ? cs.onSurface.withOpacity(0.4) : const Color(0xFF9E9E9E),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField(ColorScheme cs, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: cs.onBackground,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildGenderOption('Male', cs, isDark)),
            const SizedBox(width: 12),
            Expanded(child: _buildGenderOption('Female', cs, isDark)),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String gender, ColorScheme cs, bool isDark) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : (isDark ? cs.surface : Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? cs.primary
                : (isDark ? cs.primary.withOpacity(0.3) : const Color(0xFFE0E0E0)),
          ),
        ),
        child: Center(
          child: Text(
            gender,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : (isDark ? cs.onSurface.withOpacity(0.6) : const Color(0xFF9E9E9E)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(ColorScheme cs) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CaregiverInfoScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
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
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
