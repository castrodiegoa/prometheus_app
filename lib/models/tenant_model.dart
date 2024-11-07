import 'package:cloud_firestore/cloud_firestore.dart';

class Tenant {
  String id;
  String document;
  String firstName;
  String lastName;
  String primaryPhoneNumber;
  String? secondaryPhoneNumber;
  String email;
  DateTime? createdAt;
  DateTime? updatedAt;
  String userId;

  Tenant({
    required this.id,
    required this.document,
    required this.firstName,
    required this.lastName,
    required this.primaryPhoneNumber,
    this.secondaryPhoneNumber,
    required this.email,
    this.createdAt,
    this.updatedAt,
    required this.userId,
  });

  factory Tenant.fromFirestore(DocumentSnapshot data) {
    return Tenant(
      id: data['id'] ?? '',
      document: data['document'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      primaryPhoneNumber: data['primaryPhoneNumber'] ?? '',
      secondaryPhoneNumber: data['secondaryPhoneNumber'] ?? '',
      email: data['email'] ?? '',
      createdAt: (data['createdAt'] != null)
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: (data['updatedAt'] != null)
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'document': document,
      'firstName': firstName,
      'lastName': lastName,
      'primaryPhoneNumber': primaryPhoneNumber,
      'secondaryPhoneNumber': secondaryPhoneNumber,
      'email': email,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'userId': userId,
    };
  }

  // Método copyWith para crear una nueva instancia de Tenant con valores actualizados
  Tenant copyWith({
    String? id,
    String? document,
    String? firstName,
    String? lastName,
    String? primaryPhoneNumber,
    String? secondaryPhoneNumber,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return Tenant(
      id: id ?? this.id,
      document: document ?? this.document,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      primaryPhoneNumber: primaryPhoneNumber ?? this.primaryPhoneNumber,
      secondaryPhoneNumber: secondaryPhoneNumber ?? this.secondaryPhoneNumber,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }
}
