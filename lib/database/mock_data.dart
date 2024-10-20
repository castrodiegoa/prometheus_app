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
  // Pagos de renta del 10 de enero a octubre
  Payment(
    id: 1,
    date: DateTime(2023, 1, 10),
    amount: 500000,
    isRentPaid: true,
    isWaterPaid: true,
    isEnergyPaid: true,
    isGasPaid: true,
    idRent: 90410,
    createdAt: DateTime(2023, 1, 11),
    updatedAt: DateTime(2024, 1, 11),
    rentReceipt: "https://example.com/receipts/rent_1.pdf",
    waterReceipt: "https://example.com/receipts/water_1.pdf",
    energyReceipt: "https://example.com/receipts/energy_1.pdf",
    gasReceipt: "https://example.com/receipts/gas_1.pdf",
  ),
  Payment(
    id: 2,
    date: DateTime(2023, 2, 10),
    amount: 500000,
    isRentPaid: true,
    isWaterPaid: true,
    isEnergyPaid: false,
    isGasPaid: true,
    idRent: 90410,
    createdAt: DateTime(2023, 2, 11),
    updatedAt: DateTime(2024, 2, 11),
    rentReceipt: "https://example.com/receipts/rent_2.pdf",
    waterReceipt: "https://example.com/receipts/water_2.pdf",
    energyReceipt: null,
    gasReceipt: "https://example.com/receipts/gas_2.pdf",
  ),
  Payment(
    id: 3,
    date: DateTime(2023, 3, 10),
    amount: 500000,
    isRentPaid: false,
    isWaterPaid: true,
    isEnergyPaid: true,
    isGasPaid: false,
    idRent: 90410,
    createdAt: DateTime(2023, 3, 11),
    updatedAt: DateTime(2024, 3, 11),
    rentReceipt: null,
    waterReceipt: "https://example.com/receipts/water_3.pdf",
    energyReceipt: "https://example.com/receipts/energy_3.pdf",
    gasReceipt: null,
  ),
  // Continúa de manera similar para los meses de abril a octubre...

  // Pagos de renta del 11 de enero a noviembre
  Payment(
    id: 11,
    date: DateTime(2023, 1, 11),
    amount: 550000,
    isRentPaid: true,
    isWaterPaid: false,
    isEnergyPaid: true,
    isGasPaid: false,
    idRent: 90411,
    createdAt: DateTime(2023, 1, 12),
    updatedAt: DateTime(2024, 1, 12),
    rentReceipt: "https://example.com/receipts/rent_11.pdf",
    waterReceipt: null,
    energyReceipt: "https://example.com/receipts/energy_11.pdf",
    gasReceipt: null,
  ),
  Payment(
    id: 12,
    date: DateTime(2023, 2, 11),
    amount: 550000,
    isRentPaid: true,
    isWaterPaid: true,
    isEnergyPaid: true,
    isGasPaid: true,
    idRent: 90411,
    createdAt: DateTime(2023, 2, 12),
    updatedAt: DateTime(2024, 2, 12),
    rentReceipt: "https://example.com/receipts/rent_12.pdf",
    waterReceipt: "https://example.com/receipts/water_12.pdf",
    energyReceipt: "https://example.com/receipts/energy_12.pdf",
    gasReceipt: "https://example.com/receipts/gas_12.pdf",
  ),
  // Continúa de manera similar para los meses de marzo a noviembre...

  // Pagos de renta del 12 de enero a diciembre
  Payment(
    id: 21,
    date: DateTime(2023, 1, 12),
    amount: 600000,
    isRentPaid: true,
    isWaterPaid: true,
    isEnergyPaid: false,
    isGasPaid: false,
    idRent: 90412,
    createdAt: DateTime(2023, 1, 13),
    updatedAt: DateTime(2024, 1, 13),
    rentReceipt: "https://example.com/receipts/rent_21.pdf",
    waterReceipt: "https://example.com/receipts/water_21.pdf",
    energyReceipt: null,
    gasReceipt: null,
  ),
  Payment(
    id: 22,
    date: DateTime(2023, 2, 12),
    amount: 600000,
    isRentPaid: true,
    isWaterPaid: true,
    isEnergyPaid: true,
    isGasPaid: true,
    idRent: 90412,
    createdAt: DateTime(2023, 2, 13),
    updatedAt: DateTime(2024, 2, 13),
    rentReceipt: "https://example.com/receipts/rent_22.pdf",
    waterReceipt: "https://example.com/receipts/water_22.pdf",
    energyReceipt: "https://example.com/receipts/energy_22.pdf",
    gasReceipt: "https://example.com/receipts/gas_22.pdf",
  ),
  // Continúa de manera similar para los meses de marzo a diciembre...
];
