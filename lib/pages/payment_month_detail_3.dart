import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; // Paquete para seleccionar imágenes
import 'dart:io'; // Para manejar archivos locales
import '../database/mock_data.dart';
//import 'package:intl/intl_browser.dart'; // Asegurar localización

class PaymentMonthDetail extends StatefulWidget {
  final Payment payment;
  final int rentId;

  const PaymentMonthDetail(
      {Key? key, required this.payment, required this.rentId})
      : super(key: key);

  @override
  _PaymentMonthDetailState createState() => _PaymentMonthDetailState();
}

class _PaymentMonthDetailState extends State<PaymentMonthDetail> {
  late double amount;
  late bool rentPaid;
  late bool waterPaid;
  late bool energyPaid;
  late bool gasPaid;

  // Atributos para los recibos (imágenes)
  File? rentReceiptImage;
  File? waterReceiptImage;
  File? energyReceiptImage;
  File? gasReceiptImage;

  // Función para seleccionar una imagen
  Future<void> _pickImage(Function(File?) onImagePicked) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      onImagePicked(pickedFile != null ? File(pickedFile.path) : null);
    });
  }

  @override
  void initState() {
    super.initState();
    amount = widget.payment.amount;
    rentPaid = widget.payment.isRentPaid;
    waterPaid = widget.payment.isWaterPaid;
    energyPaid = widget.payment.isEnergyPaid;
    gasPaid = widget.payment.isGasPaid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Plan de Pagos'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rent ID and Month
              Text(
                'ID de alquiler: ${widget.rentId}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 22.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                DateFormat('MMMM', 'es_ES').format(widget
                    .payment.date), // Asegura el formato correcto en español
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              const SizedBox(height: 16.0),

              // Payment details
              _buildDetailRow('Id pago', widget.payment.id.toString()),
              const SizedBox(height: 8.0),
              _buildDetailRow('Monto', '\$${amount.toStringAsFixed(2)}'),
              const SizedBox(height: 16.0),

              // Rent is paid checkbox and vouchers (recibos)
              _buildCheckboxRowWithVouchers(
                'Alquiler pago',
                rentPaid,
                (value) {
                  setState(() {
                    rentPaid = value!;
                  });
                },
                rentReceiptImage,
                'Recibo de alquiler',
                (File? image) {
                  rentReceiptImage = image;
                },
              ),
              const SizedBox(height: 8.0),

              // Water service checkbox and vouchers
              _buildCheckboxRowWithVouchers(
                'Servicio de agua pago',
                waterPaid,
                (value) {
                  setState(() {
                    waterPaid = value!;
                  });
                },
                waterReceiptImage,
                'Recibo del agua',
                (File? image) {
                  waterReceiptImage = image;
                },
              ),
              const SizedBox(height: 8.0),

              // Energy service checkbox and vouchers
              _buildCheckboxRowWithVouchers(
                'Servicio de energía pago',
                energyPaid,
                (value) {
                  setState(() {
                    energyPaid = value!;
                  });
                },
                energyReceiptImage,
                'Recibo de la energía',
                (File? image) {
                  energyReceiptImage = image;
                },
              ),
              const SizedBox(height: 8.0),

              // Gas service checkbox and vouchers
              _buildCheckboxRowWithVouchers(
                'Servicio de gas pago',
                gasPaid,
                (value) {
                  setState(() {
                    gasPaid = value!;
                  });
                },
                gasReceiptImage,
                'Recibo del gas',
                (File? image) {
                  gasReceiptImage = image;
                },
              ),
              const SizedBox(height: 16.0),

              // Date details
              _buildDetailRow('Fecha',
                  DateFormat('dd/MM/yyyy').format(widget.payment.date)),
              _buildDetailRow('Creado el',
                  DateFormat('dd/MM/yyyy').format(widget.payment.createdAt)),
              _buildDetailRow('Actualizado el',
                  DateFormat('dd/MM/yyyy').format(widget.payment.updatedAt)),

              const Spacer(),

              // Save Changes button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Save action
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Guardar Cambios',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        Text(value, style: const TextStyle(fontSize: 16.0)),
      ],
    );
  }

  Widget _buildCheckboxRowWithVouchers(
      String label,
      bool value,
      Function(bool?) onChanged,
      File? receiptImage,
      String receiptLabel,
      Function(File?) onImagePicked) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(label, style: const TextStyle(fontSize: 16.0)),
                  Checkbox(
                    value: value,
                    onChanged: onChanged,
                  ),
                ],
              ),
            ),
            // Botón para cargar la imagen del recibo
            TextButton(
              onPressed: () {
                _pickImage(onImagePicked);
              },
              child: const Text('Cargar'),
            ),
          ],
        ),
        // Mostrar imagen o texto si se ha cargado un recibo
        receiptImage != null
            ? Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Image.file(
                  receiptImage,
                  height: 100.0,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: const Text(
                  'No se ha cargado ningún recibo',
                  style: TextStyle(fontSize: 14.0, color: Colors.redAccent),
                ),
              )
      ],
    );
  }
}
