import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize notification service
  Future<void> initialize() async {
    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotifications.initialize(initializationSettings);

    print('Local notifications initialized');
  }

  /// Show local notification
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'gentle_dose_channel',
          'Gentle Dose Notifications',
          channelDescription:
              'Notifications for medication reminders and caregiver alerts',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  /// Send notification to caregiver when patient misses medication
  /// TODO: Implement with backend when Firebase is configured
  Future<void> notifyCaregiversOfMissedMedication({
    required String patientId,
    required String medicationName,
    required DateTime scheduledTime,
    required String patientName,
  }) async {
    print('TODO: Notify caregivers - Firebase not configured');
    await showLocalNotification(
      title: '💊 Missed Medication',
      body: 'You missed taking $medicationName',
    );
  }

  /// Send notification to caregiver when patient misses appointment
  /// TODO: Implement with backend when Firebase is configured
  Future<void> notifyCaregiversOfMissedAppointment({
    required String patientId,
    required String appointmentDetails,
    required DateTime scheduledTime,
    required String patientName,
  }) async {
    print('TODO: Notify caregivers - Firebase not configured');
    await showLocalNotification(
      title: '🏥 Missed Appointment',
      body: 'You missed appointment: $appointmentDetails',
    );
  }

  /// Send connection request notification
  /// TODO: Implement with backend when Firebase is configured
  Future<void> sendConnectionRequest({
    required String caregiverId,
    required String patientName,
    required String verificationCode,
  }) async {
    print('TODO: Send connection request - Firebase not configured');
  }

  /// Send connection accepted notification
  /// TODO: Implement with backend when Firebase is configured
  Future<void> sendConnectionAccepted({
    required String patientId,
    required String caregiverName,
  }) async {
    print('TODO: Connection accepted - Firebase not configured');
  }
}
