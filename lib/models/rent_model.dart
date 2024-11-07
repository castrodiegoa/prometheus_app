import 'package:cloud_firestore/cloud_firestore.dart';

class Rent {
  String id;
  DateTime startDate;
  DateTime endDate;
  String? totalPersons;
  double amount;
  String? agreementUrl;
  bool isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  String tenantId;
  String propertyId;
  String userId;

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
    this.updatedAt,
    required this.tenantId,
    required this.propertyId,
    required this.userId,
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
      updatedAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      tenantId: data['tenantId'] ?? '',
      propertyId: data['propertyId'] ?? '',
      userId: data['userId'] ?? '',
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
      'updatedAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'tenantId': tenantId, // Se incluye el id del inquilino
      'propertyId': propertyId, // Se incluye el id de la propiedad
      'userId': userId,
    };
  }

  // Método copyWith para crear una nueva instancia de Tenant con valores actualizados
  Rent copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    String? totalPersons,
    double? amount,
    String? agreementUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? tenantId,
    String? propertyId,
    String? userId,
  }) {
    return Rent(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalPersons: totalPersons ?? this.totalPersons,
      amount: amount ?? this.amount,
      agreementUrl: agreementUrl ?? this.agreementUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tenantId: tenantId ?? this.tenantId,
      propertyId: propertyId ?? this.propertyId,
      userId: userId ?? this.userId,
    );
  }
}
