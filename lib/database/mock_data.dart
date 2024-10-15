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

  // Nuevos atributos para los recibos (pueden ser URLs o rutas de archivos)
  final String? rentReceipt;
  final String? waterReceipt;
  final String? energyReceipt;
  final String? gasReceipt;

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

    // Inicializamos los recibos como opcionales
    this.rentReceipt,
    this.waterReceipt,
    this.energyReceipt,
    this.gasReceipt,
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

    // Recibos (URLs o rutas de archivos, pueden estar en null)
    rentReceipt: "https://example.com/receipts/rent_1.pdf",
    waterReceipt: null,
    energyReceipt: "https://example.com/receipts/energy_1.pdf",
    gasReceipt: null,
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

    rentReceipt: "https://example.com/receipts/rent_2.pdf",
    waterReceipt: "https://example.com/receipts/water_2.pdf",
    energyReceipt: null,
    gasReceipt: null,
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

    rentReceipt: null,
    waterReceipt: null,
    energyReceipt: "https://example.com/receipts/energy_3.pdf",
    gasReceipt: "https://example.com/receipts/gas_3.pdf",
  ),
];
