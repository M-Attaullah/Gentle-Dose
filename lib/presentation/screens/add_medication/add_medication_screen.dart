import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Add Medication Screen - Form to add new medication
class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final TextEditingController _medicationNameController =
  TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _reminderTimesController =
  TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedRepeat = 'Daily';
  DateTime? _startDate;
  DateTime? _endDate;
  List<TimeOfDay> _reminderTimes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(
        0.5,
      ), // Semi-transparent overlay
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button
                _buildHeader(),

                const SizedBox(height: 24),

                // Medication Name field
                _buildTextField(
                  label: 'Medication Name',
                  placeholder: 'Enter Medication Name',
                  controller: _medicationNameController,
                ),

                const SizedBox(height: 20),

                // Add Dosage field
                _buildTextField(
                  label: 'Add Dosage',
                  placeholder: '1 tablet, 1ml etc.',
                  controller: _dosageController,
                ),

                const SizedBox(height: 20),

                // Reminder time(s) field
                _buildReminderTimesField(),

                const SizedBox(height: 20),

                // Repeat field
                _buildRepeatField(),

                const SizedBox(height: 20),

                // Date fields
                _buildDateFields(),

                const SizedBox(height: 20),

                // Notes field
                _buildTextField(
                  label: 'Notes',
                  placeholder: 'Take after meal, Take with milk etc.',
                  controller: _notesController,
                  maxLines: 3,
                ),

                const SizedBox(height: 32),

                // Action buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Add Medication',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.black, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    IconData? suffixIcon,
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
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF9E9E9E),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, color: const Color(0xFF9E9E9E), size: 24)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReminderTimesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminder time(s)',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _addReminderTime,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: _reminderTimes.isEmpty
                      ? Text(
                    'Add one or multiple times',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF9E9E9E),
                    ),
                  )
                      : Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _reminderTimes
                        .map((time) => _buildTimeChip(time))
                        .toList(),
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  color: Color(0xFF9E9E9E),
                  size: 24,
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeChip(TimeOfDay time) {
    final timeString = time.format(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF407CE2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            timeString,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => _removeReminderTime(time),
            child: const Icon(Icons.close, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeat',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildRepeatOption('Daily'),
            const SizedBox(width: 12),
            _buildRepeatOption('Weekly'),
            const SizedBox(width: 12),
            _buildRepeatOption('Custom'),
          ],
        ),
      ],
    );
  }

  Widget _buildRepeatOption(String option) {
    final isSelected = _selectedRepeat == option;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRepeat = option;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF407CE2) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          option,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  Widget _buildDateFields() {
    return Row(
      children: [
        Expanded(
          child: _buildDateField('Start Date', _startDate, (date) {
            setState(() {
              _startDate = date;
            });
          }),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDateField('End Date', _endDate, (date) {
            setState(() {
              _endDate = date;
            });
          }),
        ),
      ],
    );
  }

  Widget _buildDateField(
      String label,
      DateTime? date,
      Function(DateTime) onDateSelected,
      ) {
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
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) {
              onDateSelected(picked);
            }
          },
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    date != null
                        ? '${date.day}/${date.month}/${date.year}'
                        : 'Select date',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: date != null
                          ? Colors.black
                          : const Color(0xFF9E9E9E),
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF9E9E9E),
                  size: 24,
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _addReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && !_reminderTimes.contains(picked)) {
      setState(() {
        _reminderTimes.add(picked);
        _updateReminderTimesController();
      });
    }
  }

  void _removeReminderTime(TimeOfDay time) {
    setState(() {
      _reminderTimes.remove(time);
      _updateReminderTimesController();
    });
  }

  void _updateReminderTimesController() {
    final timeStrings = _reminderTimes
        .map((time) => time.format(context))
        .toList();
    _reminderTimesController.text = timeStrings.join(', ');
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF407CE2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF407CE2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Create medication data map
              final medicationData = {
                'name': _medicationNameController.text.trim(),
                'dosage': _dosageController.text.trim(),
                'time': _reminderTimesController.text.trim(),
                'notes': _notesController.text.trim(),
                'reminderTimes': _reminderTimes
                    .map((time) => time.format(context))
                    .toList(),
              };

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Medication added successfully!'),
                  backgroundColor: Color(0xFF407CE2),
                ),
              );

              // Return the medication data
              Navigator.pop(context, medicationData);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF407CE2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
            ),
            child: Text(
              'Save',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _medicationNameController.dispose();
    _dosageController.dispose();
    _reminderTimesController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
