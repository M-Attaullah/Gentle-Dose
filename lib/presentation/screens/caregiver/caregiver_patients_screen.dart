import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/models/patient_models.dart';
import '../../../core/services/auth_service.dart';
import 'patient_detail_screen.dart';

/// Caregiver Patients Screen - Shows list of patients under care
class CaregiverPatientsScreen extends StatefulWidget {
  const CaregiverPatientsScreen({super.key});

  @override
  State<CaregiverPatientsScreen> createState() =>
      _CaregiverPatientsScreenState();
}

class _CaregiverPatientsScreenState extends State<CaregiverPatientsScreen> {
  int _selectedNavIndex = 1; // Patients tab is selected
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'My Patients',
          style: GoogleFonts.poppins(
            fontSize: 20,
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

          // Patients List
          Expanded(child: _buildPatientsList()),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildPatientsList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _authService.caregiverPatientsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final patients = (snapshot.data ?? []).map(_patientFromSummary).toList();
        if (patients.isEmpty) {
          return Center(
            child: Text(
              'No patients connected yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: patients.length,
          itemBuilder: (context, index) {
            return _buildPatientCard(patients[index]);
          },
        );
      },
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientDetailScreen(patient: patient),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Patient avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(patient.profileImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Patient info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Progress: ${patient.progressText}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Missed count
            if (patient.missedDoses > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${patient.missedDoses} missed',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.red[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
            0,
          ),
          _buildBottomNavItem(
            AppAssets.patientsIcon,
            AppAssets.patientsIconSelected,
            'Patients',
            1,
          ),
          _buildBottomNavItem(
            AppAssets.profileMenu,
            AppAssets.profileMenuSelected,
            'Profile',
            2,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    String normalAsset,
    String selectedAsset,
    String label,
    int index,
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

  void _handleNavigation(String label) {
    switch (label) {
      case 'Home':
        Navigator.pushReplacementNamed(context, '/caregiver-home');
        break;
      case 'Patients':
        // Already on patients screen, do nothing
        break;
      case 'Profile':
        Navigator.pushReplacementNamed(context, '/caregiver-profile');
        break;
    }
  }

  Patient _patientFromSummary(Map<String, dynamic> data) {
    final total = _asInt(data['totalMedications']);
    final completed = _asInt(data['completedMedications']);
    final missed = _asInt(data['missedMedications']);
    return Patient(
      id: (data['patientId'] ?? '').toString(),
      name: (data['name'] ?? 'Patient').toString(),
      condition: (data['gender'] ?? '').toString(),
      profileImage: AppAssets.profileImg,
      totalDoses: total,
      takenDoses: completed,
      missedDoses: missed,
      medications: const [],
    );
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
