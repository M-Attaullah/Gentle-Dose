import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/services/auth_service.dart';

/// Caregiver Home Screen - Shows patients and their medications/appointments
class CaregiverHomeScreen extends StatefulWidget {
  const CaregiverHomeScreen({super.key});

  @override
  State<CaregiverHomeScreen> createState() => _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState extends State<CaregiverHomeScreen> {
  String _selectedTab = 'Medications';
  int _selectedNavIndex = 0;
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            Text(
              '24 September 2025',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: cs.onSurface.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: cs.onSurface,
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

          // Tab buttons
          _buildTabButtons(cs),

          const SizedBox(height: 20),

          // Content based on selected tab
          Expanded(
            child: _selectedTab == 'Medications'
                ? _buildMedicationsContent(cs)
                : _buildAppointmentsContent(cs),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(cs, isDark),
    );
  }

  Widget _buildTabButtons(ColorScheme cs) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _authService.caregiverPatientsStream(),
      builder: (context, snapshot) {
        final patients = snapshot.data ?? [];
        
        int totalMed = 0;
        int missedMed = 0;
        int totalApp = 0;
        int missedApp = 0;

        for (var p in patients) {
          totalMed += _asInt(p['totalMedications']);
          missedMed += _asInt(p['missedMedications']);
          totalApp += _asInt(p['totalAppointments']);
          missedApp += _asInt(p['missedAppointments']);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _buildTabButton(
                  'Medications',
                  '$totalMed Total / $missedMed Missed',
                  _selectedTab == 'Medications',
                  cs,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTabButton(
                  'Appointments',
                  '$totalApp Total / $missedApp Missed',
                  _selectedTab == 'Appointments',
                  cs,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabButton(String title, String subtitle, bool isSelected, ColorScheme cs) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? cs.primary : Theme.of(context).dividerColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : cs.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white70 : cs.onSurface.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationsContent(ColorScheme cs) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _authService.caregiverPatientsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final patients = snapshot.data ?? [];
        if (patients.isEmpty) {
          return _buildEmptyState(cs);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: patients.length,
          itemBuilder: (context, index) {
            final p = patients[index];
            final total = _asInt(p['totalMedications']);
            final completed = _asInt(p['completedMedications']);
            final missed = _asInt(p['missedMedications']);
            
            return _buildPatientCard(
              name: p['name'] ?? 'Patient',
              progress: 'Progress: $completed/$total Doses',
              missedCount: missed,
              cs: cs,
            );
          },
        );
      },
    );
  }

  Widget _buildAppointmentsContent(ColorScheme cs) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _authService.caregiverPatientsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final patients = snapshot.data ?? [];
        if (patients.isEmpty) {
          return _buildEmptyState(cs);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: patients.length,
          itemBuilder: (context, index) {
            final p = patients[index];
            final total = _asInt(p['totalAppointments']);
            final missed = _asInt(p['missedAppointments']);

            return _buildPatientCard(
              name: p['name'] ?? 'Patient',
              progress: 'Appointments: $total Total',
              missedCount: missed,
              cs: cs,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(ColorScheme cs) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 80, color: cs.onSurface.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text(
              'No patients connected yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Patients must add you using your registered email or phone number.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard({
    required String name,
    required String progress,
    required int missedCount,
    required ColorScheme cs,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage(AppAssets.profileImg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  progress,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: cs.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          if (missedCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$missedCount missed',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(ColorScheme cs, bool isDark) {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildBottomNavItem(AppAssets.homeMenu, AppAssets.homeMenuSelected, 'Home', 0, cs, isDark),
          _buildBottomNavItem(AppAssets.patientsIcon, AppAssets.patientsIconSelected, 'Patients', 1, cs, isDark),
          _buildBottomNavItem(AppAssets.profileMenu, AppAssets.profileMenuSelected, 'Profile', 2, cs, isDark),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    String normalAsset,
    String selectedAsset,
    String label,
    int index,
    ColorScheme cs,
    bool isDark,
  ) {
    final isSelected = _selectedNavIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedNavIndex = index;
          });
          _handleNavigation(label);
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
                color: isSelected ? cs.primary : (isDark ? Colors.white38 : Colors.grey[400]),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? cs.primary : cs.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(String label) {
    switch (label) {
      case 'Patients':
        Navigator.pushReplacementNamed(context, '/caregiver-patients');
        break;
      case 'Profile':
        Navigator.pushReplacementNamed(context, '/caregiver-profile');
        break;
    }
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
