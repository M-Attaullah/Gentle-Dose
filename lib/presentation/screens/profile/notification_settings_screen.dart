import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Notification Settings Screen - Manage notification preferences
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _reminderAlerts = true;
  bool _sound = true;
  bool _vibration = true;
  bool _dailySummaryNotification = false;
  String _snoozeTime = '5 min';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Notification Setting',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),

          // Reminder Alerts
          _buildNotificationToggle('Reminder Alerts', _reminderAlerts, (value) {
            setState(() {
              _reminderAlerts = value;
            });
          }),

          const SizedBox(height: 24),

          // Sound
          _buildNotificationToggle('Sound', _sound, (value) {
            setState(() {
              _sound = value;
            });
          }),

          const SizedBox(height: 24),

          // Vibration
          _buildNotificationToggle('Vibration', _vibration, (value) {
            setState(() {
              _vibration = value;
            });
          }),

          const SizedBox(height: 24),

          // Daily Summary Notification
          _buildNotificationToggle(
            'Daily Summary Notification',
            _dailySummaryNotification,
            (value) {
              setState(() {
                _dailySummaryNotification = value;
              });
            },
          ),

          const SizedBox(height: 24),

          // Snooze Time
          _buildSnoozeTimeSection(),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF407CE2),
          inactiveThumbColor: Colors.grey[300],
          inactiveTrackColor: Colors.grey[200],
        ),
      ],
    );
  }

  Widget _buildSnoozeTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Snooze Time',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildSnoozeChip('5 min'),
            const SizedBox(width: 12),
            _buildSnoozeChip('10 min'),
            const SizedBox(width: 12),
            _buildSnoozeChip('15 min'),
          ],
        ),
      ],
    );
  }

  Widget _buildSnoozeChip(String time) {
    final isSelected = _snoozeTime == time;
    return GestureDetector(
      onTap: () {
        setState(() {
          _snoozeTime = time;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF407CE2) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF407CE2) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          time,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
