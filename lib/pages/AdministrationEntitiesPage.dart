import 'package:flutter/material.dart';
import 'package:prometheus_app/pages/NewRentPage.dart'; // Asegúrate de importar la página NewRentPage
import 'package:prometheus_app/pages/EditEntityPage.dart';  // La página de edición también debe estar importada

class AdministrationEntitiesPage extends StatelessWidget {
  final String sectionTitle;

  AdministrationEntitiesPage({required this.sectionTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          sectionTitle,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
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
                  hintText: 'Search $sectionTitle',
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
                    // Mostrar el modal de filtros
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return _buildFilterModal(context);
                      },
                    );
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

            // Lista de items correspondientes a la sección seleccionada
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
                          builder: (context) => EditEntityPage(
                            entityType: 'Properties',
                            entityId: '090410',
                            entityData: {
                              'start_date': '13/07/2024',
                              'end_date': '13/07/2025',
                              'amount': '\$500.000',
                              'total_persons': '4',
                              'tenant': 'José Guillén',
                              'property': 'Casa 2x2 Calle 32',
                              'status': 'Activo',
                              'months_of_rent': '12',
                              'created_at': '13/07/2024',
                              'updated_at': '13/07/2024'
                            },
                          ),
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
                          builder: (context) => EditEntityPage(
                            entityType: 'Rentals',
                            entityId: '090410',
                            entityData: {
                              'start_date': '13/07/2024',
                              'end_date': '13/07/2025',
                              'amount': '\$500.000',
                              'total_persons': '4',
                              'tenant': 'José Guillén',
                              'property': 'Casa 2x2 Calle 32',
                              'status': 'Activo',
                              'months_of_rent': '12',
                              'created_at': '13/07/2024',
                              'updated_at': '13/07/2024'
                            },
                          ),
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
                          builder: (context) => EditEntityPage(
                            entityType: 'Tenants',
                            entityId: '090410',
                            entityData: {
                              'start_date': '13/07/2024',
                              'end_date': '13/07/2025',
                              'amount': '\$500.000',
                              'total_persons': '4',
                              'tenant': 'José Guillén',
                              'property': 'Casa 2x2 Calle 32',
                              'status': 'Activo',
                              'months_of_rent': '12',
                              'created_at': '13/07/2024',
                              'updated_at': '13/07/2024'
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  // Agrega más items si es necesario
                ],
              ),
            ),

            // Botón "New" en la parte inferior
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewRentPage()), // Navegar a la página de nuevo alquiler
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Center(
                child: Text(
                  'New',
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
            'Set Filters',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center, // Centramos el texto
          ),
          SizedBox(height: 20),

          // Dropdown de filtro (solo diseño por el momento)
          Row(
            children: [
              Expanded(
                child: Text(
                  'Property',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: 'ID',
                  items: <String>['ID', 'Name', 'Date'].map((String value) {
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
              // Acción al aplicar los filtros
              Navigator.pop(context); // Cerrar el modal
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Cambiado de 'primary' a 'backgroundColor'
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
            child: Text(
              'Apply Filters',
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


