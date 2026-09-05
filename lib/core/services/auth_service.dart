import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'local_storage_service.dart';

class AuthService {
  // Singleton Pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    _notifyUpdates();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _local = LocalStorageService();

  final _medsController = StreamController<List<Map<String, dynamic>>>.broadcast();
  final _appsController = StreamController<List<Map<String, dynamic>>>.broadcast();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  CollectionReference<Map<String, dynamic>> get _users => _firestore.collection('users');

  Stream<List<Map<String, dynamic>>> medicationHistoryStream() {
    _notifyUpdates();
    return _medsController.stream;
  }

  Stream<List<Map<String, dynamic>>> appointmentStream() {
    _notifyUpdates();
    return _appsController.stream;
  }

  Future<void> _notifyUpdates() async {
    final meds = await _local.getMedications();
    final apps = await _local.getAppointments();
    _medsController.add(meds);
    _appsController.add(apps);
  }

  Future<UserCredential?> signUpPatient({
    required String name,
    required String email,
    required String password,
    required String age,
    required String gender,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      final uid = cred.user!.uid;
      await _users.doc(uid).set({
        'uid': uid,
        'role': 'patient',
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'age': age.trim(),
        'gender': gender,
        'profileComplete': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return cred;
    } on FirebaseAuthException catch (e) { throw _handleAuthError(e); }
  }

  Future<UserCredential?> signUpCaregiver({
    required String name,
    required String contactNumber,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      final uid = cred.user!.uid;
      await _users.doc(uid).set({
        'uid': uid,
        'role': 'caregiver',
        'name': name.trim(),
        'contactNumber': contactNumber.trim(),
        'email': email.trim().toLowerCase(),
        'profileComplete': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return cred;
    } on FirebaseAuthException catch (e) { throw _handleAuthError(e); }
  }

  Future<UserCredential?> signIn({required String email, required String password}) async {
    try { return await _auth.signInWithEmailAndPassword(email: email.trim(), password: password); }
    on FirebaseAuthException catch (e) { throw _handleAuthError(e); }
  }

  Future<void> signOut() async { await _auth.signOut(); }

  Future<String?> getCurrentUserRole() async {
    final uid = currentUser?.uid;
    if (uid == null) return null;
    final doc = await _users.doc(uid).get();
    return doc.data()?['role'] as String?;
  }

  // --- LOCAL-ONLY DATA METHODS ---
  Future<void> saveMedicationHistory(Map<String, dynamic> medication) async {
    final data = {
      ...medication,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'status': medication['status'] ?? 'upcoming',
      'createdAt': DateTime.now().toIso8601String(),
    };
    await _local.saveMedication(data);
    _notifyUpdates();
  }

  Future<void> saveAppointment(Map<String, dynamic> appointment) async {
    final data = {
      ...appointment,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'status': appointment['status'] ?? 'upcoming',
      'createdAt': DateTime.now().toIso8601String(),
    };
    await _local.saveAppointment(data);
    _notifyUpdates();
  }

  Future<void> updateMedicationStatus({required String medicationId, required String status}) async {
    await _local.updateMedicationStatus(medicationId, status);
    _notifyUpdates();
  }

  Future<void> updateAppointmentStatus({required String appointmentId, required String status}) async {
    await _local.updateAppointmentStatus(appointmentId, status);
    _notifyUpdates();
  }

  // Profile management
  Stream<Map<String, dynamic>?> patientProfileStream() {
    final uid = currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _users.doc(uid).snapshots().map((doc) => doc.data());
  }

  Stream<Map<String, dynamic>?> caregiverProfileStream() => patientProfileStream();

  Future<Map<String, dynamic>?> getPatientProfile() async {
    final uid = currentUser?.uid;
    if (uid == null) return null;
    final doc = await _users.doc(uid).get();
    return doc.data();
  }

  Future<Map<String, dynamic>?> getCaregiverProfile() => getPatientProfile();

  Future<void> savePatientProfile({
    required String name,
    required String age,
    required String gender,
    required String bloodGroup,
    required String contactNumber,
  }) async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    await _users.doc(uid).set({
      'name': name.trim(),
      'age': age.trim(),
      'gender': gender,
      'bloodGroup': bloodGroup.trim(),
      'contactNumber': contactNumber.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveCaregiverProfile({required String name, required String contactNumber}) async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    await _users.doc(uid).set({'name': name.trim(), 'contactNumber': contactNumber.trim(), 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  Future<void> saveCaregiver({required String name, required String relationship, required String contactNumber, required String reportFrequency, String preferredContactMethod = 'SMS', String email = ''}) async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    try {
      await _users.doc(uid).set({
        'caregiver': {
          'name': name.trim(),
          'relationship': relationship,
          'contactNumber': contactNumber.trim(),
          'email': email.trim().toLowerCase(),
          'reportFrequency': reportFrequency,
          'preferredContactMethod': preferredContactMethod,
        },
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {}
  }

  Future<Map<String, dynamic>?> getCaregiver() async {
    final uid = currentUser?.uid;
    if (uid == null) return null;
    final doc = await _users.doc(uid).get();
    return doc.data()?['caregiver'] as Map<String, dynamic>?;
  }

  Stream<List<Map<String, dynamic>>> caregiverPatientsStream() {
    final email = currentUser?.email?.trim().toLowerCase();
    if (email == null) return const Stream.empty();
    return _users.where('role', isEqualTo: 'patient').where('caregiver.email', isEqualTo: email).snapshots().map((snap) => snap.docs.map((doc) => {'patientId': doc.id, ...doc.data()}).toList());
  }

  Future<void> sendPasswordResetEmail(String email) async { try { await _auth.sendPasswordResetEmail(email: email.trim()); } catch (e) {} }
  String _handleAuthError(FirebaseAuthException e) { return e.message ?? 'An error occurred'; }
}
