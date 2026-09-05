// Stub file - Firebase configuration removed
// TODO: Re-implement with Firebase when configured

class PatientCaregiverConnection {
  final String? id;
  final String patientId;
  final String caregiverId;
  final String patientName;
  final String caregiverName;
  final String status;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final Map<String, dynamic>? metadata;

  PatientCaregiverConnection({
    this.id,
    required this.patientId,
    required this.caregiverId,
    required this.patientName,
    required this.caregiverName,
    required this.status,
    required this.createdAt,
    this.confirmedAt,
    this.metadata,
  });

  // Stub methods - implement when Firebase is added
  factory PatientCaregiverConnection.fromFirestore(dynamic doc) {
    throw UnimplementedError('Firebase not configured');
  }

  Map<String, dynamic> toFirestore() {
    throw UnimplementedError('Firebase not configured');
  }
}
