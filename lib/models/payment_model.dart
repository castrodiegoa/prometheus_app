import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  String id;
  DateTime date;
  double amount;
  bool isRentPaid;
  bool isWaterPaid;
  bool isEnergyPaid;
  bool isGasPaid;
  DateTime? createdAt;
  String rentId;

  // Constructor
  Payment({
    required this.id,
    required this.date,
    required this.amount,
    required this.isRentPaid,
    required this.isWaterPaid,
    required this.isEnergyPaid,
    required this.isGasPaid,
    this.createdAt,
    required this.rentId,
  });

  // Factory para crear un objeto Payment desde Firestore (deserialización)
  factory Payment.fromFirestore(DocumentSnapshot data) {
    return Payment(
      id: data['id'] ?? '', // Se obtiene el id desde la data de Firestore
      date: (data['date'] as Timestamp)
          .toDate(), // Se asume que date es un Timestamp
      amount: data['amount']?.toDouble() ?? 0.0, // Asegurarse de que sea double
      isRentPaid: data['isRentPaid'] ?? false, // Asegurarse de que sea un bool
      isWaterPaid:
          data['isWaterPaid'] ?? false, // Asegurarse de que sea un bool
      isEnergyPaid:
          data['isEnergyPaid'] ?? false, // Asegurarse de que sea un bool
      isGasPaid: data['isGasPaid'] ?? false, // Asegurarse de que sea un bool
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      rentId: data['rentId'] ?? '', // ID del alquiler
    );
  }

  // Método para convertir la instancia a un mapa compatible con Firestore (serialización)
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'date': Timestamp.fromDate(date), // Convertir DateTime a Timestamp
      'amount': amount,
      'isRentPaid': isRentPaid,
      'isWaterPaid': isWaterPaid,
      'isEnergyPaid': isEnergyPaid,
      'isGasPaid': isGasPaid,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'rentId': rentId, // Se incluye el id del alquiler
    };
  }
}
