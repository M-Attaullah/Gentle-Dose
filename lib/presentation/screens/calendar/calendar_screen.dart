import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/models/medication.dart';
import '../../../core/models/appointment.dart';
import '../track/track_screen.dart';
import '../profile/profile_screen.dart';

/// Calendar Screen - Shows calendar with medication and appointment schedules
class CalendarScreen extends StatefulWidget {
  final List<Medication> medications;
  final List<Appointment> appointments;

  const CalendarScreen({
    super.key,
    this.medications = const [],
    this.appointments = const [],
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  Map<DateTime, List<CalendarEvent>> _events = {};

  @override
  void initState() {
    super.initState();
    _generateCalendarEvents();
  }

  void _generateCalendarEvents() {
    _events = {};
    for (var medication in widget.medications) {
      for (int i = 0; i < 90; i++) {
        final eventDate = DateTime.now().add(Duration(days: i));
        final dateKey = DateTime(eventDate.year, eventDate.month, eventDate.day);
        String time = medication.time.contains(',') ? medication.time.split(',').last.trim() : medication.time;
        final event = CalendarEvent(
          title: '${medication.name} - ${medication.dosage.split('\n')[0]}',
          time: time,
          type: CalendarEventType.medication,
          status: i == 0 ? medication.status.displayName : 'upcoming',
        );
        _events[dateKey] = (_events[dateKey] ?? [])..add(event);
      }
    }
    for (var appointment in widget.appointments) {
      DateTime eventDate = DateTime.now().add(const Duration(days: 7));
      final dateKey = DateTime(eventDate.year, eventDate.month, eventDate.day);
      final event = CalendarEvent(
        title: appointment.title,
        time: appointment.dateTime.contains('-') ? appointment.dateTime.split('-').last.trim() : '2:00 pm',
        type: CalendarEventType.appointment,
        status: appointment.status.displayName,
      );
      _events[dateKey] = (_events[dateKey] ?? [])..add(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: cs.onBackground, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalendarHeader(cs),
          _buildCalendar(cs),
          const SizedBox(height: 20),
          _buildDayDetailsSection(cs),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(cs),
    );
  }

  Widget _buildCalendarHeader(ColorScheme cs) {
    final monthNames = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    final dayNames = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(dayNames[_selectedDate.weekday - 1], style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: cs.onSurface)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: Icon(Icons.chevron_left, color: cs.onSurface), onPressed: () => setState(() {
                _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
                _selectedDate = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
              })),
              Text('${_selectedDate.day} ${monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: cs.onSurface)),
              IconButton(icon: Icon(Icons.chevron_right, color: cs.onSurface), onPressed: () => setState(() {
                _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
                _selectedDate = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
              })),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: ['S','M','T','W','T','F','S'].map((day) => SizedBox(width: 40, child: Text(day, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 14, color: cs.onSurface.withOpacity(0.6))))).toList()),
          const SizedBox(height: 16),
          _buildCalendarGrid(cs),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(ColorScheme cs) {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final firstWeekdayOfMonth = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;
    final totalCells = ((daysInMonth + firstWeekdayOfMonth - 1) / 7).ceil() * 7;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNumber = index - firstWeekdayOfMonth + 1;
        if (dayNumber < 1 || dayNumber > daysInMonth) return const SizedBox();
        final date = DateTime(_focusedMonth.year, _focusedMonth.month, dayNumber);
        final isSelected = _isSameDay(date, _selectedDate);
        final hasEvents = _events.containsKey(date);
        return GestureDetector(
          onTap: () => setState(() => _selectedDate = date),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(color: isSelected ? cs.primary : Colors.transparent, shape: BoxShape.circle),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(dayNumber.toString(), style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : cs.onSurface)),
                if (hasEvents && !isSelected) Positioned(bottom: 6, child: _buildEventIndicators(date, cs)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventIndicators(DateTime date, ColorScheme cs) {
    final events = _events[date] ?? [];
    List<Widget> indicators = [];
    if (events.any((e) => e.type == CalendarEventType.medication)) indicators.add(Container(width: 6, height: 6, margin: const EdgeInsets.symmetric(horizontal: 1), decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle)));
    if (events.any((e) => e.type == CalendarEventType.appointment)) indicators.add(Container(width: 6, height: 6, margin: const EdgeInsets.symmetric(horizontal: 1), decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle)));
    return Row(mainAxisSize: MainAxisSize.min, children: indicators);
  }

  Widget _buildDayDetailsSection(ColorScheme cs) {
    final selectedEvents = _events[_selectedDate] ?? [];
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Day Details', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: cs.onSurface)),
                TextButton(onPressed: () {}, child: Text('See all', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: cs.primary))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: selectedEvents.isEmpty
                ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.calendar_today_outlined, size: 80, color: cs.onSurface.withOpacity(0.3)), const SizedBox(height: 16), Text('No events for this day', style: GoogleFonts.poppins(fontSize: 16, color: cs.onSurface.withOpacity(0.5)))]))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) => _buildEventCard(selectedEvents[index], cs),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(CalendarEvent event, ColorScheme cs) {
    final color = event.type == CalendarEventType.medication ? cs.primary : const Color(0xFF4CAF50);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: Theme.of(context).dividerColor)),
      child: Row(
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(event.type == CalendarEventType.medication ? Icons.medication : Icons.person, color: color, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(event.title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: cs.onSurface)), const SizedBox(height: 4), Text(event.time, style: GoogleFonts.poppins(fontSize: 12, color: cs.onSurface.withOpacity(0.6)))])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: _getStatusColor(event.status).withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
            child: Text(event.status, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: _getStatusColor(event.status))),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed': return const Color(0xFF4CAF50);
      case 'missed': return const Color(0xFFF44336);
      default: return const Color(0xFFFF9800);
    }
  }

  Widget _buildBottomNavigationBar(ColorScheme cs) {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: cs.surface, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))]),
      child: Row(
        children: [
          _buildBottomNavItem(AppAssets.homeMenu, AppAssets.homeMenuSelected, 'Home', false, cs),
          _buildBottomNavItem(AppAssets.calendarMenu, AppAssets.calendarMenuSelected, 'Calendar', true, cs),
          _buildBottomNavItem(AppAssets.trackMenu, AppAssets.trackMenuSelected, 'Track', false, cs),
          _buildBottomNavItem(AppAssets.profileMenu, AppAssets.profileMenuSelected, 'Profile', false, cs),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(String normalAsset, String selectedAsset, String label, bool isSelected, ColorScheme cs) {
    return Expanded(
      child: GestureDetector(
        onTap: () { if (!isSelected) _handleNavigation(label); },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 32, height: 32, alignment: Alignment.center, child: Image.asset(isSelected ? selectedAsset : normalAsset, width: 30, height: 30, fit: BoxFit.contain)),
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: isSelected ? cs.primary : cs.onSurface.withOpacity(0.4))),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(String label) {
    switch (label) {
      case 'Home': Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false); break;
      case 'Track': Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TrackScreen(medications: widget.medications, appointments: widget.appointments))); break;
      case 'Profile': Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen())); break;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) => date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

class CalendarEvent {
  final String title;
  final String time;
  final CalendarEventType type;
  final String status;
  CalendarEvent({required this.title, required this.time, required this.type, required this.status});
}
enum CalendarEventType { medication, appointment }
