import 'package:flutter/material.dart';

class EditTenantPage extends StatelessWidget {
  final String entityType = 'Inquilinos';
  final String entityId;
  final Map<String, dynamic> entityData;

  EditTenantPage({
    required this.entityId,
    required this.entityData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          entityType, // Muestra el tipo de entidad (Inquilinos)
          style: TextStyle(color: Colors.black),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // Mostrando la información del inquilino
            _buildInfoField('ID', entityId),
            _buildInfoField(
                'Documento', entityData['document'] ?? 'No disponible'),
            _buildInfoField(
                'Nombre', entityData['first_name'] ?? 'No disponible'),
            _buildInfoField(
                'Apellido', entityData['last_name'] ?? 'No disponible'),
            _buildInfoField('Teléfono principal',
                entityData['primary_phone_number'] ?? 'No disponible'),
            _buildInfoField('Teléfono secundario',
                entityData['secondary_phone_number'] ?? 'No disponible'),
            _buildInfoField(
                'Correo electrónico', entityData['email'] ?? 'No disponible'),
            _buildInfoField('Fecha de creación',
                entityData['created_at'] ?? 'No disponible'),
            _buildInfoField('Fecha de actualización',
                entityData['updated_at'] ?? 'No disponible'),

            Spacer(),

            // Botones de Eliminar y Actualizar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Acción para eliminar
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                  child: Text(
                    'Eliminar',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Acción para actualizar
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                  child: Text(
                    'Actualizar',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Método para construir los campos de visualización de la información
  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
