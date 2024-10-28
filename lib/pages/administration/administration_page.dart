import 'package:flutter/material.dart';
import '../administration/tenants/tenant_management_page.dart';
import 'payments/payments_management_page.dart';
import '../administration/properties/propeties_management_page.dart';
import '../administration/rents/rents_management_page.dart';

class BuscarPage extends StatefulWidget {
  const BuscarPage({super.key});

  @override
  _BuscarPageState createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Administración',
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
              children: [
                const Text('Filtrar', style: TextStyle(fontSize: 16.0)),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white),
                    onPressed: () {
                      // Acción para el filtro
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Lista de secciones
            Expanded(
              child: ListView(
                children: [
                  SectionCard(
                    icon: Icons.house,
                    title: 'Propiedades',
                    logs: 2,
                    updateTime: '06h',
                    backgroundColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PropertiesManagementPage(),
                        ),
                      );
                    },
                  ),
                  SectionCard(
                    icon: Icons.home_work,
                    title: 'Alquileres',
                    logs: 4,
                    updateTime: '25d',
                    backgroundColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RentsManagementPage(),
                        ),
                      );
                    },
                  ),
                  SectionCard(
                    icon: Icons.people,
                    title: 'Inquilinos',
                    logs: 10,
                    updateTime: '23h',
                    backgroundColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TenantsManagementPage(),
                        ),
                      );
                    },
                  ),
                  SectionCard(
                    icon: Icons.attach_money,
                    title: 'Plan de Pagos',
                    logs: 80,
                    updateTime: 'Hace 1 año',
                    backgroundColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentPlanManagement(),
                        ),
                      );
                    },
                  ),
                  SectionCard(
                    icon: Icons.attach_money,
                    title: 'Registros de auditoría',
                    logs: 80,
                    updateTime: 'Hace 02h',
                    backgroundColor: Colors.orange,
                    onTap: () {},
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
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text('Actualizado hace $updateTime'),
        onTap: onTap,
      ),
    );
  }
}
