import 'package:flutter/material.dart';
import 'package:prometheus_app/controllers/tenant_controller.dart';
import 'package:prometheus_app/models/tenant_model.dart';
import 'package:prometheus_app/pages/administration/tenants/new_tenant_page.dart';
import 'package:prometheus_app/pages/administration/tenants/edit_tenant_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TenantsManagementPage extends StatefulWidget {
  @override
  _TenantsManagementPageState createState() => _TenantsManagementPageState();
}

class _TenantsManagementPageState extends State<TenantsManagementPage> {
  final TenantController _tenantController = TenantController();
  List<Tenant> _tenants = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTenants();
  }

  Future<void> _loadTenants() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      _tenants = await _tenantController.getTenants(currentUser.uid);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar los inquilinos: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Inquilinos',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Barra de búsqueda (igual que en la implementación anterior)
            // ...

            // Barra de búsqueda
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar inquilino',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  suffixIcon: Icon(Icons.close, color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Fila de filtro y botón de configuración (igual que en la implementación anterior)
            // ...
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
            const SizedBox(height: 20),

            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_tenants.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No hay inquilinos registrados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _tenants.length,
                  itemBuilder: (context, index) {
                    final tenant = _tenants[index];
                    return SectionCard(
                      icon: Icons.person_outline,
                      title: '${tenant.firstName} ${tenant.lastName}',
                      description:
                          'Contrato desde ${tenant.createdAt?.toString() ?? 'N/A'}',
                      backgroundColor: Colors.green.shade100,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTenantPage(
                              entityId: tenant.id,
                              entityData: tenant.toFirestore(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewTenantPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Center(
                child: Text(
                  'Nuevo Inquilino',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // El método _buildFilterModal se mantiene igual que en la implementación anterior
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
                  'Propiedad',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: 'ID',
                  items: <String>['ID', 'Nombre', 'Fecha'].map((String value) {
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(description),
        onTap: onTap,
      ),
    );
  }
}
