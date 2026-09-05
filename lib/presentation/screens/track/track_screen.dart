import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/models/medication.dart';
import '../../../core/models/appointment.dart';
import '../calendar/calendar_screen.dart';
import '../profile/profile_screen.dart';

class TrackScreen extends StatefulWidget {
  final List<Medication> medications;
  final List<Appointment> appointments;

  const TrackScreen({
    super.key,
    this.medications = const [],
    this.appointments = const [],
  });

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF12161F) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1F2E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Track Progress',
          style: GoogleFonts.poppins(
            fontSize: 18, 
            fontWeight: FontWeight.w600, 
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildTabButtons(cs, isDark),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: _selectedTabIndex == 0
                  ? _buildMedicationsTrack(cs, isDark)
                  : _buildAppointmentsTrack(cs, isDark),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(cs, isDark),
    );
  }

  Widget _buildTabButtons(ColorScheme cs, bool isDark) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabButton('Medications', 0, cs, isDark),
          const SizedBox(width: 16),
          _buildTabButton('Appointments', 1, cs, isDark),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index, ColorScheme cs, bool isDark) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : (isDark ? Colors.white10 : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationsTrack(ColorScheme cs, bool isDark) {
    final completedCount = widget.medications.where((med) => med.status == MedicationStatus.completed).length;
    final totalCount = widget.medications.length;
    final percentage = totalCount > 0 ? (completedCount / totalCount * 100).round() : 0;

    return Column(
      children: [
        _buildProgressCircle(completedCount, totalCount, cs, isDark),
        const SizedBox(height: 30),
        _buildProgressCard(percentage, cs, isDark),
        const SizedBox(height: 30),
        _buildUpcomingSection(true, cs, isDark),
      ],
    );
  }

  Widget _buildAppointmentsTrack(ColorScheme cs, bool isDark) {
    final completedCount = widget.appointments.where((app) => app.status == AppointmentStatus.completed).length;
    final totalCount = widget.appointments.length;
    final percentage = totalCount > 0 ? (completedCount / totalCount * 100).round() : 0;

    return Column(
      children: [
        _buildProgressCircle(completedCount, totalCount, cs, isDark),
        const SizedBox(height: 30),
        _buildProgressCard(percentage, cs, isDark),
        const SizedBox(height: 30),
        _buildUpcomingSection(false, cs, isDark),
      ],
    );
  }

  Widget _buildProgressCircle(int completed, int total, ColorScheme cs, bool isDark) {
    final progress = total > 0 ? completed / total : 0.0;
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$completed/$total', 
                style: GoogleFonts.poppins(
                  fontSize: 32, 
                  fontWeight: FontWeight.w700, 
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                'completed', 
                style: GoogleFonts.poppins(
                  fontSize: 16, 
                  fontWeight: FontWeight.w500, 
                  color: isDark ? Colors.white38 : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int percentage, ColorScheme cs, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2533) : const Color(0xFFF5F3E7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Your Progress', 
            style: GoogleFonts.poppins(
              fontSize: 16, 
              fontWeight: FontWeight.w500, 
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Text(
            '$percentage%', 
            style: GoogleFonts.poppins(
              fontSize: 32, 
              fontWeight: FontWeight.w700, 
              color: cs.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSection(bool isMedications, ColorScheme cs, bool isDark) {
    final upcomingItems = isMedications
        ? widget.medications.where((med) => med.status == MedicationStatus.upcoming).toList()
        : widget.appointments.where((app) => app.status == AppointmentStatus.upcoming).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming', 
                style: GoogleFonts.poppins(
                  fontSize: 18, 
                  fontWeight: FontWeight.w600, 
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {}, 
                child: Text(
                  'See all', 
                  style: GoogleFonts.poppins(
                    fontSize: 14, 
                    fontWeight: FontWeight.w500, 
                    color: cs.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (upcomingItems.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'No upcoming tasks', 
                  style: TextStyle(color: isDark ? Colors.white24 : Colors.grey[400]),
                ),
              ),
            )
          else
            ...upcomingItems.map((item) {
              if (item is Medication) return _buildMedicationTrackCard(item, cs, isDark);
              return _buildAppointmentTrackCard(item as Appointment, cs, isDark);
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildMedicationTrackCard(Medication medication, ColorScheme cs, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2533) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40, 
            height: 40, 
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1), 
              shape: BoxShape.circle,
            ), 
            child: Icon(Icons.medication, color: cs.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(
                  medication.name, 
                  style: GoogleFonts.poppins(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600, 
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ), 
                Text(
                  medication.time, 
                  style: GoogleFonts.poppins(
                    fontSize: 12, 
                    color: isDark ? Colors.white38 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: isDark ? Colors.white24 : Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildAppointmentTrackCard(Appointment appointment, ColorScheme cs, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2533) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40, 
            height: 40, 
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1), 
              shape: BoxShape.circle,
            ), 
            child: const Icon(Icons.person, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(
                  appointment.title, 
                  style: GoogleFonts.poppins(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600, 
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ), 
                Text(
                  appointment.dateTime, 
                  style: GoogleFonts.poppins(
                    fontSize: 12, 
                    color: isDark ? Colors.white38 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: isDark ? Colors.white24 : Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(ColorScheme cs, bool isDark) {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F2E) : Colors.white, 
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
          _buildBottomNavItem(AppAssets.homeMenu, AppAssets.homeMenuSelected, 'Home', false, cs, isDark),
          _buildBottomNavItem(AppAssets.calendarMenu, AppAssets.calendarMenuSelected, 'Calendar', false, cs, isDark),
          _buildBottomNavItem(AppAssets.trackMenu, AppAssets.trackMenuSelected, 'Track', true, cs, isDark),
          _buildBottomNavItem(AppAssets.profileMenu, AppAssets.profileMenuSelected, 'Profile', false, cs, isDark),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(String normalAsset, String selectedAsset, String label, bool isSelected, ColorScheme cs, bool isDark) {
    return Expanded(
      child: GestureDetector(
        onTap: () { if (!isSelected) _handleNavigation(label); },
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
                color: isSelected ? cs.primary : (isDark ? Colors.white38 : Colors.grey[500]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(String label) {
    switch (label) {
      case 'Home': Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false); break;
      case 'Calendar': Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CalendarScreen(medications: widget.medications, appointments: widget.appointments))); break;
      case 'Profile': Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen())); break;
    }
  }
}
