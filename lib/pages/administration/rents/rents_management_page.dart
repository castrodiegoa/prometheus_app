import 'package:flutter/material.dart';
import 'package:prometheus_app/pages/administration/rents/new_rent_page.dart'; // Importar NewRentPage
import 'package:prometheus_app/pages/administration/rents/edit_rent_page.dart'; // Importar EditRentPage

class RentsManagementPage extends StatelessWidget {
  // Lista de alquileres estáticos simulados
  final List<Map<String, String>> rents = [
    {
      'id': '1',
      'tenant': 'Juan Pérez',
      'amount': '\$800,000',
      'status': 'Pagado',
      'dueDate': '2024-11-01',
      'property': 'Apartamento 101'
    },
    {
      'id': '2',
      'tenant': 'Ana García',
      'amount': '\$1,200,000',
      'status': 'Pendiente',
      'dueDate': '2024-11-05',
      'property': 'Casa 202'
    },
    {
      'id': '3',
      'tenant': 'Carlos López',
      'amount': '\$900,000',
      'status': 'Retrasado',
      'dueDate': '2024-10-15',
      'property': 'Apartamento 301'
    },
    {
      'id': '4',
      'tenant': 'Lucía Martínez',
      'amount': '\$950,000',
      'status': 'Pagado',
      'dueDate': '2024-11-10',
      'property': 'Casa 405'
    },
  ];

  RentsManagementPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      appBar: AppBar(
        title: Center(
          child: Text(
            'Alquileres',
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                  hintText: 'Buscar alquiler',
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
                const Text(
                  'Filtrar',
                  style: TextStyle(fontSize: 16.0),
                ),
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
                      // Mostrar el modal de filtros
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return _buildFilterModal(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Lista de alquileres
            Expanded(
              child: ListView.builder(
                itemCount: rents.length,
                itemBuilder: (context, index) {
                  final rent = rents[index];
                  return SectionCard(
                    icon: Icons.receipt_long_outlined,
                    title:
                        rent['tenant'] ?? 'Sin nombre', // Nombre del inquilino
                    description:
                        'Monto: ${rent['amount'] ?? 'Sin monto'} - Estado: ${rent['status'] ?? 'Desconocido'}', // Monto y estado
                    backgroundColor: Colors.green.shade100, // Color verde claro
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditRentPage(
                            entityId: rent['id'] ??
                                '0', // Asegurarse de que no sea nulo
                            entityData: rent,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Botón "Nuevo Alquiler"
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewRentPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Center(
                child: Text(
                  'Nuevo Alquiler',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterModal(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título centrado
          Text(
            'Aplicar Filtros',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center, // Centramos el texto
          ),
          SizedBox(height: 20),

          // Dropdown de filtro
          Row(
            children: [
              Expanded(
                child: Text(
                  'Estado del Alquiler',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: 'Pagado',
                  items: <String>['Pagado', 'Pendiente', 'Retrasado']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Acción al cambiar el filtro
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Botón de aplicar filtros
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el modal
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
            child: Text(
              'Aplicar Filtros',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color backgroundColor;
  final VoidCallback onTap;

  SectionCard({
    required this.icon,
    required this.title,
    required this.description,
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
          child: Icon(icon, color: Colors.green.shade400, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(description),
        onTap: onTap,
      ),
    );
  }
}
