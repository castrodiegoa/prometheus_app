import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prometheus_app/widgets/custom_button.dart';
import 'dart:io';
import '../../../database/mock_data.dart';

class PaymentMonthDetail extends StatefulWidget {
  final Payment payment;
  final int rentId;

  const PaymentMonthDetail(
      {super.key, required this.payment, required this.rentId});

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
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Detalle de Pago'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'ID de alquiler: ${widget.rentId}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22.0),
                  ),
                ),
                const SizedBox(height: 8.0),
                Center(
                  child: Text(
                    '${DateFormat('MMMM', 'es_ES').format(widget.payment.date)[0].toUpperCase()}${DateFormat('MMMM', 'es_ES').format(widget.payment.date).substring(1)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Payment details
                _buildDetailRow('Id pago', widget.payment.id.toString()),
                const SizedBox(height: 8.0),
                _buildDetailRow('Monto', '\$${amount.toStringAsFixed(2)}'),
                const SizedBox(height: 8.0),

                // Rent is paid checkbox
                _buildCheckboxRow(
                  'Alquiler pago',
                  rentPaid,
                  (value) {
                    setState(() {
                      rentPaid = value!;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                // Rent receipt image picker
                _buildImagePickerRow(
                  rentReceiptImage,
                  'Recibo alquiler',
                  (File? image) {
                    setState(() {
                      rentReceiptImage = image;
                    });
                  },
                ),
                const SizedBox(height: 8.0),

                // Water service checkbox
                _buildCheckboxRow(
                  'Servicio de agua pago',
                  waterPaid,
                  (value) {
                    setState(() {
                      waterPaid = value!;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                // Water receipt image picker
                _buildImagePickerRow(
                  waterReceiptImage,
                  'Recibo agua',
                  (File? image) {
                    setState(() {
                      waterReceiptImage = image;
                    });
                  },
                ),
                const SizedBox(height: 8.0),

                // Energy service checkbox
                _buildCheckboxRow(
                  'Servicio de energía pago',
                  energyPaid,
                  (value) {
                    setState(() {
                      energyPaid = value!;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                // Energy receipt image picker
                _buildImagePickerRow(
                  energyReceiptImage,
                  'Recibo energía',
                  (File? image) {
                    setState(() {
                      energyReceiptImage = image;
                    });
                  },
                ),
                const SizedBox(height: 8.0),

                // Gas service checkbox
                _buildCheckboxRow(
                  'Servicio de gas pago',
                  gasPaid,
                  (value) {
                    setState(() {
                      gasPaid = value!;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                // Gas receipt image picker
                _buildImagePickerRow(
                  gasReceiptImage,
                  'Recibo gas',
                  (File? image) {
                    setState(() {
                      gasReceiptImage = image;
                    });
                  },
                ),
                const SizedBox(height: 8.0),

                // Date details
                _buildDetailRow('Fecha de pago',
                    DateFormat('dd/MM/yyyy').format(widget.payment.date)),
                const SizedBox(height: 8.0),
                _buildDetailRow('Creado el',
                    DateFormat('dd/MM/yyyy').format(widget.payment.createdAt)),
                const SizedBox(height: 8.0),
                _buildDetailRow('Actualizado el',
                    DateFormat('dd/MM/yyyy').format(widget.payment.updatedAt)),
                const SizedBox(height: 30),

                Center(
                  child: CustomButton(
                    text: 'Guardar Cambios',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
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
          style: const TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
        Text(value,
            style: const TextStyle(fontSize: 16.0, color: Colors.black)),
      ],
    );
  }

  Widget _buildCheckboxRow(
      String label, bool value, Function(bool?) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center, // Alineación vertical
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16.0, color: Colors.grey),
          ),
        ),
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildImagePickerRow(
      File? receiptImage, String receiptLabel, Function(File?) onImagePicked) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(receiptLabel,
                style: const TextStyle(fontSize: 16.0, color: Colors.grey)),

            // Botón de Descargar
            OutlinedButton(
              onPressed: () {
                // Acción para descargar el archivo
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minimumSize: const Size(60, 20),
              ),
              child:
                  const Text('Descargar', style: TextStyle(color: Colors.grey)),
            ),

            // Botón de Cargar
            OutlinedButton(
              onPressed: () {
                _pickImage(onImagePicked);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.orange),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Bordes redondeados
                ),
                minimumSize: const Size(60, 20),
              ),
              child:
                  const Text('Cargar', style: TextStyle(color: Colors.orange)),
            ),
          ],
        ),
      ],
    );
  }
}
