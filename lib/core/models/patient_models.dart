import 'medication.dart';

// Model for patient data
class Patient {
  final String id;
  final String name;
  final String condition;
  final String profileImage;
  final int totalDoses;
  final int takenDoses;
  final int missedDoses;
  final List<Medication> medications;

  Patient({
    required this.id,
    required this.name,
    required this.condition,
    required this.profileImage,
    required this.totalDoses,
    required this.takenDoses,
    required this.missedDoses,
    required this.medications,
  });

  String get progressText => '$takenDoses/$totalDoses Doses';
  double get progressPercentage =>
      totalDoses > 0 ? takenDoses / totalDoses : 0.0;
}

// Model for doctor appointment data
class DoctorAppointment {
  final String doctorName;
  final String specialty;
  final double rating;
  final String distance;
  final String profileImage;

  DoctorAppointment({
    required this.doctorName,
    required this.specialty,
    required this.rating,
    required this.distance,
    required this.profileImage,
  });
}
