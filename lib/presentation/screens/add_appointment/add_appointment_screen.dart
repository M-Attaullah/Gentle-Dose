import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Add Appointment Screen - Form for adding new appointments
class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _titleController = TextEditingController();
  final _doctorController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedReminder = '15 min before etc.';

  @override
  void dispose() {
    _titleController.dispose();
    _doctorController.dispose();
    _dateTimeController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Appointment',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 24),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Appointment Title
              _buildInputField(
                'Appointment Title',
                'Enter Appointment Title',
                _titleController,
              ),

              const SizedBox(height: 20),

              // Doctor / Clinic Name
              _buildInputField(
                'Doctor / Clinic Name',
                'Enter Doctor / Clinic Name',
                _doctorController,
              ),

              const SizedBox(height: 20),

              // Date & Time
              _buildDateTimeField(),

              const SizedBox(height: 20),

              // Location
              _buildInputField(
                'Location',
                'Enter Location',
                _locationController,
                prefixIcon: Icons.location_on_outlined,
              ),

              const SizedBox(height: 20),

              // Reminder Alert
              _buildReminderField(),

              const SizedBox(height: 20),

              // Notes
              _buildInputField(
                'Notes',
                'Take medical report along etc.',
                _notesController,
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              // Action buttons
              Row(
                children: [
                  Expanded(child: _buildCancelButton()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSaveButton()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label,
      String hint,
      TextEditingController controller, {
        IconData? prefixIcon,
        int maxLines = 1,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[400],
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.grey[400], size: 20)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF407CE2)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date & Time',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDateTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _dateTimeController.text.isEmpty
                        ? 'Enter Date & Time'
                        : _dateTimeController.text,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: _dateTimeController.text.isEmpty
                          ? Colors.grey[400]
                          : Colors.black,
                    ),
                  ),
                ),
                Icon(Icons.calendar_today, color: Colors.grey[400], size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReminderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminder Alert',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showReminderOptions,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedReminder,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _saveAppointment,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF407CE2),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            'Save',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _dateTimeController.text =
          '${date.day}/${date.month}/${date.year} ${time.format(context)}';
        });
      }
    }
  }

  void _showReminderOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildReminderOption('15 min before etc.'),
              _buildReminderOption('30 min before'),
              _buildReminderOption('1 hour before'),
              _buildReminderOption('1 day before'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReminderOption(String option) {
    return ListTile(
      title: Text(option, style: GoogleFonts.poppins(fontSize: 14)),
      onTap: () {
        setState(() {
          _selectedReminder = option;
        });
        Navigator.pop(context);
      },
    );
  }

  void _saveAppointment() {
    if (_titleController.text.isEmpty || _doctorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Return appointment data
    Navigator.pop(context, {
      'title': _titleController.text,
      'doctor': _doctorController.text,
      'dateTime': _dateTimeController.text,
      'location': _locationController.text,
      'reminder': _selectedReminder,
      'notes': _notesController.text,
    });
  }
}
