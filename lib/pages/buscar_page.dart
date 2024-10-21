import 'package:flutter/material.dart';
import 'package:prometheus_app/pages/payments_plan_1.dart'; // Importación de Payments Plan
import 'package:prometheus_app/pages/AdministrationEntitiesPage.dart'; // Importar AdministrationEntitiesPage

class BuscarPage extends StatefulWidget {
  @override
  _BuscarPageState createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      appBar: AppBar(
        title: Center(
          child: Text(
            'Administración', // Título centrado
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Barra de búsqueda
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  suffixIcon: Icon(Icons.close, color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Fila de filtro y botón de configuración
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtrar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Acción para el botón de filtro
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(12),
                    backgroundColor: Colors.orange,
                  ),
                  child: Icon(Icons.tune, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Lista de secciones
            Expanded(
              child: ListView(
                children: [
                  SectionCard(
                    icon: Icons.home,
                    title: 'Propiedades',
                    logs: 2,
                    updateTime: '06h',
                    backgroundColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdministrationEntitiesPage(
                            sectionTitle: 'Propiedades',
                            items: [
                              {'title': 'Propiedad 90410', 'description': 'Desde 10/01/2023 Hasta 10/01/2024'},
                              {'title': 'Propiedad 90411', 'description': 'Desde 11/01/2023 Hasta 11/01/2024'},
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SectionCard(
                    icon: Icons.apartment,
                    title: 'Alquileres',
                    logs: 4,
                    updateTime: '25d',
                    backgroundColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdministrationEntitiesPage(
                            sectionTitle: 'Alquileres',
                            items: [
                              {'title': 'Alquiler 90410', 'description': 'Desde 10/01/2023 Hasta 10/01/2024'},
                              {'title': 'Alquiler 90411', 'description': 'Desde 11/01/2023 Hasta 11/01/2024'},
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SectionCard(
                    icon: Icons.person,
                    title: 'Inquilinos',
                    logs: 10,
                    updateTime: '23h',
                    backgroundColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdministrationEntitiesPage(
                            sectionTitle: 'Inquilinos',
                            items: [
                              {'title': 'Inquilino José Guillén', 'description': 'Contrato desde 10/01/2023'},
                              {'title': 'Inquilino María Ramírez', 'description': 'Contrato desde 12/01/2023'},
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SectionCard(
                    icon: Icons.attach_money,
                    title: 'Plan de Pagos', // Manteniendo el título de Plan de Pagos
                    logs: 80,
                    updateTime: 'Hace 1 año',
                    backgroundColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPlanManagement(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int logs;
  final String updateTime;
  final Color backgroundColor;
  final VoidCallback onTap;

  SectionCard({
    required this.icon,
    required this.title,
    required this.logs,
    required this.updateTime,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: backgroundColor,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        title: Text(
          '$logs registros - $title',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text('Actualizado hace $updateTime'),
        onTap: onTap,
      ),
    );
  }
}

