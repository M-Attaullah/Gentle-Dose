import 'package:flutter/material.dart';

/// Medication model to represent a medication entry
class Medication {
  final String id;
  final String name;
  final String dosage;
  final String time;
  final String notes;
  final MedicationStatus status;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.notes,
    required this.status,
  });

  Medication copyWith({
    String? id,
    String? name,
    String? dosage,
    String? time,
    String? notes,
    MedicationStatus? status,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      time: time ?? this.time,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }
}

/// Medication status enum
enum MedicationStatus { upcoming, completed, missed }

/// Extension to get color for medication status
extension MedicationStatusExtension on MedicationStatus {
  Color get color {
    switch (this) {
      case MedicationStatus.completed:
        return const Color(0xFF4CAF50); // Green
      case MedicationStatus.missed:
        return const Color(0xFFF44336); // Red
      case MedicationStatus.upcoming:
        return const Color(0xFFFF9800); // Orange
    }
  }

  String get displayName {
    switch (this) {
      case MedicationStatus.completed:
        return 'completed';
      case MedicationStatus.missed:
        return 'missed';
      case MedicationStatus.upcoming:
        return 'upcoming';
    }
  }
}
