import 'package:flutter/material.dart';

class EditRentPage extends StatelessWidget {
  final String entityId;
  final Map<String, dynamic> entityData;

  EditRentPage({
    required this.entityId,
    required this.entityData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Renta', // Muestra el tipo de entidad (Propiedades, Alquileres, Inquilinos)
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

            // Mostrando la información del alquiler, propiedad o inquilino
            _buildInfoField(
                'Fecha de inicio', entityData['start_date'] ?? 'No disponible'),
            _buildInfoField(
                'Fecha de fin', entityData['end_date'] ?? 'No disponible'),
            _buildInfoField('ID', entityId),
            _buildInfoField('Monto', entityData['amount'] ?? 'No disponible'),
            _buildInfoField('Número de personas',
                entityData['total_persons']?.toString() ?? 'No disponible'),
            _buildInfoField('Inquilino', entityData['tenant'] ?? 'Desconocido'),
            _buildInfoField(
                'Propiedad', entityData['property'] ?? 'Sin propiedad'),
            _buildInfoField('Estado', entityData['status'] ?? 'Sin estado'),
            _buildInfoField('Contrato', 'Descargar'),
            _buildInfoField('Número de meses de alquiler',
                entityData['months_of_rent']?.toString() ?? 'No disponible'),
            _buildInfoField(
                'Creado en', entityData['created_at'] ?? 'No disponible'),
            _buildInfoField(
                'Actualizado en', entityData['updated_at'] ?? 'No disponible'),

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
