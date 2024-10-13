import 'package:cloud_firestore/cloud_firestore.dart';

class Rent {
  String id;
  DateTime startDate;
  DateTime endDate;
  int? totalPersons; // Debería ser int para reflejar el número de personas
  double amount;
  String? agreementUrl; // Asegurarse de que "agreement" esté bien escrito
  bool isActive;
  DateTime? createdAt;
  String tenantId; // Id del inquilino
  String propertyId; // Id de la propiedad

  // Constructor
  Rent({
    required this.id,
    required this.startDate,
    required this.endDate,
    this.totalPersons,
    required this.amount,
    this.agreementUrl,
    required this.isActive,
    this.createdAt,
    required this.tenantId,
    required this.propertyId,
  });

  // Factory para crear un objeto Rent desde Firestore (deserialización)
  factory Rent.fromFirestore(DocumentSnapshot data) {
    return Rent(
      id: data['id'] ?? '', // Se obtiene el id desde la data de Firestore
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      totalPersons: data['totalPersons'] ?? 0, // Asegurarse de que sea int
      amount: data['amount']?.toDouble() ?? 0.0, // Asegurarse de que sea double
      agreementUrl: data['agreementUrl'] ?? '',
      isActive: data['isActive'] ?? false, // Asegurarse de que sea un bool
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      tenantId: data['tenantId'] ?? '',
      propertyId: data['propertyId'] ?? '',
    );
  }

  // Método para convertir la instancia a un mapa compatible con Firestore (serialización)
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'totalPersons': totalPersons,
      'amount': amount,
      'agreementUrl': agreementUrl,
      'isActive': isActive,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'tenantId': tenantId, // Se incluye el id del inquilino
      'propertyId': propertyId, // Se incluye el id de la propiedad
    };
  }
}
