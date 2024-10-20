import 'package:flutter/material.dart';
import 'package:prometheus_app/pages/payments_plan_1.dart';
import 'package:prometheus_app/pages/AdministrationEntitiesPage.dart';

class BuscarPage extends StatefulWidget {
  @override
  _BuscarPageState createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Administration',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              // Acción para el ícono de notificaciones
            },
          ),
        ],
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
                  hintText: 'Search',
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
                  'Sorter',
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
                    title: 'Properties',
                    logs: 2,
                    updateTime: '06h',
                    backgroundColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdministrationEntitiesPage(sectionTitle: 'Properties'),
                        ),
                      );
                    },
                  ),
                  SectionCard(
                    icon: Icons.apartment,
                    title: 'Rentals',
                    logs: 4,
                    updateTime: '25d',
                    backgroundColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdministrationEntitiesPage(sectionTitle: 'Rentals'),
                        ),
                      );
                    },
                  ),
                  SectionCard(
                    icon: Icons.person,
                    title: 'Tenants',
                    logs: 10,
                    updateTime: '23h',
                    backgroundColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdministrationEntitiesPage(sectionTitle: 'Tenants'),
                        ),
                      );
                    },
                  ),
                  SectionCard(
                    icon: Icons.attach_money,
                    title: 'Payments Plan',
                    logs: 80,
                    updateTime: '1y',
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
          '$logs logs - $title',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text('Updated at $updateTime'),
        onTap: onTap,
      ),
    );
  }
}

