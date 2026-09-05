import 'package:flutter/material.dart';

/// Appointment status enumeration
enum AppointmentStatus {
  upcoming,
  completed,
  missed;

  String get displayName {
    switch (this) {
      case AppointmentStatus.upcoming:
        return 'upcoming';
      case AppointmentStatus.completed:
        return 'completed';
      case AppointmentStatus.missed:
        return 'missed';
    }
  }
}

/// Extension to get colors for appointment status
extension AppointmentStatusColors on AppointmentStatus {
  Color get color {
    switch (this) {
      case AppointmentStatus.upcoming:
        return const Color(0xFFFF9800); // Orange
      case AppointmentStatus.completed:
        return const Color(0xFF4CAF50); // Green
      case AppointmentStatus.missed:
        return const Color(0xFFF44336); // Red
    }
  }
}

/// Appointment model to represent appointment data
class Appointment {
  final String id;
  final String title;
  final String doctor;
  final String dateTime;
  final String location;
  final String reminder;
  final String notes;
  final AppointmentStatus status;

  const Appointment({
    required this.id,
    required this.title,
    required this.doctor,
    required this.dateTime,
    required this.location,
    required this.reminder,
    required this.notes,
    required this.status,
  });

  Appointment copyWith({
    String? id,
    String? title,
    String? doctor,
    String? dateTime,
    String? location,
    String? reminder,
    String? notes,
    AppointmentStatus? status,
  }) {
    return Appointment(
      id: id ?? this.id,
      title: title ?? this.title,
      doctor: doctor ?? this.doctor,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      reminder: reminder ?? this.reminder,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }
}
