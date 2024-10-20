import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prometheus_app/database/mock_data.dart';
import 'package:prometheus_app/pages/payments_plan_details_2.dart'; // Asegúrate de importar la vista de detalles

class PaymentPlanManagement extends StatefulWidget {
  const PaymentPlanManagement({super.key});

  @override
  _PaymentPlanManagementState createState() => _PaymentPlanManagementState();
}

class _PaymentPlanManagementState extends State<PaymentPlanManagement> {
  final TextEditingController _searchController = TextEditingController();
  // Obtener IDs únicos de arriendos
  final uniqueRentIds =
      payments.map((payment) => payment.idRent).toSet().toList();

  // int?
  //     _selectedPaymentId; // Variable para manejar el valor seleccionado en el Radio

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Pagos'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Barra de búsqueda personalizada
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, // Fondo gris claro
                  borderRadius:
                      BorderRadius.circular(20.0), // Bordes redondeados
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (text) {
                    setState(
                        () {}); // Redibujar para actualizar la barra de búsqueda
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: 'Buscar', // Texto de búsqueda
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0), // Centrar el texto
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.grey), // Botón de cerrar
                            onPressed: () {
                              _searchController.clear();
                              setState(() {}); // Actualizar al limpiar el texto
                            },
                          )
                        : null, // Mostrar la "X" solo si hay texto
                  ),
                ),
              ),

              const SizedBox(height: 16.0), // Espacio vertical

              // Botón de filtro personalizado
              Row(
                children: [
                  const Text('Filtrar', style: TextStyle(fontSize: 16.0)),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange, // Fondo naranja
                      borderRadius:
                          BorderRadius.circular(12.0), // Bordes redondeados
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune,
                          color: Colors.white), // Ícono blanco de filtro
                      onPressed: () {
                        // Acción para el filtro
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),

              Expanded(
                child: ListView.builder(
                  itemCount: uniqueRentIds.length,
                  itemBuilder: (context, index) {
                    final rentId = uniqueRentIds[index];
                    // Encuentra el primer pago correspondiente al ID de arriendo
                    final payment =
                        payments.firstWhere((p) => p.idRent == rentId);

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink.shade100,
                          child: Icon(Icons.receipt_long_outlined,
                              color: Colors.pink.shade400),
                        ),
                        title: Text(
                          'Alquiler $rentId',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Desde ${DateFormat('dd/MM/yyyy').format(payment.date)}\nHasta ${DateFormat('dd/MM/yyyy').format(payment.date.add(const Duration(days: 365)))}',
                        ),
                        onTap: () {
                          Get.to(() => PaymentPlanDetails(rentId: rentId));
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
