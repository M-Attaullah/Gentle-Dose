import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static const String _medsKey = 'local_medications';
  static const String _appsKey = 'local_appointments';

  Future<void> saveMedication(Map<String, dynamic> medication) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> meds = await getMedications();
    meds.add(medication);
    await prefs.setString(_medsKey, jsonEncode(meds));
  }

  Future<void> updateMedicationStatus(String id, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> meds = await getMedications();
    final index = meds.indexWhere((m) => m['id'] == id);
    if (index != -1) {
      meds[index]['status'] = status;
      await prefs.setString(_medsKey, jsonEncode(meds));
    }
  }

  Future<List<Map<String, dynamic>>> getMedications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_medsKey);
    if (data == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveAppointment(Map<String, dynamic> appointment) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> apps = await getAppointments();
    apps.add(appointment);
    await prefs.setString(_appsKey, jsonEncode(apps));
  }

  Future<void> updateAppointmentStatus(String id, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> apps = await getAppointments();
    final index = apps.indexWhere((a) => a['id'] == id);
    if (index != -1) {
      apps[index]['status'] = status;
      await prefs.setString(_appsKey, jsonEncode(apps));
    }
  }

  Future<List<Map<String, dynamic>>> getAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_appsKey);
    if (data == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      return [];
    }
  }
}
