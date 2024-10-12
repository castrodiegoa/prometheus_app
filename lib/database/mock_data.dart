class Payment {
  final int id;
  final DateTime date;
  final double amount;
  final bool isRentPaid;
  final bool isWaterPaid;
  final bool isEnergyPaid;
  final bool isGasPaid;
  final int idRent;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    required this.date,
    required this.amount,
    required this.isRentPaid,
    required this.isWaterPaid,
    required this.isEnergyPaid,
    required this.isGasPaid,
    required this.idRent,
    required this.createdAt,
    required this.updatedAt,
  });
}

List<Payment> payments = [
  Payment(
    id: 1,
    date: DateTime(2023, 7, 10),
    amount: 500000,
    isRentPaid: true,
    isWaterPaid: false,
    isEnergyPaid: true,
    isGasPaid: false,
    idRent: 90410,
    createdAt: DateTime(2023, 7, 13), // Fecha de creación
    updatedAt: DateTime(2024, 7, 13), // Fecha de actualización
  ),
  Payment(
    id: 2,
    date: DateTime(2023, 9, 18),
    amount: 450000,
    isRentPaid: true,
    isWaterPaid: true,
    isEnergyPaid: false,
    isGasPaid: false,
    idRent: 90412,
    createdAt: DateTime(2023, 9, 20), // Fecha de creación
    updatedAt: DateTime(2024, 9, 20), // Fecha de actualización
  ),
  Payment(
    id: 3,
    date: DateTime(2023, 12, 20),
    amount: 600000,
    isRentPaid: false,
    isWaterPaid: false,
    isEnergyPaid: true,
    isGasPaid: true,
    idRent: 90415,
    createdAt: DateTime(2023, 12, 25), // Fecha de creación
    updatedAt: DateTime(2024, 12, 25), // Fecha de actualización
  ),
];
