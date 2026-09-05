import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/auth_service.dart';

/// Caregiver Information Screen - Add Caregiver
class CaregiverInfoScreen extends StatefulWidget {
  const CaregiverInfoScreen({super.key});

  @override
  State<CaregiverInfoScreen> createState() => _CaregiverInfoScreenState();
}

class _CaregiverInfoScreenState extends State<CaregiverInfoScreen> {
  final TextEditingController _caregiverNameController =
      TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _authService = AuthService();
  String _selectedRelationship = '';
  String _selectedFrequency = '';
  bool _isLoading = false;

  void _showToast(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(fontSize: 14)),
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

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
          'Add Caregiver',
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

            // Caregiver Name field
            _buildTextField(
              label: 'Caregiver Name',
              placeholder: 'Enter caregiver name',
              controller: _caregiverNameController,
              cs: cs,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Relationship to Patient field
            _buildRelationshipField(cs, isDark),

            const SizedBox(height: 24),

            // Contact Number field
            _buildTextField(
              label: 'Contact Number',
              placeholder: '+8801XXXXXXX',
              controller: _contactNumberController,
              keyboardType: TextInputType.phone,
              cs: cs,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            _buildTextField(
              label: 'Caregiver Email',
              placeholder: 'caregiver@email.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              cs: cs,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Progress Report Frequency field
            _buildFrequencyField(cs, isDark),

            const Spacer(),

            // Action buttons
            _buildActionButtons(cs),

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

  Widget _buildRelationshipField(ColorScheme cs, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Relationship to Patient',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: cs.onBackground,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildRelationshipOption('Parent', cs, isDark)),
            const SizedBox(width: 8),
            Expanded(child: _buildRelationshipOption('Spouse', cs, isDark)),
            const SizedBox(width: 8),
            Expanded(child: _buildRelationshipOption('Child', cs, isDark)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildRelationshipOption('Friend', cs, isDark)),
            const SizedBox(width: 8),
            Expanded(child: _buildRelationshipOption('Doctor', cs, isDark)),
            const SizedBox(width: 8),
            Expanded(child: _buildRelationshipOption('Other', cs, isDark)),
          ],
        ),
      ],
    );
  }

  Widget _buildRelationshipOption(String relationship, ColorScheme cs, bool isDark) {
    final isSelected = _selectedRelationship == relationship;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRelationship = relationship;
        });
      },
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : (isDark ? cs.surface : Colors.white),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? cs.primary
                : (isDark ? cs.primary.withOpacity(0.3) : const Color(0xFFE0E0E0)),
          ),
        ),
        child: Center(
          child: Text(
            relationship,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : (isDark ? cs.onSurface.withOpacity(0.6) : const Color(0xFF9E9E9E)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrequencyField(ColorScheme cs, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress Report Frequency',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: cs.onBackground,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildFrequencyRadioOption('Daily', cs, isDark),
            const SizedBox(width: 24),
            _buildFrequencyRadioOption('Weekly', cs, isDark),
          ],
        ),
        const SizedBox(height: 8),
        _buildFrequencyRadioOption('Only if dose missed', cs, isDark),
      ],
    );
  }

  Widget _buildFrequencyRadioOption(String frequency, ColorScheme cs, bool isDark) {
    final isSelected = _selectedFrequency == frequency;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFrequency = frequency;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? cs.primary
                    : (isDark ? cs.primary.withOpacity(0.3) : const Color(0xFFE0E0E0)),
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.primary,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            frequency,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: cs.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ColorScheme cs) {
    return Column(
      children: [
        // Confirm button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveCaregiver,
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: Text(
              _isLoading ? 'Saving...' : 'Confirm',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Skip for now button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: cs.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Skip for now',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: cs.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _caregiverNameController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveCaregiver() async {
    if (_caregiverNameController.text.trim().isEmpty ||
        _contactNumberController.text.trim().isEmpty ||
        _selectedRelationship.isEmpty ||
        _selectedFrequency.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete caregiver details')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.saveCaregiver(
        name: _caregiverNameController.text,
        relationship: _selectedRelationship,
        contactNumber: _contactNumberController.text,
        email: _emailController.text,
        reportFrequency: _selectedFrequency,
      );

      if (mounted) {
        _showToast(
          'Caregiver details saved successfully',
          backgroundColor: Colors.green[600],
        );
        await Future.delayed(const Duration(milliseconds: 250));
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        _showToast(
          e.toString().replaceFirst('Exception: ', ''),
          backgroundColor: Colors.red,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
