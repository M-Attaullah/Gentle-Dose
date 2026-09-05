// Stub file - Firebase configuration removed
// TODO: Re-implement with Firebase when configured

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final String? profileImageUrl;
  final String? verificationCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.profileImageUrl,
    this.verificationCode,
    required this.createdAt,
    required this.updatedAt,
  });

  // Stub methods - implement when Firebase is added
  factory UserModel.fromFirestore(dynamic doc) {
    throw UnimplementedError('Firebase not configured');
  }

  Map<String, dynamic> toFirestore() {
    throw UnimplementedError('Firebase not configured');
  }
}
