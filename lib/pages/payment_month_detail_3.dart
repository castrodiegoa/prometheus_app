import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prometheus_app/database/mock_data.dart';

class PaymentMonthDetail extends StatefulWidget {
  final Payment payment;

  const PaymentMonthDetail({Key? key, required this.payment}) : super(key: key);

  @override
  _PaymentMonthDetailState createState() => _PaymentMonthDetailState();
}

class _PaymentMonthDetailState extends State<PaymentMonthDetail> {
  late double amount;
  late bool isPaid;
  late bool isConfirmed;

  @override
  void initState() {
    super.initState();
    amount = widget.payment.amount;
    isPaid = widget.payment.isRentPaid;
    isConfirmed = widget.payment.isEnergyPaid;
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
        title: const Text('Payment Details'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment for: ${DateFormat('MMMM yyyy').format(widget.payment.date)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              const SizedBox(height: 16.0),

              // Monto del pago
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    amount = double.tryParse(value) ?? widget.payment.amount;
                  });
                },
                controller: TextEditingController(
                  text: amount.toString(),
                ),
              ),
              const SizedBox(height: 16.0),

              // Checkbox para isPaid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Is Paid?'),
                  Checkbox(
                    value: isPaid,
                    onChanged: (value) {
                      setState(() {
                        isPaid = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Checkbox para isConfirmed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Is Confirmed?'),
                  Checkbox(
                    value: isConfirmed,
                    onChanged: (value) {
                      setState(() {
                        isConfirmed = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Botón para guardar cambios
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Acción para guardar los cambios
                    // Aquí podrías actualizar la base de datos o el estado de la app
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
