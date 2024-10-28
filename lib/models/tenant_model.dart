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

  // Constructor
  Tenant(
      {required this.id,
      required this.document,
      required this.firstName,
      required this.lastName,
      required this.primaryPhoneNumber,
      this.secondaryPhoneNumber,
      required this.email,
      this.createdAt});

  // Factory para crear un perfil desde Firestore (deserialización)
  factory Tenant.fromFirestore(DocumentSnapshot data) {
    return Tenant(
      id: data['id'] ?? '', // Se obtiene el id desde la data de Firestore
      document: data['document'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      primaryPhoneNumber: data['primaryPhoneNumber'] ?? '',
      secondaryPhoneNumber: data['secondaryPhoneNumber'] ?? '',
      email: data['email'] ?? '',
      createdAt: (data['createdAt'] != null)
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Método para convertir la instancia a un mapa compatible con Firestore (serialización)
  Map<String, dynamic> toFirestore() {
    return {
      'id': id, // El id también se incluye en la serialización
      'document': document,
      'firstName': firstName,
      'lastName': lastName,
      'primaryPhoneNumber': primaryPhoneNumber,
      'secondaryPhoneNumber': secondaryPhoneNumber,
      'email': email,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}
