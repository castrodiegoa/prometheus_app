import 'package:flutter/material.dart';
import 'package:prometheus_app/pages/rentas_pag.dart';
import 'package:get/get.dart';
import 'package:prometheus_app/controllers/controlador_propiedad.dart';
import 'package:prometheus_app/controllers/controlador_usuario.dart'; // Importar el controlador de usuario

class PaginaInicio extends StatelessWidget {
  final PropiedadController propiedadController = Get.put(PropiedadController());
  final UsuarioController usuarioController = Get.put(UsuarioController()); // Instanciar el controlador de usuario

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.black),
                ),
                SizedBox(width: 8),
                Obx(() => Text(
                  usuarioController.obtenerNombreUsuario(), // Obtener el nombre del usuario
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_none),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner de registros recientes
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.insert_chart, size: 40),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Recents logs: (user) ha (action) un registro de (entity name) con id (id entity) el (date).',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: () {},
                      child: Text('Sell All Logs', style: TextStyle(color: Colors.orange)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Sección de acceso rápido
              Text('Acceso rápido', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 10),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                  onTap: () {
                    Get.to(() => RentasPage());
                  },
                  child: _quickAccessButton('Rentas', Icons.home_work),
                  ),
                  GestureDetector(
                  onTap: () {
                    // Acción al presionar el botón de Inquilinos
                  },
                  child: _quickAccessButton('Inquilinos', Icons.people),
                  ),
                  GestureDetector(
                  onTap: () {
                    // Acción al presionar el botón de Pagos
                  },
                  child: _quickAccessButton('Pagos', Icons.attach_money),
                  ),
                  GestureDetector(
                  onTap: () {
                    // Acción al presionar el botón de Propiedades
                  },
                  child: _quickAccessButton('Propiedades', Icons.house),
                  ),
                ],
                ),
              const SizedBox(height: 20),
              // Sección de relevantes
              const Text('Relevantes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
             _relevantItem('Alquileres activos', '${propiedadController.alquileresActivos()}'),
              _relevantItem('Propiedades alquiladas', '${propiedadController.propiedadesAlquiladas()}'),
              _relevantItem('Inquilinos activos', '${propiedadController.inquilinosActivos()}'),
              _relevantItem('Propiedades disponibles', '${propiedadController.propiedadesDisponibles()}'),
            ],
          ),
        ),
      ),
      // Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Establece el índice actual
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Casa'),
          const BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Administración'),
          const BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Estadísticas'),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configuración'),
        ],
      ),
    );
  }

  // Widget para ítems de acceso rápido
  Widget _quickAccessButton(String title, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, size: 30, color: Colors.teal),
        ),
        const SizedBox(height: 6),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Widget para ítems relevantes
  Widget _relevantItem(String title, String logs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(logs),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: Text('Ver más', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}


