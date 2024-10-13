import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prometheus_app/database/mock_data.dart';

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
        title: const Text('Payments Plan'),
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
                'Rent ID: ${widget.rentId}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 22.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                DateFormat('MMMM').format(widget.payment.date),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              const SizedBox(height: 16.0),

              // Payment details
              _buildDetailRow('Id payment', widget.payment.id.toString()),
              const SizedBox(height: 8.0),
              _buildDetailRow('Amount', '\$${amount.toStringAsFixed(2)}'),
              const SizedBox(height: 16.0),

              // Rent is paid checkbox
              _buildCheckboxRow('Rent is paid', rentPaid, (value) {
                setState(() {
                  rentPaid = value!;
                });
              }),
              const SizedBox(height: 8.0),

              // Water service checkbox
              _buildCheckboxRow('Water service is paid', waterPaid, (value) {
                setState(() {
                  waterPaid = value!;
                });
              }),
              const SizedBox(height: 8.0),

              // Energy service checkbox
              _buildCheckboxRow('Energy service is paid', energyPaid, (value) {
                setState(() {
                  energyPaid = value!;
                });
              }),
              const SizedBox(height: 8.0),

              // Gas service checkbox
              _buildCheckboxRow('Gas service is paid', gasPaid, (value) {
                setState(() {
                  gasPaid = value!;
                });
              }),
              const SizedBox(height: 16.0),

              // Date details
              _buildDetailRow(
                  'Date', DateFormat('dd/MM/yyyy').format(widget.payment.date)),
              _buildDetailRow('Created at',
                  DateFormat('dd/MM/yyyy').format(widget.payment.createdAt)),
              _buildDetailRow('Updated at',
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
                    'Save Changes',
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

  Widget _buildCheckboxRow(
      String label, bool value, Function(bool?) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16.0)),
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
