import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFFE8EDF5) : Colors.black,
          ),
        ),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 10),

              _buildSettingItem(
                context: context,
                icon: Icons.notifications_outlined,
                title: 'Notification',
                hasArrow: true,
                isDark: isDark,
                cs: cs,
                onTap: () =>
                    Navigator.pushNamed(context, '/notification-settings'),
              ),

              const SizedBox(height: 16),

              _buildSettingItem(
                context: context,
                icon: Icons.language_outlined,
                title: 'Language',
                hasArrow: true,
                isDark: isDark,
                cs: cs,
                onTap: () => Navigator.pushNamed(context, '/language-settings'),
              ),

              const SizedBox(height: 16),

              // Dark Mode — ACTUALLY connected to ThemeProvider now
              _buildSettingItem(
                context: context,
                icon: isDark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                title: 'Dark Mode',
                hasSwitch: true,
                switchValue: themeProvider.isDarkMode,
                isDark: isDark,
                cs: cs,
                onSwitchChanged: (value) {
                  themeProvider.toggleDarkMode(value);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    bool hasArrow = false,
    bool hasSwitch = false,
    bool switchValue = false,
    required bool isDark,
    required ColorScheme cs,
    VoidCallback? onTap,
    Function(bool)? onSwitchChanged,
  }) {
    return GestureDetector(
      onTap: hasSwitch ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2533) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF2A3144) : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: cs.primary, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFFE8EDF5) : Colors.black87,
                ),
              ),
            ),
            if (hasArrow)
              Icon(
                Icons.chevron_right,
                color: isDark ? const Color(0xFF6B7A99) : Colors.grey[400],
                size: 20,
              ),
            if (hasSwitch)
              Switch(value: switchValue, onChanged: onSwitchChanged),
          ],
        ),
      ),
    );
  }
}
