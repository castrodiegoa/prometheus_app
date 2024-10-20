import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Necesario para inicializar los formatos de fechas locales
import 'package:prometheus_app/database/mock_data.dart';
import 'package:prometheus_app/pages/payment_month_detail_3.dart'; // Importar la vista del detalle de pagos del mes

class PaymentPlanDetails extends StatelessWidget {
  final int rentId;

  const PaymentPlanDetails({Key? key, required this.rentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializar el formato de fechas en español antes de usarlo
    initializeDateFormatting('es_ES', null);

    // Filtramos los pagos que corresponden a este rentId
    List<Payment> rentPayments =
        payments.where((payment) => payment.idRent == rentId).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Detalle del Plan de Pagos'),
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
                'ID de alquiler: $rentId',
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
                    //String month = DateFormat('MMMM', 'es_ES').format(payment.date);
                    String amount =
                        NumberFormat.currency(locale: 'es_CO', symbol: '\$')
                            .format(payment.amount);

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0), // Margen alrededor del contenedor
                      decoration: BoxDecoration(
                        color: Colors.white, // Fondo blanco
                        borderRadius:
                            BorderRadius.circular(12.0), // Bordes redondeados
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.3), // Sombra ligera
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // Desplazamiento de la sombra
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0), // Padding interno del ListTile
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink.shade100,
                          child: Icon(Icons.receipt_long_outlined,
                              color:
                                  Colors.pink.shade400), // Ícono personalizado
                        ),
                        title: Text(
                          '${DateFormat('MMMM', 'es_ES').format(payment.date)[0].toUpperCase()}${DateFormat('MMMM', 'es_ES').format(payment.date).substring(1)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold), // Estilo de título
                        ),
                        subtitle: Text(amount),
                        onTap: () {
                          // Navegar a la vista de detalle del mes
                          Get.to(() => PaymentMonthDetail(
                              payment: payment, rentId: rentId));
                        },
                      ),
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
