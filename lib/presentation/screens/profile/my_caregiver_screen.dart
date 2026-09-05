import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/auth_service.dart';

class MyCaregiverScreen extends StatefulWidget {
  const MyCaregiverScreen({super.key});

  @override
  State<MyCaregiverScreen> createState() => _MyCaregiverScreenState();
}

class _MyCaregiverScreenState extends State<MyCaregiverScreen> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _authService = AuthService();

  String _selectedRelationship = 'Parent';
  String _selectedFrequency = 'Daily';
  String _selectedContactMethod = 'SMS';
  bool _isLoading = false;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _loadCaregiver();
  }

  Future<void> _loadCaregiver() async {
    final data = await _authService.getCaregiver();
    if (data != null && mounted) {
      setState(() {
        _nameController.text = data['name'] ?? '';
        _contactController.text = data['contactNumber'] ?? '';
        _emailController.text = data['email'] ?? '';
        _selectedRelationship = data['relationship'] ?? 'Parent';
        _selectedFrequency = data['reportFrequency'] ?? 'Daily';
        _selectedContactMethod = data['preferredContactMethod'] ?? 'SMS';
        _isFetching = false;
      });
    } else {
      if (mounted) setState(() => _isFetching = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? const Color(0xFFE8EDF5) : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Caregiver',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFFE8EDF5) : Colors.black,
          ),
        ),
      ),
      body: _isFetching
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildInputField(
                    'Caregiver Name',
                    'Enter caregiver name',
                    _nameController,
                    isDark,
                    cs,
                  ),
                  const SizedBox(height: 20),
                  _buildRelationshipField(isDark, cs),
                  const SizedBox(height: 20),
                  _buildInputField(
                    'Contact Number',
                    '+920000000000',
                    _contactController,
                    isDark,
                    cs,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    'Caregiver Email',
                    'caregiver@email.com',
                    _emailController,
                    isDark,
                    cs,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  _buildContactMethodField(isDark, cs),
                  const SizedBox(height: 20),
                  _buildFrequencyField(isDark, cs),
                  const SizedBox(height: 40),
                  _buildSaveButton(cs),
                  const SizedBox(height: 16),
                  _buildCancelButton(isDark),
                ],
              ),
            ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController ctrl,
    bool isDark,
    ColorScheme cs, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFFE8EDF5) : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isDark ? const Color(0xFFE8EDF5) : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark ? const Color(0xFF6B7A99) : Colors.grey[400],
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF1E2533) : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF2A3144) : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF2A3144) : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelationshipField(bool isDark, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Relationship to Patient',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFFE8EDF5) : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: ['Parent', 'Spouse', 'Child', 'Friend', 'Doctor', 'Other']
              .map(
                (r) => _buildChip(
                  r,
                  _selectedRelationship,
                  isDark,
                  cs,
                  () => setState(() => _selectedRelationship = r),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildContactMethodField(bool isDark, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferred Contact Method',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFFE8EDF5) : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          children: ['SMS', 'WhatsApp', 'Both']
              .map(
                (m) => _buildChip(
                  m,
                  _selectedContactMethod,
                  isDark,
                  cs,
                  () => setState(() => _selectedContactMethod = m),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildFrequencyField(bool isDark, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress Report Frequency',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFFE8EDF5) : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            'Daily',
            'Weekly',
            'Only if dose missed',
          ].map((o) => _buildRadioOption(o, isDark, cs)).toList(),
        ),
      ],
    );
  }

  Widget _buildChip(
    String label,
    String selected,
    bool isDark,
    ColorScheme cs,
    VoidCallback onTap,
  ) {
    final isSelected = selected == label;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? cs.primary
              : isDark
              ? const Color(0xFF1E2533)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? cs.primary
                : isDark
                ? const Color(0xFF2A3144)
                : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white
                : isDark
                ? const Color(0xFF6B7A99)
                : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String option, bool isDark, ColorScheme cs) {
    final isSelected = _selectedFrequency == option;
    return GestureDetector(
      onTap: () => setState(() => _selectedFrequency = option),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? cs.primary
                      : isDark
                      ? const Color(0xFF6B7A99)
                      : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              option,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDark ? const Color(0xFFE8EDF5) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(ColorScheme cs) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveCaregiver,
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Save Changes',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildCancelButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDark ? const Color(0xFF2A3144) : Colors.grey[300]!,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Cancel',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF6B7A99) : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Future<void> _saveCaregiver() async {
    if (_nameController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Caregiver name is required'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    if (_contactController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contact number is required'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.saveCaregiver(
        name: _nameController.text,
        relationship: _selectedRelationship,
        contactNumber: _contactController.text,
        email: _emailController.text,
        reportFrequency: _selectedFrequency,
        preferredContactMethod: _selectedContactMethod,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Caregiver saved successfully!',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 250));
        if (!mounted) return;
        if (Navigator.of(context).canPop()) {
          Navigator.pop(context);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
