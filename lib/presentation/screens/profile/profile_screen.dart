import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/services/auth_service.dart';

/// Profile Screen - User profile and settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final _authService = AuthService();

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Profile Picture',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageSourceOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () => _getImage(ImageSource.camera),
                    ),
                    _buildImageSourceOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () => _getImage(ImageSource.gallery),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: const Color(0xFF407CE2)),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    Navigator.pop(context); // Close the bottom sheet

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).colorScheme.onBackground,
              size: 28,
            ),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // User avatar and name
          _buildUserProfile(),

          const SizedBox(height: 40),

          // Menu items
          Expanded(child: _buildMenuItems()),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      children: [
        // User avatar
        Container(
          width: 100,
          height: 100,
          child: Stack(
            children: [
              // Profile image
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _profileImage != null
                        ? FileImage(_profileImage!) as ImageProvider
                        : AssetImage(AppAssets.profileImg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Edit icon
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFF407CE2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // User name
        StreamBuilder<Map<String, dynamic>?>(
          stream: _authService.patientProfileStream(),
          builder: (context, snapshot) {
            final name = snapshot.data?['name'] ?? 'Patient';
            return Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildMenuItem(
          iconAsset: AppAssets.userProfileIcon,
          title: 'User Profile',
          onTap: () {
            Navigator.pushNamed(context, '/user-profile');
          },
        ),
        _buildMenuItem(
          iconAsset: AppAssets.caregiverIcon,
          title: 'My Caregiver',
          onTap: () {
            print('Navigating to My Caregiver');
            Navigator.pushNamed(context, '/my-caregiver');
          },
        ),
        _buildMenuItem(
          iconAsset: AppAssets.medicationHistoryIcon,
          title: 'Medication History',
          onTap: () {
            Navigator.pushNamed(context, '/medication-history');
          },
        ),
        _buildMenuItem(
          iconAsset: AppAssets.settingIcon,
          title: 'Settings',
          onTap: () {
            print('Navigating to Settings');
            Navigator.pushNamed(context, '/settings');
          },
        ),
        _buildMenuItem(
          iconAsset: AppAssets.aboutIcon,
          title: 'About App',
          onTap: () {
            print('Navigating to About App');
            Navigator.pushNamed(context, '/about-app');
          },
        ),
        // ── Logout ──────────────────────────────────────────────────────────
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: _confirmLogout,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red[100]!, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Logout',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.red, size: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String iconAsset,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          // Ensure menu navigation works
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF407CE2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    iconAsset,
                    width: 20,
                    height: 20,
                    color: const Color(0xFF407CE2),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),

              // Arrow
              const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.24 : 0.1,
            ),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildBottomNavItem(
            AppAssets.homeMenu,
            AppAssets.homeMenuSelected,
            'Home',
            false,
          ),
          _buildBottomNavItem(
            AppAssets.calendarMenu,
            AppAssets.calendarMenuSelected,
            'Calendar',
            false,
          ),
          _buildBottomNavItem(
            AppAssets.trackMenu,
            AppAssets.trackMenuSelected,
            'Track',
            false,
          ),
          _buildBottomNavItem(
            AppAssets.profileMenu,
            AppAssets.profileMenuSelected,
            'Profile',
            true, // Profile is selected
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    String normalAsset,
    String selectedAsset,
    String label,
    bool isSelected,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isSelected) {
            _handleNavigation(label);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: Image.asset(
                isSelected ? selectedAsset : normalAsset,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _authService.signOut();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/main',
                  (r) => false,
                );
              }
            },
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(String label) {
    switch (label) {
      case 'Home':
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        break;
      case 'Calendar':
        Navigator.pushNamed(context, '/calendar');
        break;
      case 'Track':
        Navigator.pushNamed(context, '/track');
        break;
    }
  }
}
