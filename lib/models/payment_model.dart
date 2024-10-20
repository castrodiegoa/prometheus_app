import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final int id;
  final double amount;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool isRentPaid;
  bool isWaterPaid;
  bool isEnergyPaid;
  bool isGasPaid;

  // Nuevas propiedades para almacenar los recibos (pueden ser URLs o rutas de archivos)
  String? rentReceipt;
  String? waterReceipt;
  String? energyReceipt;
  String? gasReceipt;

  // Propiedad adicional para el ID del alquiler
  final String rentId;

  Payment({
    required this.id,
    required this.amount,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.isRentPaid = false,
    this.isWaterPaid = false,
    this.isEnergyPaid = false,
    this.isGasPaid = false,

    // Inicializamos los recibos en null si no hay ninguno
    this.rentReceipt,
    this.waterReceipt,
    this.energyReceipt,
    this.gasReceipt,

    // Propiedad rentId
    required this.rentId,
  });

  // Factory para crear un objeto Payment desde Firestore (deserialización)
  factory Payment.fromFirestore(DocumentSnapshot data) {
    return Payment(
      id: data['id'] ?? 0, // Se obtiene el id desde la data de Firestore
      date: (data['date'] as Timestamp)
          .toDate(), // Convertir Timestamp a DateTime
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0, // Convertir a double
      isRentPaid: data['isRentPaid'] ?? false, // Asegurarse de que sea un bool
      isWaterPaid:
          data['isWaterPaid'] ?? false, // Asegurarse de que sea un bool
      isEnergyPaid:
          data['isEnergyPaid'] ?? false, // Asegurarse de que sea un bool
      isGasPaid: data['isGasPaid'] ?? false, // Asegurarse de que sea un bool
      createdAt:
          (data['createdAt'] as Timestamp).toDate(), // Convertir Timestamp
      updatedAt:
          (data['updatedAt'] as Timestamp).toDate(), // Convertir Timestamp
      rentReceipt: data['rentReceipt'], // URL o string del recibo de alquiler
      waterReceipt: data['waterReceipt'], // URL o string del recibo del agua
      energyReceipt:
          data['energyReceipt'], // URL o string del recibo de la energía
      gasReceipt: data['gasReceipt'], // URL o string del recibo del gas
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
      'createdAt':
          Timestamp.fromDate(createdAt), // Convertir DateTime a Timestamp
      'updatedAt':
          Timestamp.fromDate(updatedAt), // Convertir DateTime a Timestamp
      'rentReceipt': rentReceipt, // Guardar URL o string
      'waterReceipt': waterReceipt, // Guardar URL o string
      'energyReceipt': energyReceipt, // Guardar URL o string
      'gasReceipt': gasReceipt, // Guardar URL o string
      'rentId': rentId, // Se incluye el id del alquiler
    };
  }
}
