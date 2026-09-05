import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../add_medication/add_medication_screen.dart';
import '../add_appointment/add_appointment_screen.dart';
import '../calendar/calendar_screen.dart';
import '../track/track_screen.dart';
import '../profile/profile_screen.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/models/medication.dart';
import '../../../core/models/appointment.dart';
import '../../../core/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  String _selectedMedicationFilter = 'upcoming';
  String _selectedAppointmentFilter = 'upcoming';
  final _authService = AuthService();
  StreamSubscription? _medicationSubscription;
  StreamSubscription? _appointmentSubscription;

  List<Medication> medications = [];
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    _medicationSubscription = _authService.medicationHistoryStream().listen((records) {
      if (!mounted) return;
      setState(() {
        medications = records.map(_medicationFromFirestore).toList();
      });
    });

    _appointmentSubscription = _authService.appointmentStream().listen((records) {
      if (!mounted) return;
      setState(() {
        appointments = records.map(_appointmentFromFirestore).toList();
      });
    });
  }

  @override
  void dispose() {
    _medicationSubscription?.cancel();
    _appointmentSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Row(
          children: [
            const Spacer(),
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: cs.onSurface, size: 28),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildTabButtons(cs, isDark),
          const SizedBox(height: 20),
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildMedicationsTab(cs, isDark)
                : _buildAppointmentsTab(cs, isDark),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_selectedTabIndex == 0) {
            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMedicationScreen()));
            if (result != null && result is Map<String, dynamic>) _authService.saveMedicationHistory(result);
          } else {
            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAppointmentScreen()));
            if (result != null && result is Map<String, dynamic>) _authService.saveAppointment(result);
          }
        },
        backgroundColor: cs.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
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
        decoration: BoxDecoration(color: isSelected ? cs.primary : (isDark ? Colors.white10 : Colors.grey[200]), borderRadius: BorderRadius.circular(20)),
        child: Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : cs.onSurface)),
      ),
    );
  }

  Widget _buildMedicationsTab(ColorScheme cs, bool isDark) {
    return Column(
      children: [
        _buildFilterButtons(cs, isDark, true),
        const SizedBox(height: 20),
        Expanded(child: _buildList(cs, isDark, true)),
      ],
    );
  }

  Widget _buildAppointmentsTab(ColorScheme cs, bool isDark) {
    return Column(
      children: [
        _buildFilterButtons(cs, isDark, false),
        const SizedBox(height: 20),
        Expanded(child: _buildList(cs, isDark, false)),
      ],
    );
  }

  Widget _buildFilterButtons(ColorScheme cs, bool isDark, bool isMed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: _buildFilterButton('completed', 'completed', cs, isDark, isMed)),
          const SizedBox(width: 12),
          Expanded(child: _buildFilterButton('missed', 'missed', cs, isDark, isMed)),
          const SizedBox(width: 12),
          Expanded(child: _buildFilterButton('upcoming', 'upcoming', cs, isDark, isMed)),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String value, String label, ColorScheme cs, bool isDark, bool isMed) {
    final isSelected = isMed ? _selectedMedicationFilter == value : _selectedAppointmentFilter == value;
    return GestureDetector(
      onTap: () => setState(() { if (isMed) _selectedMedicationFilter = value; else _selectedAppointmentFilter = value; }),
      child: Container(
        height: 44,
        decoration: BoxDecoration(color: isSelected ? _getFilterColor(value) : cs.surface, border: Border.all(color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(22)),
        child: Center(child: Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : cs.onSurface.withValues(alpha: 0.7)))),
      ),
    );
  }

  Color _getFilterColor(String filter) {
    switch (filter) {
      case 'completed': return const Color(0xFF4CAF50);
      case 'missed': return const Color(0xFFF44336);
      default: return const Color(0xFFFF9800);
    }
  }

  Widget _buildList(ColorScheme cs, bool isDark, bool isMed) {
    final filtered = isMed 
      ? medications.where((m) => m.status.displayName == _selectedMedicationFilter).toList()
      : appointments.where((a) => a.status.displayName == _selectedAppointmentFilter).toList();

    if (filtered.isEmpty) return _buildEmptyState(cs, isMed ? Icons.medication_outlined : Icons.calendar_today_outlined, isMed ? 'No medications found' : 'No appointments found');

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        if (isMed) return _buildMedicationCard(filtered[index] as Medication, cs, isDark);
        return _buildAppointmentCard(filtered[index] as Appointment, cs, isDark);
      },
    );
  }

  Widget _buildEmptyState(ColorScheme cs, IconData icon, String text) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 80, color: cs.onSurface.withValues(alpha: 0.3)), const SizedBox(height: 16), Text(text, style: GoogleFonts.poppins(fontSize: 16, color: cs.onSurface.withValues(alpha: 0.5)))]),
    );
  }

  Widget _buildMedicationCard(Medication med, ColorScheme cs, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).dividerColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${med.name} - ${med.dosage}', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: cs.onSurface)),
              Icon(Icons.edit_outlined, color: cs.onSurface.withValues(alpha: 0.3), size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(med.time, style: GoogleFonts.poppins(fontSize: 14, color: cs.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_buildActionButton(med.id, med.status, cs, true)],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment app, ColorScheme cs, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).dividerColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(app.title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: cs.onSurface)),
          const SizedBox(height: 4),
          Text(app.doctor, style: GoogleFonts.poppins(fontSize: 14, color: cs.onSurface.withValues(alpha: 0.7))),
          const SizedBox(height: 8),
          Text(app.dateTime, style: GoogleFonts.poppins(fontSize: 14, color: cs.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_buildActionButton(app.id, app.status, cs, false)],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String id, dynamic status, ColorScheme cs, bool isMed) {
    final statusName = isMed ? (status as MedicationStatus).displayName : (status as AppointmentStatus).displayName;
    
    if (statusName == 'completed') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(20)),
        child: const Row(children: [Text('completed', style: TextStyle(color: Colors.white, fontSize: 12)), SizedBox(width: 6), Icon(Icons.check, color: Colors.white, size: 16)]),
      );
    }
    
    if (statusName == 'missed') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFFF44336), borderRadius: BorderRadius.circular(20)),
        child: const Row(children: [Text('missed', style: TextStyle(color: Colors.white, fontSize: 12)), SizedBox(width: 6), Icon(Icons.close, color: Colors.white, size: 16)]),
      );
    }

    return GestureDetector(
      onTap: () {
        if (isMed) _authService.updateMedicationStatus(medicationId: id, status: 'completed');
        else _authService.updateAppointmentStatus(appointmentId: id, status: 'completed');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF4CAF50), width: 1.5), borderRadius: BorderRadius.circular(20)),
        child: const Row(children: [Text('Mark as completed', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 12, fontWeight: FontWeight.w500)), SizedBox(width: 6), Icon(Icons.check, color: Color(0xFF4CAF50), size: 16)]),
      ),
    );
  }

  Medication _medicationFromFirestore(Map<String, dynamic> data) {
    return Medication(
      id: (data['id'] ?? '').toString(),
      name: (data['name'] ?? 'Medication').toString(),
      dosage: (data['dosage'] ?? '').toString(),
      time: (data['time'] ?? 'No time').toString(),
      notes: (data['notes'] ?? '').toString(),
      status: _statusFromString((data['status'] ?? 'upcoming').toString()),
    );
  }

  MedicationStatus _statusFromString(String v) {
    if (v == 'completed') return MedicationStatus.completed;
    if (v == 'missed') return MedicationStatus.missed;
    return MedicationStatus.upcoming;
  }

  Appointment _appointmentFromFirestore(Map<String, dynamic> data) {
    return Appointment(
      id: (data['id'] ?? '').toString(),
      title: (data['title'] ?? 'Appointment').toString(),
      doctor: (data['doctor'] ?? 'Doctor').toString(),
      dateTime: (data['dateTime'] ?? 'Date & Time').toString(),
      location: (data['location'] ?? '').toString(),
      reminder: (data['reminder'] ?? '').toString(),
      notes: (data['notes'] ?? '').toString(),
      status: _appStatusFromString((data['status'] ?? 'upcoming').toString()),
    );
  }

  AppointmentStatus _appStatusFromString(String v) {
    if (v == 'completed') return AppointmentStatus.completed;
    if (v == 'missed') return AppointmentStatus.missed;
    return AppointmentStatus.upcoming;
  }

  Widget _buildBottomNavigationBar(ColorScheme cs, bool isDark) {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: cs.surface, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -2))]),
      child: Row(
        children: [
          _buildBottomNavItem(AppAssets.homeMenu, AppAssets.homeMenuSelected, 'Home', 0, cs, isDark),
          _buildBottomNavItem(AppAssets.calendarMenu, AppAssets.calendarMenuSelected, 'Calendar', 1, cs, isDark),
          _buildBottomNavItem(AppAssets.trackMenu, AppAssets.trackMenuSelected, 'Track', 2, cs, isDark),
          _buildBottomNavItem(AppAssets.profileMenu, AppAssets.profileMenuSelected, 'Profile', 3, cs, isDark),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(String n, String s, String label, int idx, ColorScheme cs, bool isDark) {
    final isSelected = idx == 0;
    return Expanded(
      child: GestureDetector(
        onTap: () { if (idx != 0) _handleNavigation(label); },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(isSelected ? s : n, width: 30, height: 30, color: isSelected ? cs.primary : (isDark ? Colors.white38 : Colors.grey[400])),
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: isSelected ? cs.primary : cs.onSurface.withValues(alpha: 0.45))),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(String label) {
    switch (label) {
      case 'Calendar': Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarScreen(medications: medications, appointments: appointments))); break;
      case 'Track': Navigator.push(context, MaterialPageRoute(builder: (context) => TrackScreen(medications: medications, appointments: appointments))); break;
      case 'Profile': Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())); break;
    }
  }
}
