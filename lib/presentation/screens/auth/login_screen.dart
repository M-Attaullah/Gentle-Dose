import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/constants/app_assets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String _selectedRole = 'patient';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final role = await _authService.getCurrentUserRole();
      if (mounted) {
        _showToast(
          'Signed in successfully',
          backgroundColor: Colors.green[600],
        );
        await Future.delayed(const Duration(milliseconds: 250));
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          role == 'caregiver' ? '/caregiver-home' : '/home',
          (r) => false,
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

  Future<void> _sendPasswordReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter your email first')));
      return;
    }

    try {
      await _authService.sendPasswordResetEmail(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
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
                const SizedBox(height: 48),

                // Logo + App Name
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: cs.primary.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          AppAssets.appLogo,
                          width: 50,
                          height: 50,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.medical_services_rounded,
                            size: 40,
                            color: cs.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Gentle Dose',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your medication companion',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isDark
                              ? const Color(0xFF6B7A99)
                              : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                Text(
                  _selectedRole == 'caregiver'
                      ? 'Caregiver Sign In'
                      : 'Patient Sign In',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFE8EDF5) : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sign in to continue',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDark ? const Color(0xFF6B7A99) : Colors.grey[500],
                  ),
                ),

                const SizedBox(height: 32),

                // Email Field
                _buildLabel('Email Address'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDark ? const Color(0xFFE8EDF5) : Colors.black87,
                  ),
                  decoration: _inputDecoration(
                    hint: 'Enter your email',
                    icon: Icons.email_outlined,
                    isDark: isDark,
                    cs: cs,
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is Compulsory';
                    if (!v.contains('@')) return 'Valid email is required';
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Password Field
                _buildLabel('Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDark ? const Color(0xFFE8EDF5) : Colors.black87,
                  ),
                  decoration: _inputDecoration(
                    hint: 'Enter your password',
                    icon: Icons.lock_outline,
                    isDark: isDark,
                    cs: cs,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: isDark
                            ? const Color(0xFF6B7A99)
                            : Colors.grey[400],
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6)
                      return 'Password must be at least 6 characters long';
                    return null;
                  },
                ),

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading ? null : _sendPasswordReset,
                    child: Text(
                      'Forgot password?',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
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
                            'Sign In',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sign Up link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isDark
                              ? const Color(0xFF6B7A99)
                              : Colors.grey[500],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/signup',
                          arguments: _selectedRole,
                        ),
                        child: Text(
                          'Sign Up',
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
