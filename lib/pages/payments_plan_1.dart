import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prometheus_app/database/mock_data.dart';
import 'package:prometheus_app/pages/payments_plan_details_2.dart'; // Asegúrate de importar la vista de detalles

class PaymentPlanManagement extends StatelessWidget {
  //Vista de pagos principal
  const PaymentPlanManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Payments Plan'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Barra de búsqueda
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Botón de sorteo
              Row(
                children: [
                  const Text('Sorter'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.filter_alt_outlined),
                    onPressed: () {
                      // Acción para ordenar la lista
                    },
                  ),
                ],
              ),

              // Botón de eliminar en grupo
              Row(
                children: [
                  const Text('Delete in group'),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Acción de eliminar
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Lista de arriendos
              Expanded(
                child: ListView.builder(
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final payment = payments[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      leading: const CircleAvatar(
                        backgroundColor: Colors.pink,
                        child: Icon(Icons.receipt_long, color: Colors.white),
                      ),
                      title: Text(
                        'Tenant ${payment.idRent}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Since ${DateFormat('dd/MM/yyyy').format(payment.date)}\nUntil ${DateFormat('dd/MM/yyyy').format(payment.date.add(const Duration(days: 365)))}',
                      ),
                      trailing: Radio(
                        value: payment.id,
                        groupValue:
                            1, // Aquí debes manejar el valor de selección real
                        onChanged: (value) {
                          // Acción al seleccionar un arriendo
                        },
                      ),
                      onTap: () {
                        // Navegar a los detalles del plan de pago
                        Get.to(
                            () => PaymentPlanDetails(rentId: payment.idRent));
                      },
                    );
                  },
                ),
              ),

              // Botón de nuevo arriendo
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Acción para agregar nuevo arriendo
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('New'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
