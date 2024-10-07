import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prometheus_app/database/mock_data.dart';
import 'package:prometheus_app/pages/payment_month_detail_3.dart'; // Importar la vista del detalle de pagos del mes

class PaymentPlanDetails extends StatelessWidget {
  final int rentId;

  const PaymentPlanDetails({Key? key, required this.rentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filtramos los pagos que corresponden a este rentId
    List<Payment> rentPayments =
        payments.where((payment) => payment.idRent == rentId).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Payments Plan Details'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ID del arriendo
              Text(
                'Rent ID: $rentId',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              const SizedBox(height: 16.0),

              // Lista de pagos por mes
              Expanded(
                child: ListView.builder(
                  itemCount: rentPayments.length,
                  itemBuilder: (context, index) {
                    final payment = rentPayments[index];
                    String month = DateFormat('MMMM').format(payment.date);
                    String amount =
                        NumberFormat.currency(locale: 'es_CO', symbol: '\$')
                            .format(payment.amount);

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      leading: const CircleAvatar(
                        backgroundColor: Colors.pink,
                        child: Icon(Icons.receipt_long, color: Colors.white),
                      ),
                      title: Text(
                        month,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(amount),
                      onTap: () {
                        // Navegar a la vista de detalle del mes
                        Get.to(() => PaymentMonthDetail(payment: payment));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
