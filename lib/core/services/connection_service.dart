// Stub file - Firebase configuration removed
// TODO: Re-implement with Firebase when configured

import '../models/connection_model.dart';

class ConnectionService {
  // Stub methods - implement when Firebase is added
  
  Future<String?> connectViaPhone({
    required String caregiverPhoneNumber,
    required String patientName,
  }) async {
    print('TODO: Connection service - Firebase not configured');
    return null;
  }

  Future<Map<String, dynamic>> createConnectionRequest({
    required String patientId,
    required String caregiverVerificationCode,
    required String patientName,
  }) async {
    print('TODO: Connection service - Firebase not configured');
    return {'success': false, 'message': 'Firebase not configured'};
  }

  Future<bool> confirmConnection({
    required String connectionId,
    required String verificationCode,
  }) async {
    print('TODO: Connection service - Firebase not configured');
    return false;
  }

  Future<List<PatientCaregiverConnection>> getActiveConnections() async {
    print('TODO: Connection service - Firebase not configured');
    return [];
  }

  Future<List<PatientCaregiverConnection>> getConnectionsForUser(
      String userId) async {
    print('TODO: Connection service - Firebase not configured');
    return [];
  }

  Future<List<PatientCaregiverConnection>> getPendingRequests(
      [String? caregiverId]) async {
    print('TODO: Connection service - Firebase not configured');
    return [];
  }

  Future<void> removeConnection(String connectionId) async {
    print('TODO: Connection service - Firebase not configured');
  }

  Future<bool> disconnectConnection(String connectionId) async {
    print('TODO: Connection service - Firebase not configured');
    return false;
  }

  Future<List<String>> getCaregiverIdsForPatient(String patientId) async {
    print('TODO: Connection service - Firebase not configured');
    return [];
  }

  Future<List<String>> getPatientIdsForCaregiver(String caregiverId) async {
    print('TODO: Connection service - Firebase not configured');
    return [];
  }
}
