import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/constants/app_assets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Patient / Caregiver Common Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _contactController = TextEditingController();

  // Patient Specific
  final _ageController = TextEditingController();

  // Caregiver details for Patient signup (Step 2)
  final _cgNameController = TextEditingController();
  final _cgEmailController = TextEditingController();
  final _cgContactController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String _selectedRole = 'patient';
  String _selectedGender = 'Male';
  int _currentStep = 1; // 1 for Patient Details, 2 for Caregiver Details

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cgNameController.dispose();
    _cgEmailController.dispose();
    _cgContactController.dispose();
    super.dispose();
  }

  void _showToast(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(fontSize: 14)),
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRole == 'patient' && _currentStep == 1) {
      setState(() => _currentStep = 2);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_selectedRole == 'caregiver') {
        await _authService.signUpCaregiver(
          name: _nameController.text,
          contactNumber: _contactController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        // Patient signup
        await _authService.signUpPatient(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          age: _ageController.text,
          gender: _selectedGender,
        );

        // Save caregiver info immediately after signup
        await _authService.saveCaregiver(
          name: _cgNameController.text,
          relationship: 'Other',
          contactNumber: _cgContactController.text,
          email: _cgEmailController.text,
          reportFrequency: 'Daily',
        );
      }

      // Sign out after signup so they have to sign in manually
      await _authService.signOut();

      if (mounted) {
        _showToast(
          'Account created successfully! Please sign in.',
          backgroundColor: Colors.green[600],
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (r) => false,
          arguments: _selectedRole,
        );
      }
    } catch (e) {
      if (mounted) {
        _showToast(
          e.toString().replaceFirst('Exception: ', ''),
          backgroundColor: Colors.red[600],
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == 'patient' || args == 'caregiver') {
      _selectedRole = args as String;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                // Back button + Logo
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_currentStep == 2) {
                          setState(() => _currentStep = 1);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E2533)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF2A3144)
                                : Colors.grey[200]!,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: isDark
                              ? const Color(0xFFE8EDF5)
                              : Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        AppAssets.appLogo,
                        width: 28,
                        height: 28,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.medical_services_rounded,
                          size: 24,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                Text(
                  _selectedRole == 'patient' && _currentStep == 2
                      ? 'Caregiver Details'
                      : 'Create Account',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFE8EDF5) : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedRole == 'caregiver'
                      ? 'Create your caregiver account'
                      : _currentStep == 1
                          ? 'Step 1: Patient Information'
                          : 'Step 2: Caregiver Information',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDark ? const Color(0xFF6B7A99) : Colors.grey[500],
                  ),
                ),

                const SizedBox(height: 32),

                if (_selectedRole == 'caregiver' || _currentStep == 1) ...[
                  // Full Name
                  _buildLabel('Full Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    style: _textStyle(isDark),
                    decoration: _inputDecoration(
                      hint: 'Enter your full name',
                      icon: Icons.person_outline,
                      isDark: isDark,
                      cs: cs,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Name is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                if (_selectedRole == 'patient' && _currentStep == 1) ...[
                  _buildLabel('Age'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    style: _textStyle(isDark),
                    decoration: _inputDecoration(
                      hint: 'Enter your age',
                      icon: Icons.cake_outlined,
                      isDark: isDark,
                      cs: cs,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Age is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Gender'),
                  const SizedBox(height: 8),
                  _buildGenderField(isDark, cs),
                  const SizedBox(height: 20),
                ],

                if (_selectedRole == 'caregiver') ...[
                  _buildLabel('Contact Number'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _contactController,
                    keyboardType: TextInputType.phone,
                    style: _textStyle(isDark),
                    decoration: _inputDecoration(
                      hint: '+920000000000',
                      icon: Icons.phone_outlined,
                      isDark: isDark,
                      cs: cs,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                if (_selectedRole == 'caregiver' || _currentStep == 1) ...[
                  // Email
                  _buildLabel('Email Address'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: _textStyle(isDark),
                    decoration: _inputDecoration(
                      hint: 'Enter your email',
                      icon: Icons.email_outlined,
                      isDark: isDark,
                      cs: cs,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email is required';
                      if (!v.contains('@')) return 'Valid email is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password
                  _buildLabel('Password'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: _textStyle(isDark),
                    decoration: _inputDecoration(
                      hint: 'Enter at least 6 characters',
                      icon: Icons.lock_outline,
                      isDark: isDark,
                      cs: cs,
                      suffix: _eyeButton(
                        _obscurePassword,
                        () => setState(() => _obscurePassword = !_obscurePassword),
                        isDark,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password is required';
                      if (v.length < 6) return 'At least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password
                  _buildLabel('Confirm Password'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirm,
                    style: _textStyle(isDark),
                    decoration: _inputDecoration(
                      hint: 'Confirm your password',
                      icon: Icons.lock_outline,
                      isDark: isDark,
                      cs: cs,
                      suffix: _eyeButton(
                        _obscureConfirm,
                        () => setState(() => _obscureConfirm = !_obscureConfirm),
                        isDark,
                      ),
                    ),
                    validator: (v) {
                      if (v != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                ],

                if (_selectedRole == 'patient' && _currentStep == 2) ...[
                  _buildLabel('Caregiver Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _cgNameController,
                    textCapitalization: TextCapitalization.words,
                    style: _textStyle(isDark),
                    decoration: _inputDecoration(
                      hint: 'Enter caregiver name',
                      icon: Icons.person_add_alt_1_outlined,
                      isDark: isDark,
                      cs: cs,
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Caregiver Email'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _cgEmailController,
                    keyboardType: TextInputType.emailAddress,
                    style: _textStyle(isDark),
                    decoration: _inputDecoration(
                      hint: 'Enter caregiver email',
                      icon: Icons.email_outlined,
                      isDark: isDark,
                      cs: cs,
                    ),
                    validator: (v) => (v == null || !v.contains('@')) ? 'Valid email required' : null,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Caregiver Contact Number'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _cgContactController,
                    keyboardType: TextInputType.phone,
                    style: _textStyle(isDark),
                    decoration: _inputDecoration(
                      hint: '+920000000000',
                      icon: Icons.phone_outlined,
                      isDark: isDark,
                      cs: cs,
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                ],

                const SizedBox(height: 36),

                // Action Button (Next or Create Account)
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
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
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            (_selectedRole == 'patient' && _currentStep == 1)
                                ? 'Next'
                                : 'Create Account',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                if (_currentStep == 1)
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: isDark ? const Color(0xFF6B7A99) : Colors.grey[500],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: cs.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _textStyle(bool isDark) => GoogleFonts.poppins(
        fontSize: 14,
        color: isDark ? const Color(0xFFE8EDF5) : Colors.black87,
      );

  Widget _buildLabel(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? const Color(0xFFE8EDF5) : Colors.black87,
      ),
    );
  }

  Widget _buildGenderField(bool isDark, ColorScheme cs) {
    return Row(
      children: [
        Expanded(child: _genderOption('Male', isDark, cs)),
        const SizedBox(width: 12),
        Expanded(child: _genderOption('Female', isDark, cs)),
      ],
    );
  }

  Widget _genderOption(String gender, bool isDark, ColorScheme cs) {
    final isSelected = _selectedGender == gender;
    return InkWell(
      onTap: () => setState(() => _selectedGender = gender),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : isDark ? const Color(0xFF1E2533) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? cs.primary : isDark ? const Color(0xFF2A3144) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          gender,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : isDark ? const Color(0xFFE8EDF5) : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _eyeButton(bool obscure, VoidCallback onTap, bool isDark) => IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: isDark ? const Color(0xFF6B7A99) : Colors.grey[400],
          size: 20,
        ),
        onPressed: onTap,
      );

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required bool isDark,
    required ColorScheme cs,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: isDark ? const Color(0xFF6B7A99) : Colors.grey[400],
      ),
      prefixIcon: Icon(
        icon,
        color: isDark ? const Color(0xFF6B7A99) : Colors.grey[400],
        size: 20,
      ),
      suffixIcon: suffix,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
