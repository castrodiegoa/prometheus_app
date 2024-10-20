import 'package:flutter/material.dart';

class EditEntityPage extends StatelessWidget {
  final String entityType;
  final String entityId;
  final Map<String, dynamic> entityData;

  EditEntityPage({
    required this.entityType,
    required this.entityId,
    required this.entityData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          entityType, // Muestra el tipo de entidad (Properties, Rentals, Tenants)
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // Mostrando la información del alquiler, propiedad o inquilino
            _buildInfoField('Start Date', entityData['start_date']),
            _buildInfoField('End Date', entityData['end_date']),
            _buildInfoField('ID', entityId),
            _buildInfoField('Amount', entityData['amount']),
            _buildInfoField('Total Persons', entityData['total_persons']),
            _buildInfoField('Tenant', entityData['tenant']),
            _buildInfoField('Property', entityData['property']),
            _buildInfoField('Status', entityData['status']),
            _buildInfoField('Agreement', 'Download'),
            _buildInfoField('Number of Months of Rent', entityData['months_of_rent']),
            _buildInfoField('Created At', entityData['created_at']),
            _buildInfoField('Updated At', entityData['updated_at']),

            Spacer(),

            // Botones de Delete y Update
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
                    'Delete',
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
                    'Update',
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
